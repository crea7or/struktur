using Toybox.Test;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.WatchUi;

(:testSupport)
function verifyEffectDefaultContract() {
    var settings=new DisplaySettings();
    for(var initial=0;initial<10;initial+=1) { Test.assertEqual(false,settings.effects[initial]); }
    Test.assertEqual(true,settings.hideValueUnits);Test.assertEqual(true,settings.inverseEnlargedTheme);
    var invalid=[null,0,1,"true","false",1.0];
    var properties={"enlarged_field_count"=>2};
    for(var candidate=0;candidate<invalid.size();candidate+=1) {
        for(var slot=1;slot<=10;slot+=1) { properties["slot_"+slot.toString()+"_background_effects"]=invalid[candidate]; }
        settings.apply(properties);
        for(var index=0;index<10;index+=1) { Test.assertEqual(false,settings.effects[index]); }
    }
    for(var saved=1;saved<=10;saved+=1) {
        properties["slot_"+saved.toString()+"_value"]="power_3s";
        properties["slot_"+saved.toString()+"_background_effects"]=saved%2==0;
    }
    settings.apply(properties);
    var restarted=new DisplaySettings();restarted.apply(properties);
    for(var retained=0;retained<10;retained+=1) {
        Test.assertEqual(retained%2==1,settings.effects[retained]);
        Test.assertEqual(settings.effects[retained],restarted.effects[retained]);
    }
    properties["enlarged_field_count"]=0;properties["slot_10_value"]="grade";
    restarted.apply(properties);
    Test.assertEqual(true,restarted.effects[9]);Test.assertEqual(false,restarted.effects[0]);
    Test.assertEqual("grade",restarted.slots[9]);
}

// Executable tests call production modules. They require the actual Connect IQ simulator.


// Actual resource heights with controlled text measurements reproduce the
// narrow-column fit that previously paired Label21 with Value22.
(:testSupport)
class CaptionFitDc {
    var _height;
    function initialize(height) { _height=height; }
    function getWidth() { return 246; }
    function getHeight() { return _height; }
    function getTextWidthInPixels(text,font) {
        var height=Graphics.getFontHeight(font);
        if("km/h".equals(text)) {
            return height<=13?20:(height<=17?29:43);
        }
        if("99999".equals(text) || "-9.99".equals(text)) {
            return height<=27?55:(height<=42?90:140);
        }
        return text.length()*height/3;
    }
}

(:testSupport)
class DurationDrawDc {
    var mainCount=0;
    var secondaryCount=0;
    var overflowCount=0;
    var _measure;
    var _mainText;
    var _secondaryText;
    var _right;
    var _clip;
    var _mainX;
    var _mainY;
    var _mainWidth;
    var _mainHeight;
    var _mainVisibleTop;
    var _labelHeight;
    function initialize(mainText,secondaryText,right) {
        _measure=new PresentationDrawDc(246,322);
        _mainText=mainText; _secondaryText=secondaryText; _right=right;
    }
    function getWidth() { return profileDrawWidth(); }
    function getHeight() { return profileDrawHeight(); }
    function getTextWidthInPixels(text,font) { return _measure.getTextWidthInPixels(text,font); }
    function setClip(x,y,w,h) { _clip={:x=>x,:y=>y,:w=>w,:h=>h}; }
    function clearClip() {}
    function setColor(a,b) {}
    function clear() {}
    function fillRectangle(x,y,w,h) {}
    function fillPolygon(points) {}
    function drawLine(x1,y1,x2,y2) {}
    function drawText(x,y,font,text,flags) {
        if(PresentationPolicy.OVERFLOW.equals(text)) {
            overflowCount+=1;
            var width=getTextWidthInPixels(text,font);
            Test.assert(x>=_clip[:x]+4 && x+width<=_clip[:x]+_clip[:w]-4);
            return;
        }
        if(_mainText.equals(text)) {
            _mainX=x; _mainY=y; _mainWidth=getTextWidthInPixels(text,font); _mainHeight=Graphics.getFontHeight(font);
            var ink=FontMetrics.bounds(text,FontMetrics.numeric(_mainHeight));
            _mainVisibleTop=y+ink[0];
            var inset=DeviceProfile.LABEL_SIZE==21?30:46;
            var center=_clip[:y]+inset+(_clip[:h]-inset)/2.0;
            Test.assert((_mainVisibleTop+(ink[1]-ink[0])/2.0-center).abs()<=1);
            Test.assert(x>=_clip[:x]+4 && x+_mainWidth<=_clip[:x]+_clip[:w]-4);
            Test.assert(_mainVisibleTop>=_clip[:y]+inset && y+ink[1]<=_clip[:y]+_clip[:h]);
            mainCount+=1;
        } else if(_secondaryText.equals(text)) {
            var secondaryWidth=getTextWidthInPixels(text,font);
            Test.assert(Graphics.getFontHeight(font)<_mainHeight);
            Test.assertEqual(_mainX+_mainWidth+2,x);
            Test.assertEqual(_mainVisibleTop,y+FontMetrics.bounds(text,FontMetrics.label(Graphics.getFontHeight(font)))[0]);
            Test.assert(x+secondaryWidth<=_clip[:x]+_clip[:w]-4);
            var total=_mainWidth+secondaryWidth+2;
            Test.assertEqual(_right?_clip[:x]+_clip[:w]-4-total:_clip[:x]+(_clip[:w]-total)/2,_mainX);
            secondaryCount+=1;
        } else {
            _labelHeight=Graphics.getFontHeight(font);
        }
    }
}



