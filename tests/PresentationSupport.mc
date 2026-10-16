using Toybox.Test;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Math;
using Toybox.WatchUi;

// Independent requirement oracle; do not read Catalog.HEADERS_WITH_UNITS here.
(:testSupport)
function expectedUnitHeader(index,unit,hideUnits) {
    if(hideUnits || unit.length()==0) { return Catalog.LABELS[index]; }
    var headers=["speed | {unit}","avg | {unit}","cad | rpm","avg cad | rpm","hr | {unit}","avg hr | bpm",null,
        "watts","3s watts","avg watts",null,"distance | {unit}","elevation | {unit}","ascent | {unit}",
        "descent | {unit}","slope | %",null,null,null,"kcal","temp | {unit}","battery | {unit}",
        "heading | {unit}","next | {unit}",null,"3s hr | {unit}","lap dist | {unit}",null,"lap | {unit}",
        "lap hr | bpm","lap watts","lap cad | rpm"];
    var text=headers[index];
    if(text==null || text.length()==0) { return Catalog.LABELS[index]+" | "+unit; }
    var marker=text.find("{unit}");
    return marker==null?text:text.substring(0,marker)+unit+text.substring(marker+6,text.length());
}

(:testSupport)
function profileDrawWidth() {
    if("edge550".equals(DeviceProfile.ID) || "edge850".equals(DeviceProfile.ID)) { return 420; }
    if("edge1050".equals(DeviceProfile.ID)) { return 480; }
    return "edge1030".equals(DeviceProfile.ID) || "edge1040".equals(DeviceProfile.ID)?282:246;
}
(:testSupport)
function profileDrawHeight() {
    if("edge550".equals(DeviceProfile.ID) || "edge850".equals(DeviceProfile.ID)) { return 600; }
    if("edge1050".equals(DeviceProfile.ID)) { return 800; }
    return "edge1030".equals(DeviceProfile.ID) || "edge1040".equals(DeviceProfile.ID)?470:322;
}

(:testSupport)
class PresentationDevice {
    var distanceUnits;
    var elevationUnits;
    var temperatureUnits;
    var is24Hour;
    var isNightModeEnabled;
    function initialize(statute,clock24,night) {
        distanceUnits=statute?System.UNIT_STATUTE:System.UNIT_METRIC;
        elevationUnits=distanceUnits; temperatureUnits=distanceUnits;
        is24Hour=clock24; isNightModeEnabled=night;
    }
}
(:testSupport)
class PresentationClock {
    var hour=13;
    var min=5;
}


// Record actual production drawing calls, with deterministic measurements and
// real loaded font heights. No bitmap allocation or duplicated renderer logic.
(:testSupport)
class PresentationDrawDc {
    var records=[];
    var lines=[];
    var clearBackground;
    var _color;
    var _background;
    var _record;
    var _width;
    var _height;
    var _measurement;
    var _bitmap;
    var paintEffects=[];
    var _drawCount=0;
    var _cellIndex=-1;
    var _clip=null;
    function initialize(width,height) {
        _width=width; _height=height;
        if(Graphics has :createBufferedBitmap) {
            _bitmap=Graphics.createBufferedBitmap({:width=>1,:height=>1});
            _measurement=_bitmap.get().getDc();
            return;
        }
        _bitmap=new Graphics.BufferedBitmap({:width=>1,:height=>1});
        _measurement=_bitmap.getDc();
    }
    function getWidth() { return _width; }
    function getHeight() { return _height; }
    function getTextWidthInPixels(text,font) {
        return _measurement.getTextWidthInPixels(text,font);
    }
    function setColor(color,background) { _color=color; _background=background; }
    function clear() { clearBackground=_background; }
    function setClip(x,y,w,h) {
        if(_record==null) {
            _cellIndex+=1; _drawCount=0;
            _record={:x=>x,:y=>y,:w=>w,:h=>h,:background=>null,:texts=>[],:halos=>[],:rectangles=>[],:fills=>[],:polygons=>[]};records.add(_record);
        }
        _clip=[x,y,w,h];
    }
    function clearClip() { _record=null;_clip=null; }
    function fillRectangle(x,y,w,h) {
        if(_record[:background]==null) { _record[:background]=_color; }
        _record[:rectangles].add([x,y,w,h]);
        _record[:fills].add(_color);
    }
    function fillPolygon(points) { _record[:polygons].add({:color=>_color,:points=>points}); }
    function drawLine(x1,y1,x2,y2) { lines.add(_color); }
    function drawText(x,y,font,text,flags) {
        if(_record!=null) {
            Test.assertEqual(Graphics.COLOR_TRANSPARENT,_background);
            var effect=_cellIndex<paintEffects.size() && paintEffects[_cellIndex];
            var grade=_record[:polygons].size()>0;
            var count=effect && (grade || _drawCount<9)?9:1;
            var logical=grade?_drawCount/count:(effect?(_drawCount<9?0:_drawCount-8):_drawCount);
            var height=Graphics.getFontHeight(font);
            var metrics=logical==1?FontMetrics.numeric(height):FontMetrics.label(height);
            var ink=FontMetrics.bounds(text,metrics);
            var drawing={:inkTop=>y+ink[0],:inkBottom=>y+ink[1],:x=>x,:y=>y,:width=>getTextWidthInPixels(text,font),:height=>height,:text=>text,:color=>_color,:group=>logical,:flags=>flags,:clip=>_clip};
            if(_drawCount%count==count-1) { _record[:texts].add(drawing); }
            else { _record[:halos].add(drawing); }
            _drawCount+=1;
        }
    }
}

