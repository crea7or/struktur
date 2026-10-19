using Toybox.Test;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.WatchUi;

(:testSupport)
function verifyEffectDefaultContract() {
    var settings=new DisplaySettings();
    for(var initial=0;initial<10;initial+=1) { Test.assertEqual(false,settings.effects[initial]); }
    Test.assertEqual(true,settings.hideValueUnits);Test.assertEqual(true,settings.inverseEnlargedTheme);
    var invalid=[null,true,false,-1,3,"true","false",1.0];
    var properties={"a_big"=>2};
    for(var candidate=0;candidate<invalid.size();candidate+=1) {
        for(var slot=1;slot<=10;slot+=1) { properties["a"+slot.toString()+"_bg"]=invalid[candidate]; }
        settings.apply(properties);
        for(var index=0;index<10;index+=1) { Test.assertEqual(false,settings.effects[index]); }
    }
    for(var saved=1;saved<=10;saved+=1) {
        properties["a"+saved.toString()+""]="power_3s";
        properties["a"+saved.toString()+"_bg"]=saved%2==0?1:0;
    }
    settings.apply(properties);
    var restarted=new DisplaySettings();restarted.apply(properties);
    for(var retained=0;retained<10;retained+=1) {
        Test.assertEqual(retained%2==1,settings.effects[retained]);
        Test.assertEqual(settings.effects[retained],restarted.effects[retained]);
    }
    properties["a_big"]=0;properties["a10"]="grade";
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
    function setClip(x,y,w,h) { _clip={Cell.X=>x,Cell.Y=>y,Cell.W=>w,Cell.H=>h}; }
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
            Test.assert(x>=_clip[Cell.X]+4 && x+width<=_clip[Cell.X]+_clip[Cell.W]-4);
            return;
        }
        if(_mainText.equals(text)) {
            _mainX=x; _mainY=y; _mainWidth=getTextWidthInPixels(text,font); _mainHeight=Graphics.getFontHeight(font);
            var ink=FontMetrics.bounds(text,FontMetrics.numeric(_mainHeight));
            _mainVisibleTop=y+ink[0];
            var inset=DeviceProfile.LABEL_SIZE==21?30:46;
            var center=_clip[Cell.Y]+inset+(_clip[Cell.H]-inset)/2.0;
            Test.assert((_mainVisibleTop+(ink[1]-ink[0])/2.0-center).abs()<=1);
            Test.assert(x>=_clip[Cell.X]+4 && x+_mainWidth<=_clip[Cell.X]+_clip[Cell.W]-4);
            Test.assert(_mainVisibleTop>=_clip[Cell.Y]+inset && y+ink[1]<=_clip[Cell.Y]+_clip[Cell.H]);
            mainCount+=1;
        } else if(_secondaryText.equals(text)) {
            var secondaryWidth=getTextWidthInPixels(text,font);
            Test.assert(Graphics.getFontHeight(font)<_mainHeight);
            Test.assertEqual(_mainX+_mainWidth+2,x);
            Test.assertEqual(_mainVisibleTop,y+FontMetrics.bounds(text,FontMetrics.label(Graphics.getFontHeight(font)))[0]);
            Test.assert(x+secondaryWidth<=_clip[Cell.X]+_clip[Cell.W]-4);
            var total=_mainWidth+secondaryWidth+2;
            Test.assertEqual(_right?_clip[Cell.X]+_clip[Cell.W]-4-total:_clip[Cell.X]+(_clip[Cell.W]-total)/2,_mainX);
            secondaryCount+=1;
        } else {
            _labelHeight=Graphics.getFontHeight(font);
        }
    }
}



(:testSupport)
class PropertyReadStore {
    var values={};var reads=0;
    function get(key) { reads+=1;return values.hasKey(key)?values[key]:null; }
}
(:testSupport)
function verifyCompactProperties() {
    var store=new PropertyReadStore();store.values={"a1"=>32,"team"=>"SAVED TEAM","b1_bg"=>0,"unrelated"=>42};
    var data=SettingsStore.read(store);Test.assertEqual(63,store.reads);Test.assertEqual(63,data.size());
    Test.assertEqual(32,data["a1"]);Test.assertEqual("SAVED TEAM",data["team"]);Test.assertEqual(0,data["b1_bg"]);
    Test.assert(!data.hasKey("unrelated"));Test.assertEqual(4,store.values.size());
    var keys=SettingsCatalogue.keys();var seen={};
    for(var i=0;i<keys.size();i+=1) { Test.assert(keys[i].length()<=8);Test.assert(!seen.hasKey(keys[i]));seen[keys[i]]=true; }
    var banks=new FieldSetsSettings();banks.apply(data);Test.assertEqual("team",banks.primary.slots[0]);Test.assertEqual(0,banks.secondary.modes[0]);
    var invalid=[null,true,"1",1.0,-1,3];
    for(var j=0;j<invalid.size();j+=1) {
        banks.apply({"a1_bg"=>invalid[j],"b1_bg"=>invalid[j],"b2_bg"=>0});
        Test.assertEqual(0,banks.primary.modes[0]);Test.assertEqual(1,banks.secondary.modes[0]);Test.assertEqual(0,banks.secondary.modes[1]);
    }
    banks.apply({"a1_bg"=>2,"b1_bg"=>0});Test.assertEqual(2,banks.primary.modes[0]);Test.assertEqual(0,banks.secondary.modes[0]);
}


