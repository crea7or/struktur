using Toybox.Test;
using Toybox.Graphics;
using Toybox.WatchUi;

// Deliberate overflow, reduced areas and compact-message scenarios. Request only.
(:test)
function proportionalCaptionFit(logger) {
    var settings=new DisplaySettings();settings.apply({});
    var renderer=new FieldRenderer();
    // APP-24 is a fixed reference table, independent of repeated fitting.
    Test.assert(DeviceProfile.BIG_SIZE>DeviceProfile.REGULAR_SIZE);
    Test.assert(DeviceProfile.REGULAR_SIZE>DeviceProfile.LABEL_SIZE);
    var reference=WatchUi.loadResource(FontSelection.info(DeviceProfile.REGULAR_SIZE,false)[0]);
    Test.assertEqual(FontSelection.info(DeviceProfile.REGULAR_SIZE,false)[1],Graphics.getFontHeight(reference));
    var initialSnapshot=new SnapshotEngine().initial(settings);
    renderer.prepare(initialSnapshot);renderer.layout(new PresentationDrawDc(profileDrawWidth(),profileDrawHeight()),settings);
    Test.assert(renderer._cells.size()>0);
    Test.assertEqual(8,Grid.plan(246,322,4,settings.enlarged).size());
    Test.assertEqual(0,settings.enlarged);
    // Real production draw path, all APP-20 combinations represented by these
    // nine profiles, both alignments, and complete durations or explicit overflow.
    var durationInputs=[35999000,36000000,86400000,360000000];
    var mainTexts=["9:59","10:00","24:00","100:00"];
    var secondaryTexts=[".59","","",""];
    for(var big=0;big<=2;big+=1) {
        for(var align=0;align<=1;align+=1) {
            for(var durationCase=0;durationCase<durationInputs.size();durationCase+=1) {
                var input={"enlarged_field_count"=>big,"alignment"=>align};
                for(var slot=1;slot<=10;slot+=1) { input["slot_"+slot.toString()+"_value"]=slot%2==0?17:16; }
                var durationSettings=new DisplaySettings();durationSettings.apply(input);
                var engine=new SnapshotEngine();
                var snapshot=engine.prepare({"activity_timer"=>durationInputs[durationCase],"elapsed_time"=>durationInputs[durationCase]},durationSettings,true);
                var dc=new DurationDrawDc(mainTexts[durationCase],secondaryTexts[durationCase],align==1);
                var durationRenderer=new FieldRenderer();durationRenderer.prepare(snapshot);durationRenderer.layout(dc,durationSettings);durationRenderer.prepare(snapshot);
                durationRenderer.draw(dc,snapshot,durationSettings);
                Test.assertEqual(mainTexts[durationCase],snapshot[:values][0][:text]);
                Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,big),dc.mainCount+dc.overflowCount);
                Test.assertEqual(durationCase==0?dc.mainCount:0,dc.secondaryCount);
            }
        }
    }
    return true;
}

(:test)
function actualValueFitAndCompactCache(logger) {
    var s=new DisplaySettings();s.apply({"slot_1_value"=>19,"use_units_as_labels"=>false});
    var e=new SnapshotEngine();var r=new FieldRenderer();var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    var value=e.prepare({"calories"=>9999999},s,true);r.prepare(value);r.layout(dc,s);
    Test.assertEqual(PresentationPolicy.OVERFLOW,r._runs[0].text);var fixed=r._runs[0].size;
    value=e.prepare({"calories"=>1},s,true);r.prepare(value);
    Test.assertEqual(fixed,r._runs[0].size);Test.assertEqual(DeviceProfile.REGULAR_SIZE,fixed);Test.assert(!r.needsLayout());
    var compact=new PresentationDrawDc(220,FontSelection.height(DeviceProfile.LABEL_SIZE,true)*5);r.layout(compact,s);
    var message="";
    for(var i=0;i<r._compactLines.size();i+=1) { message+=(i>0?" ":"")+r._compactLines[i]; }
    Test.assertEqual("full grid needs larger area",message);
    var layouts=r.layoutCount;var loads=r.fontLoads;
    for(var j=0;j<10;j+=1) { r.prepare(value);r.draw(compact,value,s); }
    Test.assertEqual(layouts,r.layoutCount);Test.assertEqual(loads,r.fontLoads);Test.assert(!r.needsLayout());
    r.layout(new PresentationDrawDc(40,60),s);Test.assertEqual(0,r._compactLines.size());
    r.layout(new PresentationDrawDc(2,2),s);Test.assertEqual(0,r._compactLines.size());
    return true;
}