// Smaller helpers retain the same matrix and assertions on constrained VM stacks.
(:testSupport)
function assertGridDrawingEqual(expected,actual) {
    if(expected instanceof Toybox.Lang.Array) {
        Test.assertEqual(expected.size(),actual.size());
        for(var i=0;i<expected.size();i+=1) { assertGridDrawingEqual(expected[i],actual[i]); }
    } else if(expected instanceof Toybox.Lang.Dictionary) {
        Test.assertEqual(expected.size(),actual.size());var keys=expected.keys();
        for(var k=0;k<keys.size();k+=1) { Test.assert(actual.hasKey(keys[k]));assertGridDrawingEqual(expected[keys[k]],actual[keys[k]]); }
    } else { Test.assertEqual(expected,actual); }
}

(:testSupport)
class GridTypeDrawDc extends PresentationDrawDc {
    var segments=[];
    function initialize(width,height) { PresentationDrawDc.initialize(width,height); }
    function drawLine(x1,y1,x2,y2) {
        PresentationDrawDc.drawLine(x1,y1,x2,y2);segments.add([x1,y1,x2,y2,_color]);
    }
}

(:testSupport)
class GridTypeScenario {
    var props;var settings;var snapshot;var renderer;var baseline;var dc;
    var layouts;var loads;var fits;var geometry;
    function initialize(index) {
        props={"alignment"=>index%2,"enlarged_field_count"=>(index/2)%3,
            "theme_mode"=>(index/6)%2==1?2:1,"inverse_enlarged_theme"=>(index/12)%2==1,
            "slot_1_value"=>"grade","slot_1_background_effects"=>true,
            "slot_2_value"=>"current_heart_rate","slot_2_background_effects"=>true};
        settings=new DisplaySettings();settings.apply(props);
        snapshot=new SnapshotEngine().prepareWithPreferences({"grade"=>3.4,"current_heart_rate"=>160,
            "current_speed"=>10,"distance"=>12345,"activity_timer"=>65000,"elevation"=>123},
            settings,true,new PresentationDevice(false,true,(index/6)%2==1),new PresentationClock());
        renderer=new FieldRenderer();renderer.prepare(snapshot);
    }
    function drawing() {
        dc=new GridTypeDrawDc(profileDrawWidth(),profileDrawHeight());
        for(var i=0;i<snapshot[:values].size();i+=1) {
            dc.paintEffects.add(snapshot[:values][i][:band]!=null || snapshot[:values][i][:angle]!=null);
        }
        renderer.draw(dc,snapshot,settings);
    }
    function checkSegments(type) {
        var expected=0;
        for(var i=0;i<renderer._cells.size();i+=1) {
            var c=renderer._cells[i];if(c[:enlarged] || type==0) { continue; }
            if(type==1 || c[:y]+c[:h]<profileDrawHeight()) { expected+=16; }
            if(type==2 && c[:x]>0) { expected+=16; }
        }
        Test.assertEqual(expected,dc.segments.size());
        for(var n=0;n<dc.segments.size();n+=1) {
            var line=dc.segments[n];var horizontal=line[1]==line[3];
            Test.assert(horizontal || type==2);Test.assert(line[0]>=0 && line[2]<profileDrawWidth());
            Test.assert(line[1]>=0 && line[3]<profileDrawHeight());
            var q;
            if(type==1) { q=6*(n%16+1); }
            else {
                if(horizontal) { Test.assert(line[1]<profileDrawHeight()-1); }
                else { Test.assertEqual(profileDrawWidth()/2,line[0]); }
                var p=horizontal?(line[0]+line[2])/2.0:(line[1]+line[3])/2.0;
                var bound=horizontal?profileDrawWidth():profileDrawHeight();
                q=Math.floor(96*(1.0-(p-bound/2.0).abs()/(bound/2.0))).toNumber();
            }
            Test.assertEqual(("night".equals(settings.theme)?q:255-q)*0x010101,line[4]);
        }
    }
    function run() {
        dc=new GridTypeDrawDc(profileDrawWidth(),profileDrawHeight());renderer.layout(dc,settings);
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,settings.enlarged),renderer._cells.size());
        drawing();baseline=dc.records;
        layouts=renderer.layoutCount;loads=renderer.fontLoads;fits=renderer.fitCount;geometry=renderer.geometryBuilds;
        var types=[1,0,2,0,1,2];
        for(var pass=0;pass<types.size();pass+=1) {
            props["grid_type"]=types[pass];settings.apply(props);renderer.configure(settings);renderer.prepare(snapshot);drawing();
            checkSegments(types[pass]);assertGridDrawingEqual(baseline,dc.records);
            Test.assertEqual(layouts,renderer.layoutCount);Test.assertEqual(loads,renderer.fontLoads);
            Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);
        }
    }
}