(:testSupport)
class MigrationStore {
    var values={};var writes=0;var failAt=-1;
    function initialize() {
        for(var bank=0;bank<2;bank+=1) {
            var defaults=bank==0?Catalog.defaultSlots():Catalog.secondaryDefaultSlots();
            for(var slot=1;slot<=10;slot+=1) {
                var p=(bank==1?"second_":"")+"slot_"+slot.toString();
                values[p+"_value"]=defaults[slot-1];values[p+"_background_mode"]=-1;
                values[p+"_background_effects"]=bank==1 && slot<=4;
            }
        }
        values["settings_schema_version"]=0;values["unrelated"]=42;
    }
    function get(key) { return values.hasKey(key)?values[key]:null; }
    function put(key,value) { writes+=1;if(writes==failAt) { throw new Toybox.Lang.InvalidValueException("injected write failure"); } values[key]=value; }
}
(:testSupport)
function verifyBackgroundMigration() {
    var store=new MigrationStore();store.values["slot_10_value"]="grade";store.values["slot_10_background_effects"]=true;
    store.values["second_slot_1_background_mode"]=0;
    var data=SettingsMigration.read(store,false);
    Test.assertEqual(2,data["slot_10_background_mode"]);Test.assertEqual(2,data["second_slot_4_background_mode"]);
    Test.assertEqual(0,data["second_slot_1_background_mode"]);Test.assertEqual(1,data["settings_schema_version"]);
    Test.assertEqual(true,store.values["slot_10_background_effects"]);Test.assertEqual(42,store.values["unrelated"]);
    var writes=store.writes;SettingsMigration.read(store,false);Test.assertEqual(writes,store.writes);
    store=new MigrationStore();data=SettingsMigration.read(store,true);
    Test.assertEqual(1,data["second_slot_4_background_mode"]);Test.assertEqual(0,data["slot_1_background_mode"]);
    store=new MigrationStore();store.failAt=5;data=SettingsMigration.read(store,false);
    Test.assertEqual(0,store.values["settings_schema_version"]);Test.assertEqual(-1,store.values["slot_5_background_mode"]);
    Test.assertEqual(0,data["slot_5_background_mode"]);store.failAt=-1;
    data=SettingsMigration.read(store,false);Test.assertEqual(1,store.values["settings_schema_version"]);
    var versions=[2,-1,true,"1",1.0];
    for(var i=0;i<versions.size();i+=1) {
        store=new MigrationStore();store.values["settings_schema_version"]=versions[i];
        store.values["slot_1_background_mode"]=2;data=SettingsMigration.read(store,false);
        Test.assertEqual(0,store.writes);var settings=new DisplaySettings();settings.apply(data);
        Test.assertEqual(2,settings.modes[0]);Test.assertEqual(0,settings.modes[1]);
    }
    var invalid=[true,false,1.0,"1",3,-2,[],{}];
    for(var j=0;j<invalid.size();j+=1) {
        var props={"settings_schema_version"=>1,"second_slot_1_background_mode"=>invalid[j],"second_slot_2_background_mode"=>0};
        var secondary=new DisplaySettings();secondary.applyBank(props,"second_");
        Test.assertEqual(1,secondary.modes[0]);Test.assertEqual(0,secondary.modes[1]);
        Test.assertEqual(invalid[j],props["second_slot_1_background_mode"]);
    }
}