(:testSupport)
function verifyColoringZones() {
    var bounds=CadenceZones.configured({});var cases=[[0,1],[60.49,1],[60.5,2],[80,2],[81,3],[100,3],[101,4],[120,4],[121,5]];
    for(var i=0;i<cases.size();i+=1) { Test.assertEqual(cases[i][1],CadenceZones.classify(cases[i][0],bounds)); }
    Test.assert(CadenceZones.classify(-1,bounds)==null);Test.assert(CadenceZones.classify(null,bounds)==null);
    Test.assert(CadenceZones.classify(Math.acos(2.0),bounds)==null);
    var invalid=[-1,301,80,true,"60",60.0,null];
    for(var j=0;j<invalid.size();j+=1) { Test.assert(CadenceZones.configured({"cad1"=>invalid[j]})==null); }
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
            props={"a1"=>ids[i],"a2"=>ids[i],"a1_bg"=>1,"a2_bg"=>2};raw={};raw[ids[i]]=readings[i];sample();
            Test.assertEqual(colors[i],snapshot[:values][0][ValueRecord.BAND]);Test.assertEqual(colors[i],snapshot[:values][1][ValueRecord.BAND]);
            old=snapshot;builds=engine.zoneBuilds;sample();Test.assertEqual(builds,engine.zoneBuilds);
            Test.assert(old[:values][0]==snapshot[:values][0]);
        }
        engine._powerZones=null;sample();Test.assertEqual("light_gray",snapshot[:values][0][ValueRecord.BAND]);Test.assertEqual("7",snapshot[:values][0][ValueRecord.TEXT]);
        props={"a1"=>"current_cadence","a1_bg"=>1,"cad1"=>200};raw={"current_cadence"=>70};sample();
        Test.assertEqual("light_gray",snapshot[:values][0][ValueRecord.BAND]);Test.assertEqual("70",snapshot[:values][0][ValueRecord.TEXT]);
        props["cad1"]=60;sample();Test.assertEqual("green",snapshot[:values][0][ValueRecord.BAND]);
        props={"a1"=>"heart_rate_zone","a2"=>"power_zone","a1_bg"=>1,"a2_bg"=>2};
        raw={"current_heart_rate"=>130,"heart_rate_zone"=>5,"current_power"=>650,"power_zone"=>10};
        engine._powerZones=ZoneMetadata.power([0,100,200,300,400,500,600,700,800,900,1000],true);sample();
        Test.assertEqual("3",snapshot[:values][0][ValueRecord.TEXT]);Test.assertEqual("yellow",snapshot[:values][0][ValueRecord.BAND]);
        Test.assertEqual("7",snapshot[:values][1][ValueRecord.TEXT]);Test.assertEqual("magenta",snapshot[:values][1][ValueRecord.BAND]);old=snapshot;
        engine._hrZones=ZoneMetadata.heart([0,140,150,160,180,200]);sample();
        Test.assertEqual("1",snapshot[:values][0][ValueRecord.TEXT]);Test.assertEqual("blue",snapshot[:values][0][ValueRecord.BAND]);Test.assertEqual("3",old[:values][0][ValueRecord.TEXT]);
        var banks=new FieldSetsSettings();banks.apply({});Test.assert(banks.primary.cadenceBounds==banks.secondary.cadenceBounds);
    }
}

(:testSupport)
function verifyTeamOptions() {
    Test.assertEqual("team",SettingsCatalogue.decode("a1",32));Test.assertEqual("team",Catalog.LABELS[32]);
    var invalid=[null,42,true,"abcdefghijklmnopqrstuvwxyzABCDEFG","line\nline","café"];
    for(var i=0;i<invalid.size();i+=1) { Test.assertEqual("TEAM",TeamOptions.text(invalid[i])); }
    Test.assertEqual("",TeamOptions.text(""));Test.assertEqual("  Aa!  ",TeamOptions.text("  Aa!  "));
    Test.assertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef",TeamOptions.text("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef"));
    for(var start=0;start<TeamOptions.REPERTOIRE.length();start+=1) { Test.assertEqual(TeamOptions.REPERTOIRE.substring(start,start+1),TeamOptions.text(TeamOptions.REPERTOIRE.substring(start,start+1))); }
    var props={"team"=>"ONE","tsrc"=>2};
    var banks=new FieldSetsSettings();banks.apply(props);
    Test.assertEqual("ONE",banks.primary.teamText);Test.assertEqual("ONE",banks.secondary.teamText);

    Test.assertEqual(2,banks.primary.teamSource);Test.assertEqual(2,banks.secondary.teamSource);
    props["a1"]="team";props["a2"]="team";props["b10"]="team";
    props["team"]=" SAME TEAM ";banks.apply(props);
    Test.assertEqual(" SAME TEAM ",banks.primary.teamText);Test.assertEqual(" SAME TEAM ",banks.secondary.teamText);
    props["a1"]="elevation";props["trig"]=0;banks.apply(props);
    Test.assertEqual(" SAME TEAM ",banks.primary.teamText);Test.assertEqual(" SAME TEAM ",banks.secondary.teamText);
    props["team"]="";banks.apply(props);
    Test.assertEqual("",banks.primary.teamText);Test.assertEqual("",banks.secondary.teamText);
    props["team"]=42;banks.apply(props);
    Test.assertEqual("TEAM",banks.primary.teamText);Test.assertEqual("TEAM",banks.secondary.teamText);
    Test.assertEqual(42,props["team"]);
    banks.apply({});
    Test.assertEqual("TEAM",banks.primary.teamText);Test.assertEqual("TEAM",banks.secondary.teamText);
    var store=new PropertyReadStore();store.values["team"]="SAVED TEAM";
    banks.apply(SettingsStore.read(store));
    Test.assertEqual("SAVED TEAM",banks.primary.teamText);Test.assertEqual("SAVED TEAM",banks.secondary.teamText);
    Test.assertEqual("SAVED TEAM",store.values["team"]);
    var saved=[true,1.0,-1,10,"1",null];
    for(var j=0;j<saved.size();j+=1) { Test.assertEqual(0,TeamOptions.code(saved[j],2)); }
}