(:testSupport)
function verifyPresentationDraw(mode,baseNight,inverse,big,align,requireComplete) {
    var engine=new SnapshotEngine(); var clock=new PresentationClock();
    var settings=new DisplaySettings();
    settings.apply({"slot_1_value"=>"current_speed","slot_2_value"=>"current_speed",
        "slot_3_value"=>"temperature","slot_4_value"=>"heading","slot_5_value"=>"activity_timer",
        "slot_6_value"=>"time_of_day","slot_7_value"=>"current_cadence", "slot_8_value"=>"battery",
        "use_units_as_labels"=>mode%2==1,"hide_value_units"=>mode/2==1,
        "theme_mode"=>baseNight==1?2:1,"inverse_enlarged_theme"=>inverse==1,
        "enlarged_field_count"=>big,"alignment"=>align});
    var snapshot=engine.prepareWithPreferences({"current_speed"=>0,"average_speed"=>0,"temperature"=>10,
        "heading"=>0,"activity_timer"=>36000000,"battery"=>0},settings,true,new PresentationDevice(false,false,baseNight==1),clock);
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
    var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.prepare(snapshot);renderer.draw(dc,snapshot,settings);
    // Complete headers at fixed sizes can require compact fallback when units are shown.
    if(renderer._cells.size()==0) {
        Test.assert(!requireComplete);
        Test.assert(!settings.hideValueUnits);
        Test.assertEqual(0,dc.records.size());
        var message="";
        for(var line=0;line<renderer._compactLines.size();line+=1) {message+=(line>0?" ":"")+renderer._compactLines[line];}
        Test.assertEqual("full grid needs larger area",message);
        Test.assertEqual(baseNight==1?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE,dc.clearBackground);
        return;
    }
    var rows=renderer._cells.size()==Grid.capacity(DeviceProfile.DESIGN_ROWS,big)?DeviceProfile.DESIGN_ROWS:4;
    var cells=Grid.plan(dc.getWidth(),dc.getHeight(),rows,big);
    if(requireComplete) {
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,big),renderer._runs.size());
        for(var field=0;field<renderer._runs.size();field+=1) {
            Test.assertEqual(renderer.displayText(snapshot[:values][field]),renderer._runs[field][:text]);
            Test.assert(!PresentationPolicy.OVERFLOW.equals(renderer._runs[field][:text]));
        }
    }
    verifyDrawRecords(dc,renderer,snapshot,cells,baseNight,inverse,align);
}