(:testSupport)
function verifyColoringZones() {
    var bounds=CadenceZones.configured({});var cases=[[0,1],[60.49,1],[60.5,2],[80,2],[81,3],[100,3],[101,4],[120,4],[121,5]];
    for(var i=0;i<cases.size();i+=1) { Test.assertEqual(cases[i][1],CadenceZones.classify(cases[i][0],bounds)); }
    Test.assert(CadenceZones.classify(-1,bounds)==null);Test.assert(CadenceZones.classify(null,bounds)==null);
    Test.assert(CadenceZones.classify(Math.acos(2.0),bounds)==null);
    var invalid=[-1,301,80,true,"60",60.0,null];
    for(var j=0;j<invalid.size();j+=1) { Test.assert(CadenceZones.configured({"cadence_zone_1_max_rpm"=>invalid[j]})==null); }
    var colors=["blue","green","yellow","orange","red","magenta"];
    var rgb=[0x00AAFF,0x00FF00,0xFFAA00,0xFF5500,0xFF0000,0xFF00FF];var renderer=new FieldRenderer();
    for(var z=1;z<=6;z+=1) { Test.assertEqual(colors[z-1],Effects.zoneColor(z));Test.assertEqual(rgb[z-1],renderer.color(colors[z-1])); }
    Test.assertEqual("magenta",Effects.zoneColor(10));Test.assert(Effects.zoneColor(1.0)==null);
    new ZoneFamilyScenario().run();
}
(:testSupport)
class ZoneFamilyScenario {
    var engine;var settings;var props={};var raw;var snapshot;var old;var builds;
    function initialize() {
        engine=new SnapshotEngine();engine._hrZones=ZoneMetadata.heart([0,100,120,140,160,200]);
        engine._powerZones=ZoneMetadata.power([0,100,200,300,400,500,600,700,800,900,1000],true);
        settings=new DisplaySettings();
    }
    function sample() { settings.apply(props);snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,false),null); }
    function run() {
        var ids=["current_heart_rate","heart_rate_3s","average_heart_rate","lap_heart_rate","current_power","power_3s","average_power","lap_power","current_cadence","average_cadence","lap_cadence","heart_rate_zone","power_zone"];
        var readings=[90,110,130,150,50,150,250,650,60,81,121,2,7];
        var colors=["blue","green","yellow","orange","blue","green","yellow","magenta","blue","yellow","red","green","magenta"];
        for(var i=0;i<ids.size();i+=1) {
            props={"slot_1_value"=>ids[i],"slot_2_value"=>ids[i],"slot_1_background_mode"=>1,"slot_2_background_mode"=>2};raw={};raw[ids[i]]=readings[i];sample();
            Test.assertEqual(colors[i],snapshot[:values][0][:band]);Test.assertEqual(colors[i],snapshot[:values][1][:band]);
            old=snapshot;builds=engine.zoneBuilds;sample();Test.assertEqual(builds,engine.zoneBuilds);
            Test.assert(old[:values][0]==snapshot[:values][0]);
        }
        engine._powerZones=null;sample();Test.assertEqual("light_gray",snapshot[:values][0][:band]);Test.assertEqual("7",snapshot[:values][0][:text]);
        props={"slot_1_value"=>"current_cadence","slot_1_background_mode"=>1,"cadence_zone_1_max_rpm"=>200};raw={"current_cadence"=>70};sample();
        Test.assertEqual("light_gray",snapshot[:values][0][:band]);Test.assertEqual("70",snapshot[:values][0][:text]);
        props["cadence_zone_1_max_rpm"]=60;sample();Test.assertEqual("green",snapshot[:values][0][:band]);
        props={"slot_1_value"=>"heart_rate_zone","slot_2_value"=>"power_zone","slot_1_background_mode"=>1,"slot_2_background_mode"=>2};
        raw={"current_heart_rate"=>130,"heart_rate_zone"=>5,"current_power"=>650,"power_zone"=>10};
        engine._powerZones=ZoneMetadata.power([0,100,200,300,400,500,600,700,800,900,1000],true);sample();
        Test.assertEqual("3",snapshot[:values][0][:text]);Test.assertEqual("yellow",snapshot[:values][0][:band]);
        Test.assertEqual("7",snapshot[:values][1][:text]);Test.assertEqual("magenta",snapshot[:values][1][:band]);old=snapshot;
        engine._hrZones=ZoneMetadata.heart([0,140,150,160,180,200]);sample();
        Test.assertEqual("1",snapshot[:values][0][:text]);Test.assertEqual("blue",snapshot[:values][0][:band]);Test.assertEqual("3",old[:values][0][:text]);
        var banks=new FieldSetsSettings();banks.apply({});Test.assert(banks.primary.cadenceBounds==banks.secondary.cadenceBounds);
    }
}