(:test)
function presentationDrawAndAlignment(logger) {
    for(var mode=0;mode<4;mode+=1) {
        for(var baseNight=0;baseNight<2;baseNight+=1) {
            for(var inverse=0;inverse<2;inverse+=1) {
                for(var big=0;big<=2;big+=1) {
                    for(var align=0;align<2;align+=1) {
                        verifyPresentationDraw(mode,baseNight,inverse,big,align,false);
                    }
                }
            }
        }
    }
    verifyWhiteTemperatureContrast();
    for(var caseIndex=0;caseIndex<384;caseIndex+=1) { new ColoredFieldScenario(caseIndex).run(); }
    return true;
}

// Explicitly unsupported native combinations are verified only on request.
(:test)
function documentedUnsupportedCombinations(logger) {
    verifyTeamInsufficientArea();
    var cases=NormalLimits.unsupported();var renderer=new FieldRenderer();
    var settings=new DisplaySettings();var engine=new SnapshotEngine();
    for(var i=0;i<cases.size();i+=1) {
        var row=cases[i];var index=row[0];var point=[row[5],row[6],row[7]];
        settings.apply({"slot_1_value"=>Catalog.IDS[index],"hide_value_units"=>row[2]});
        var raw={};raw[Catalog.IDS[index]]=normalDisplayRaw(index,point[0],row[1]);
        var clock=new PresentationClock();
        if("clock".equals(Catalog.FORMATS[index])) { var minutes=point[0].toNumber();clock.hour=minutes/60;clock.min=minutes%60; }
        var value=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(row[1],row[3],false),clock)[:values][0];
        if(index==4 || index==5 || index==7 || index==8 || index==9 || index==25) { value[:band]="green"; }
        // Native role bounds; no assertion that an unavailable combination works.
        var cells=Grid.plan(profileDrawWidth(),profileDrawHeight(),DeviceProfile.DESIGN_ROWS,row[4]?1:0);
        var cell=row[4]?cells[0]:cells[cells.size()-1];
        Test.assert(renderer.fitRun(cell,value,DeviceProfile.LABEL_SIZE,value[:text],value[:unit])==null);
    }
    return true;
}

// SPEC-232: deliberately rejected bank bounds belong only to Placement.
(:test)
function secondaryFieldSetPlacement(logger) {
    var properties={"second_set_trigger"=>3,"second_enlarged_field_count"=>2};
    for(var slot=1;slot<=10;slot+=1) {
        properties["slot_"+slot+"_value"]="current_power";
        properties["second_slot_"+slot+"_value"]="current_power";
    }
    var renderer=new FieldRenderer();var engine=new SnapshotEngine();
    var raw={"current_power"=>0};
    var large=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    var small=new PresentationDrawDc(100,100);
    for(var alignment=0;alignment<2;alignment+=1) {
        for(var grid=0;grid<3;grid+=1) {
            properties["alignment"]=alignment;properties["second_alignment"]=alignment;
            properties["grid_type"]=grid;properties["second_grid_type"]=grid;
            var banks=new FieldSetsSettings();banks.apply(properties);var c=new FieldSetController(banks);
            var snap=engine.prepareWithPreferences(raw,c.active(),true,new PresentationDevice(false,true,false),null);
            renderer.configure(c.active());renderer.prepare(snap);renderer.layout(large,c.active());
            Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._cells.size());
            c.lap(true);snap=engine.prepareWithPreferences(raw,c.active(),true,new PresentationDevice(false,true,false),null);
            renderer.configure(c.active());renderer.prepare(snap);renderer.layout(small,c.active());
            Test.assertEqual(0,renderer._cells.size());Test.assert(c.second);
            renderer.layout(small,c.active());Test.assert(c.second);
            c.lap(true);snap=engine.prepareWithPreferences(raw,c.active(),true,new PresentationDevice(false,true,false),null);
            renderer.configure(c.active());renderer.prepare(snap);renderer.layout(large,c.active());
            Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._cells.size());Test.assert(!c.second);
        }
    }
    return true;
}

(:testSupport)
function verifyTeamInsufficientArea() {
    var fonts=new NativeTextCache();fonts.setContext(new PresentationDrawDc(profileDrawWidth(),profileDrawHeight()));
    var value={:text=>"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",:nativeFont=>0};
    var run=fonts.fit({:w=>20,:h=>200},value);Test.assertEqual(PresentationPolicy.OVERFLOW,run.text);
    run=fonts.fit({:w=>1,:h=>1},value);Test.assertEqual("",run.text);
    value[:text]="";run=fonts.fit({:w=>20,:h=>20},value);Test.assertEqual("",run.text);
}