(:testSupport)
function verifyDrawRecords(dc,renderer,snapshot,cells,baseNight,inverse,align) {
    Test.assertEqual(cells.size(),dc.records.size());
    Test.assertEqual(baseNight==1?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE,dc.clearBackground);
    for(var i=0;i<dc.records.size();i+=1) {
        var record=dc.records[i];var value=snapshot[:values][i];
        var night=(baseNight==1)!=(cells[i][:enlarged] && inverse==1);
        var radius=value[:band]!=null || value[:angle]!=null?1:0;
        var labelEffect=value[:band]!=null && value[:angle]==null;
        var expectedBackground=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var ordinaryForeground=night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
        Test.assertEqual(expectedBackground,record[:background]);
        Test.assertEqual(labelEffect?2:1,record[:rectangles].size()); // Cell plus optional label band; no text panels.
        Test.assertEqual(record[:x],record[:rectangles][0][0]);
        Test.assertEqual(record[:y],record[:rectangles][0][1]);
        Test.assertEqual(record[:w],record[:rectangles][0][2]);
        Test.assertEqual(record[:h],record[:rectangles][0][3]);
        if(labelEffect) {
            var band=record[:rectangles][1];
            Test.assertEqual(record[:x],band[0]);Test.assertEqual(record[:y],band[1]);
            Test.assertEqual(record[:w],band[2]);
            Test.assertEqual(DeviceProfile.LABEL_SIZE==21?30:46,band[3]);
            Test.assertEqual(renderer.color(value[:band]),record[:fills][1]);
        }
        if(value[:angle]!=null) {
            Test.assertEqual(1,record[:polygons].size());
            Test.assertEqual(renderer.color(value[:band]),record[:polygons][0][:color]);
        } else { Test.assertEqual(0,record[:polygons].size()); }
        var texts=record[:texts];
        Test.assertEqual(renderer._runs[i][:unit].length()>0?3:2,texts.size());
        Test.assertEqual(value[:label],texts[0][:text]);
        Test.assertEqual(record[:y]+3,texts[0][:y]);
        Test.assertEqual(renderer._runs[i][:text],texts[1][:text]);
        var headerBackground=labelEffect?renderer.color(value[:band]):expectedBackground;
        Test.assert(texts[0][:color]!=headerBackground);
        var headerDark=labelEffect?("yellow".equals(value[:band]) || "cyan".equals(value[:band]) ||
            "white".equals(value[:band]) || "green".equals(value[:band]) || "light_gray".equals(value[:band])):!night;
        Test.assertEqual(headerDark?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE,texts[0][:color]);
        Test.assertEqual(ordinaryForeground,texts[1][:color]);
        if(texts.size()==3) { Test.assertEqual(ordinaryForeground,texts[2][:color]); }
        Test.assertEqual(record[:h],texts[1][:clip][3]);
        if(labelEffect) {
            Test.assertEqual(record[:rectangles][1][3],texts[0][:clip][3]);
            Test.assert(record[:rectangles][1][3]>=texts[0][:inkBottom]-record[:y]+radius);
            Test.assert(texts[0][:inkTop]-radius>=record[:y]);
            Test.assert(texts[0][:inkBottom]+radius<=record[:y]+record[:rectangles][1][3]);
            Test.assert(texts[1][:inkTop]>=record[:y]+record[:rectangles][1][3]);
            if(texts.size()==3) { Test.assert(texts[2][:inkTop]>=record[:y]+record[:rectangles][1][3]); }
        }
        verifyGlyphHalo(record,radius,value[:angle]!=null);
        var inset=DeviceProfile.LABEL_SIZE==21?30:46;
        Test.assertEqual(inset,renderer._headerHeight);
        var center=record[:y]+inset+(record[:h]-inset)/2.0;
        Test.assert(((texts[1][:inkTop]+texts[1][:inkBottom])/2.0-center).abs()<=1);
        Test.assert(texts[1][:inkTop]-radius>=texts[0][:inkBottom]+radius+2);
        Test.assert(texts[1][:inkTop]-radius>=record[:y]+inset);
        Test.assert(texts[1][:inkBottom]+radius<=record[:y]+record[:h]);
        var total=texts[1][:width];
        if(texts.size()==3) {
            Test.assertEqual(renderer._runs[i][:unit],texts[2][:text]);
            Test.assertEqual(texts[1][:x]+texts[1][:width]+2,texts[2][:x]);
            Test.assertEqual(texts[1][:inkTop],texts[2][:inkTop]);
            total+=texts[2][:width]+2;
        }
        var expectedX=align==1?record[:x]+record[:w]-4-radius-total:record[:x]+(record[:w]-total)/2;
        if(expectedX!=texts[1][:x]) {
            System.println("DRAW_ALIGN field="+i+" header="+value[:label]+" band="+value[:band]+" align="+align+
                " expected="+expectedX+" actual="+texts[1][:x]+" margin="+renderer._runs[i][:margin]);
        }
        Test.assertEqual(expectedX,texts[1][:x]);
        Test.assert(texts[1][:x]-radius>=record[:x]+4 && texts[1][:x]+total+radius<=record[:x]+record[:w]-4);
    }
}