(:testSupport)
function verifyTeamOptions() {
    Test.assertEqual("team",SettingsCatalogue.decode("slot_1_value",32));Test.assertEqual("team",Catalog.LABELS[32]);
    var invalid=[null,42,true,"abcdefghijklmnopqrstuvwxyzABCDEFG","line\nline","café"];
    for(var i=0;i<invalid.size();i+=1) { Test.assertEqual("TEAM",TeamOptions.text(invalid[i])); }
    Test.assertEqual("",TeamOptions.text(""));Test.assertEqual("  Aa!  ",TeamOptions.text("  Aa!  "));
    Test.assertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef",TeamOptions.text("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef"));
    for(var start=0;start<TeamOptions.REPERTOIRE.length();start+=1) { Test.assertEqual(TeamOptions.REPERTOIRE.substring(start,start+1),TeamOptions.text(TeamOptions.REPERTOIRE.substring(start,start+1))); }
    var props={"slot_1_team_text"=>"ONE","slot_1_team_font"=>9,"slot_1_team_color_source"=>2,
        "slot_2_team_text"=>"IGNORED","second_slot_1_team_text"=>"TWO","second_slot_10_team_text"=>" HIDDEN ",
        "second_slot_1_team_font"=>7,"second_slot_1_team_color_source"=>1};
    var banks=new FieldSetsSettings();banks.apply(props);
    Test.assertEqual("ONE",banks.primary.teamText);Test.assertEqual("ONE",banks.secondary.teamText);
    Test.assertEqual(9,banks.primary.teamFonts[0]);Test.assertEqual(7,banks.secondary.teamFonts[0]);
    Test.assertEqual(2,banks.primary.teamSources[0]);Test.assertEqual(1,banks.secondary.teamSources[0]);
    props["slot_1_value"]="team";props["slot_2_value"]="team";props["second_slot_10_value"]="team";
    props["slot_1_team_text"]=" SAME TEAM ";banks.apply(props);
    Test.assertEqual(" SAME TEAM ",banks.primary.teamText);Test.assertEqual(" SAME TEAM ",banks.secondary.teamText);
    props["slot_1_value"]="elevation";props["second_set_trigger"]=0;banks.apply(props);
    Test.assertEqual(" SAME TEAM ",banks.primary.teamText);Test.assertEqual(" SAME TEAM ",banks.secondary.teamText);
    Test.assertEqual("TWO",props["second_slot_1_team_text"]);Test.assertEqual(" HIDDEN ",props["second_slot_10_team_text"]);
    props["slot_1_team_text"]="";banks.apply(props);
    Test.assertEqual("",banks.primary.teamText);Test.assertEqual("",banks.secondary.teamText);
    props["slot_1_team_text"]=42;banks.apply(props);
    Test.assertEqual("TEAM",banks.primary.teamText);Test.assertEqual("TEAM",banks.secondary.teamText);
    Test.assertEqual(42,props["slot_1_team_text"]);
    banks.apply({"second_slot_1_team_text"=>"IGNORED"});
    Test.assertEqual("TEAM",banks.primary.teamText);Test.assertEqual("TEAM",banks.secondary.teamText);
    var store=new MigrationStore();store.values["slot_1_team_text"]="SAVED TEAM";store.values["second_slot_1_team_text"]="OLD";
    banks.apply(SettingsMigration.read(store,false));
    Test.assertEqual("SAVED TEAM",banks.primary.teamText);Test.assertEqual("SAVED TEAM",banks.secondary.teamText);
    Test.assertEqual("OLD",store.values["second_slot_1_team_text"]);Test.assertEqual("SAVED TEAM",store.values["slot_1_team_text"]);
    var saved=[true,1.0,-1,10,"1",null];
    for(var j=0;j<saved.size();j+=1) { Test.assertEqual(0,TeamOptions.code(saved[j],9)); }
}