(:testSupport)
function verifyGlyphHalo(record,radius,grade) {
    var groups=grade?record[:texts].size():1;
    Test.assertEqual(radius==1?groups*8:0,record[:halos].size());
    for(var group=0;group<groups && radius==1;group+=1) {
        var main=record[:texts][group]; var offsets=[];
        for(var i=0;i<record[:halos].size();i+=1) {
            var halo=record[:halos][i]; if(halo[:group]!=group) { continue; }
            Test.assertEqual(main[:text],halo[:text]); Test.assertEqual(main[:height],halo[:height]);
            Test.assertEqual(main[:flags],halo[:flags]);
            Test.assertEqual(main[:clip][3],halo[:clip][3]);
            Test.assertEqual(main[:color]==Graphics.COLOR_BLACK?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,halo[:color]);
            var dx=halo[:x]-main[:x];var dy=halo[:y]-main[:y];
            Test.assert(dx.abs()<=1 && dy.abs()<=1 && (dx!=0 || dy!=0));
            var key=(dx+1)*3+dy+1;
            for(var j=0;j<offsets.size();j+=1) { Test.assert(offsets[j]!=key); }
            offsets.add(key);
        }
        Test.assertEqual(8,offsets.size());
    }
}

// Synthetic effect snapshots verify rendering, not personal-zone/sensor qualification.
(:testSupport)
class ColoredFieldScenario {
    var settings;var properties;var raw;var engine;var device;var clock;var snapshot;var dc;var renderer;var cells;
    var night;var align;var big;var inverse;
    function initialize(caseIndex) {
        var hideUnits=caseIndex%2;caseIndex/=2;
        inverse=caseIndex%2;caseIndex/=2;
        big=caseIndex%3;caseIndex/=3;
        align=caseIndex%2;caseIndex/=2;
        night=caseIndex%2;caseIndex/=2;
        var field=caseIndex;
        var ids=["grade","current_power","power_3s","average_power","current_heart_rate","heart_rate_3s","average_heart_rate","temperature"];
        var id=ids[field];
        settings=new DisplaySettings();
        properties={"slot_1_value"=>id,"slot_2_value"=>id,"slot_1_background_effects"=>true,"slot_2_background_effects"=>false,
            "enlarged_field_count"=>big,"alignment"=>align,"theme_mode"=>night==1?2:1,
            "inverse_enlarged_theme"=>inverse==1,"hide_value_units"=>hideUnits==1};
        settings.apply(properties);
        raw={};raw[id]=10;
        engine=new SnapshotEngine();device=new PresentationDevice(false,true,night==1);clock=new PresentationClock();
        snapshot=engine.prepareWithPreferences(raw,settings,true,device,clock);
        var colors=["green","yellow","cyan","white","blue","orange","red","dark_red","black"];
        if(field>0) { fixtureBand(snapshot,0,colors[(field+night+align+inverse+hideUnits)%colors.size()]); }
    }
    function run() {
        Test.assert(snapshot[:values][0][:band]!=null);
        Test.assert(snapshot[:values][1][:band]==null && snapshot[:values][1][:angle]==null);
        dc=new PresentationDrawDc(profileDrawWidth()*2,profileDrawHeight());
        for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
        renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.draw(dc,snapshot,settings);
        cells=Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,big);
        Test.assertEqual(cells.size(),renderer._runs.size());
        verifyDrawRecords(dc,renderer,snapshot,cells,night,inverse,align);
        for(var state=0;state<2;state+=1) {
            properties["slot_1_background_effects"]=state==1;settings.apply(properties);
            snapshot=engine.prepareWithPreferences(state==1?{}:raw,settings,true,device,clock);
            if(state==0) { Test.assert(snapshot[:values][0][:band]==null); }
            else { Test.assertEqual((night==1)!=(big>0 && inverse==1)?"dark_gray":"light_gray",snapshot[:values][0][:band]); }
            Test.assert(snapshot[:values][0][:angle]==null);
            renderer.prepare(snapshot);
            dc=new PresentationDrawDc(dc.getWidth(),dc.getHeight());
            for(var p=0;p<snapshot[:values].size();p+=1) { dc.paintEffects.add(snapshot[:values][p][:band]!=null || snapshot[:values][p][:angle]!=null); }
            renderer.draw(dc,snapshot,settings);
            verifyDrawRecords(dc,renderer,snapshot,cells,night,inverse,align);
            Test.assertEqual(state==0?0:8,dc.records[0][:halos].size());
            Test.assertEqual(state==0?1:2,dc.records[0][:rectangles].size());
        }
    }
}

(:testSupport)
function verifyWhiteTemperatureContrast() {
    var engine=new SnapshotEngine(); var clock=new PresentationClock();
    // White semantic temperature band must survive both inversion directions.
    for(var night=0;night<2;night+=1) {
        var settings=new DisplaySettings();var props={"enlarged_field_count"=>0,"theme_mode"=>night==1?2:1};
        for(var slot=1;slot<=10;slot+=1) {
            props["slot_"+slot.toString()+"_value"]="temperature";
            props["slot_"+slot.toString()+"_background_effects"]=true;
        }
        settings.apply(props);
        var snapshot=engine.prepareWithPreferences({"temperature"=>5},settings,true,new PresentationDevice(false,true,night==1),clock);
        var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
        for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
        var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.prepare(snapshot);renderer.draw(dc,snapshot,settings);
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._runs.size());
        for(var f=0;f<renderer._runs.size();f+=1) { Test.assertEqual("5.0",renderer._runs[f][:text]); }
        Test.assertEqual(night==1?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE,dc.records[0][:background]);
        Test.assertEqual(Graphics.COLOR_WHITE,dc.records[0][:fills][1]);
        Test.assertEqual(Graphics.COLOR_BLACK,dc.records[0][:texts][0][:color]);
        Test.assertEqual(night==1?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,dc.records[0][:texts][1][:color]);

    }

}



(:testSupport)
function normalDisplayRaw(index,displayed,statute) {
    var unit=Catalog.UNITS[index];
    if("speed".equals(unit)) { return displayed/(statute?2.2369362921:3.6); }
    if("distance".equals(unit)) { return displayed*(statute?1609.344:1000.0); }
    if("elevation".equals(unit)) { return displayed/(statute?3.280839895:1.0); }
    if("temperature".equals(unit)) { return statute?(displayed-32)/1.8:displayed; }
    if("degrees".equals(unit)) { return displayed*Math.PI/180.0; }
    return displayed;
}


// APP-49/DVS-6: classify all fields, then exercise neutral repaint transitions.
(:testSupport)
function verifyNeutralLabelBands() {
    var custom=[4,5,7,8,9,15,20,25];
    var engine=new SnapshotEngine();var settings=new DisplaySettings();
    for(var index=0;index<Catalog.IDS.size();index+=1) {
        var expectedCustom=false;
        for(var k=0;k<custom.size();k+=1) { if(index==custom[k]) { expectedCustom=true; } }
        Test.assertEqual(expectedCustom,Effects.hasCustomBackground(Catalog.IDS[index]));
        settings.apply({"slot_1_value"=>Catalog.IDS[index],"slot_1_background_effects"=>true});
        var missing=engine.prepareWithPreferences({},settings,false,new PresentationDevice(false,true,false),null)[:values][0];
        Test.assertEqual("light_gray",missing[:band]);Test.assert(missing[:angle]==null);
    }
    settings.apply({"slot_1_value"=>"unknown_field","slot_1_background_effects"=>true});
    Test.assert(engine.initial(settings)[:values][0][:band]==null);
}

// Actual semantic selection must override gray, including valid zero values.
(:testSupport)
class CustomBackgroundScenario {
    var id;var index;var value;var color;var gray;var night;var big;
    var engine;var settings;var props;var raw;var snapshot;
    function initialize(fieldIndex,mode) {
        index=fieldIndex;
        var ids=["grade","temperature","current_heart_rate","heart_rate_3s","average_heart_rate","current_power","power_3s","average_power"];
        id=ids[index];value=index==0?6.8:(index==1?5:(index<5?160:250));
        color=index==1?"white":(index<5?"orange":"yellow");
        night=mode%2;big=mode/2;
        gray=(night==1)!=(big==1)?"dark_gray":"light_gray";
        props={"slot_1_value"=>id,"slot_2_value"=>id,"slot_1_background_effects"=>true,
            "slot_2_background_effects"=>false,"theme_mode"=>night==1?2:1,"enlarged_field_count"=>big,"inverse_enlarged_theme"=>true};
        settings=new DisplaySettings();settings.apply(props);engine=new SnapshotEngine();
        qualify();
    }
    function qualify() {
        engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
        // Synthetic qualified metadata for semantic selection, never production provenance.
        engine._powerZones=ZoneMetadata.power([0,100,200,300,400,500,650,1000],true);
    }
    function sample() {
        snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
        Test.assert(snapshot[:values][1][:band]==null);
    }
    function run() {
        raw={};sample();Test.assertEqual(gray,snapshot[:values][0][:band]);Test.assert(snapshot[:values][0][:angle]==null);
        raw[id]=value;sample();Test.assertEqual(color,snapshot[:values][0][:band]);
        Test.assertEqual(index==0?"6.8":(index==1?"5.0":(index<5?"160":"250")),snapshot[:values][0][:text]);
        if(index==0) { Test.assertEqual(13.6,snapshot[:values][0][:angle]); }
        else { Test.assert(snapshot[:values][0][:angle]==null); }
        raw[id]=0;sample();
        if(index==0) { Test.assertEqual("green",snapshot[:values][0][:band]);Test.assertEqual(0.0,snapshot[:values][0][:angle]); }
        else if(index==1) { Test.assertEqual("cyan",snapshot[:values][0][:band]); }
        else { Test.assertEqual(index<5?gray:"blue",snapshot[:values][0][:band]); }
        raw[id]=value;
        if(index>=2) {
            engine._hrZones=null;engine._powerZones=null;sample();
            Test.assertEqual(gray,snapshot[:values][0][:band]);Test.assertEqual(index<5?"160":"250",snapshot[:values][0][:text]);
            qualify();
        }
        sample();Test.assertEqual(color,snapshot[:values][0][:band]);
        props["slot_1_background_effects"]=false;settings.apply(props);sample();Test.assert(snapshot[:values][0][:band]==null);
        props["slot_1_background_effects"]=true;settings.apply(props);sample();Test.assertEqual(color,snapshot[:values][0][:band]);
        raw={};sample();Test.assertEqual(gray,snapshot[:values][0][:band]);Test.assert(snapshot[:values][0][:angle]==null);
    }
}

// Keep scenario state off the constrained VM stack, as in ColoredFieldScenario.
(:testSupport)
class NeutralBandScenario {
    var night;var inverse;var big;var props;var settings;var renderer;var engine;
    var raw;var snapshot;var gray;var dc;var cells;var fixedBand;
    function initialize(caseIndex) {
        big=caseIndex%3;caseIndex/=3;inverse=caseIndex%2;night=caseIndex/2;
        props={"theme_mode"=>night==1?2:1,"inverse_enlarged_theme"=>inverse==1,
            "enlarged_field_count"=>big,"alignment"=>(big+inverse)%2,"hide_value_units"=>inverse==0,
            "slot_1_value"=>"current_speed","slot_2_value"=>"current_speed",
            "slot_1_background_effects"=>true,"slot_2_background_effects"=>false,
            "slot_10_value"=>"current_speed","slot_10_background_effects"=>true};
        settings=new DisplaySettings();renderer=new FieldRenderer();engine=new SnapshotEngine();
        fixedBand=renderer._labelBandHeight;
        Test.assertEqual(DeviceProfile.LABEL_SIZE==21?30:46,fixedBand);
        gray=(night==1)!=(big>0 && inverse==1)?"dark_gray":"light_gray";
    }
    function run() {
        for(var state=0;state<6;state+=1) {
            props["slot_1_value"]=state>=3?(state==5?"lap_speed":"grade"):"current_speed";
            props["slot_1_background_effects"]=state!=2;
            settings.apply(props);
            raw=state==1 || state==3?{}:{"current_speed"=>1,"grade"=>1,"lap_speed"=>1};
            snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
            if(state==0 || state==1 || state==3 || state==5) { Test.assertEqual(gray,snapshot[:values][0][:band]); }
            if(state==2) { Test.assert(snapshot[:values][0][:band]==null); }
            Test.assert(snapshot[:values][1][:band]==null);
            Test.assertEqual(night==1?"dark_gray":"light_gray",snapshot[:values][9][:band]);
            dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
            for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
            renderer.prepare(snapshot);
            if(state==0) { renderer.layout(dc,settings); }
            renderer.draw(dc,snapshot,settings);
            Test.assertEqual(fixedBand,renderer._labelBandHeight);
            cells=Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,big);
            Test.assertEqual(cells.size(),renderer._runs.size());
            verifyDrawRecords(dc,renderer,snapshot,cells,night,inverse,(big+inverse)%2);
            if(state==0 || state==1 || state==3 || state==5) {
                Test.assertEqual("dark_gray".equals(gray)?0x333333:0xCCCCCC,dc.records[0][:fills][1]);
            }
        }
    }
}

// Supported native assignments exercise real drawing in all layouts/alignments.
// Other fields' narrower ranges and unavailable contexts are tested separately.
(:testSupport)
function verifyGuaranteedNormalDraw(night,big,align) {
    var settings=new DisplaySettings();
    var props={"theme_mode"=>night==1?2:1,"enlarged_field_count"=>big,"alignment"=>align,"hide_value_units"=>true};
    var ids=["current_speed","current_heart_rate","activity_timer","battery","current_power","grade"];
    for(var slot=0;slot<10;slot+=1) {
        props["slot_"+(slot+1).toString()+"_value"]=ids[slot%ids.size()];
        props["slot_"+(slot+1).toString()+"_background_effects"]=true;
    }
    settings.apply(props);
    var snapshot=new SnapshotEngine().prepareWithPreferences({"current_speed"=>1,"current_heart_rate"=>150,"activity_timer"=>65000,
        "battery"=>50,"current_power"=>250,"grade"=>5.1},settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    for(var i=0;i<snapshot[:values].size();i+=1) { dc.paintEffects.add(snapshot[:values][i][:band]!=null || snapshot[:values][i][:angle]!=null); }
    var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.draw(dc,snapshot,settings);
    var cells=Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,big);
    Test.assertEqual(cells.size(),renderer._runs.size());
    for(var field=0;field<cells.size();field+=1) {
        Test.assertEqual(snapshot[:values][field][:text],renderer._runs[field][:text]);
        Test.assert(!PresentationPolicy.OVERFLOW.equals(renderer._runs[field][:text]));
    }
    verifyDrawRecords(dc,renderer,snapshot,cells,night,1,align);
}

// Synthetic colors own their replacement record; production snapshot records are immutable.
(:testSupport)
function fixtureBand(snapshot,slot,band) {
    var original=snapshot[:values][slot];
    snapshot[:values][slot]={:label=>original[:label],:text=>original[:text],:unit=>original[:unit],
        :expandedUnit=>original[:expandedUnit],:band=>band,:angle=>original[:angle],:format=>original[:format]};
}
