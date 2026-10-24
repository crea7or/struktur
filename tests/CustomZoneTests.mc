using Toybox.Test;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Graphics;

(:testSupport)
function customZoneProperties() {
    return {"cpz"=>true,"chz"=>true,"pw1"=>100,"pw2"=>150,"pw3"=>200,"pw4"=>250,"pw5"=>300,"pw6"=>350,
        "hr1"=>100,"hr2"=>120,"hr3"=>140,"hr4"=>160};
}
(:testSupport)
function customBoundaryCases(power) {
    var p=customZoneProperties();var profile=TrainingZones.configured(p,power,null);
    var limits=profile.bounds;
    for(var i=0;i<limits.size();i+=1) {
        Test.assertEqual(i+1,TrainingZones.classify(limits[i]-0.51,profile,!power));
        Test.assertEqual(i+1,TrainingZones.classify(limits[i],profile,!power));
        Test.assertEqual(i+2,TrainingZones.classify(limits[i]+0.5,profile,!power));
    }
    Test.assertEqual(power?7:5,TrainingZones.classify(power?3001:251,profile,!power));
    Test.assert(TrainingZones.classify(-0.1,profile,!power)==null);
    Test.assert(TrainingZones.classify(null,profile,!power)==null);
    Test.assert(TrainingZones.classify(Math.acos(2.0),profile,!power)==null);
    if(power) { Test.assertEqual(1,TrainingZones.classify(0,profile,false)); } else { Test.assert(TrainingZones.classify(0,profile,true)==null); }
    if(!power) { Test.assertEqual(1,TrainingZones.classify(0.1,profile,true)); }
    var key=power?"pw1":"hr1";var bad=[null,0,-1,true,"100",100.0,Math.acos(2.0),power?3001:251];
    if(!power) { bad.add(29); }
    for(var n=0;n<bad.size();n+=1) { p[key]=bad[n];var rejected=TrainingZones.configured(p,power,null);Test.assert(rejected!=null && rejected.bounds==null);Test.assert(TrainingZones.classify(100,rejected,!power)==null); }
    p=customZoneProperties();p[power?"pw2":"hr2"]=100;Test.assert(TrainingZones.configured(p,power,null).bounds==null);
    p[power?"pw2":"hr2"]=99;Test.assert(TrainingZones.configured(p,power,null).bounds==null);
    p=customZoneProperties();p.remove(key);Test.assert(TrainingZones.configured(p,power,null).bounds==null);
    p=customZoneProperties();p[key]=power?1:30;p[power?"pw6":"hr4"]=power?3000:250;
    Test.assert(TrainingZones.configured(p,power,null).bounds!=null);
}
(:test)
function customHeartZoneBoundaries(logger) { customBoundaryCases(false);return true; }
(:test)
function customPowerZoneBoundaries(logger) { customBoundaryCases(true);return true; }

(:testSupport)
class CustomZoneEngine extends SnapshotEngine {
    var heartReads=0;var powerReads=0;
    function initialize() { SnapshotEngine.initialize(); }
    function readHeartZones() { heartReads+=1;return [0,200,210,220,230,240]; }
    function readPowerZones() { powerReads+=1;return [0,500,600,700,800,900,1000,1100,1200,1300,1400]; }
}
(:test)
function customZoneSourceSelection(logger) {
    for(var mode=0;mode<4;mode+=1) {
        var props=customZoneProperties();props["cpz"]=(mode&1)!=0;props["chz"]=(mode&2)!=0;
        var banks=new FieldSetsSettings();banks.apply(props);var engine=new CustomZoneEngine();engine.selectProfiles(banks.primary);engine.metadata();
        Test.assertEqual((mode&1)!=0?0:1,engine.powerReads);Test.assertEqual((mode&2)!=0?0:1,engine.heartReads);
        Test.assertEqual((mode&1)!=0?7:1,engine.zone(3,351));Test.assertEqual((mode&2)!=0?5:1,engine.zone(0,170));
        Test.assert(banks.primary.powerProfile==banks.secondary.powerProfile);Test.assert(banks.primary.heartProfile==banks.secondary.heartProfile);
        props["pw1"]=0;banks.apply(props);engine.selectProfiles(banks.primary);engine.metadata();
        if((mode&1)!=0) { Test.assert(engine.zone(3,351)==null); } else { Test.assertEqual(1,engine.zone(3,351)); }
        props["pw1"]=100;banks.apply(props);engine.selectProfiles(banks.primary);engine.metadata();Test.assertEqual((mode&1)!=0?7:1,engine.zone(3,351));
    }
    var invalid=[null,1,"true",0,true,false];
    for(var i=0;i<invalid.size();i+=1) { var props=customZoneProperties();props["cpz"]=invalid[i];Test.assertEqual(invalid[i] instanceof Lang.Boolean && invalid[i]==true,TrainingZones.configured(props,true,null)!=null);props["chz"]=invalid[i];Test.assertEqual(invalid[i] instanceof Lang.Boolean && invalid[i]==true,TrainingZones.configured(props,false,null)!=null); }
    var props=customZoneProperties();var banks=new FieldSetsSettings();banks.apply(props);var retained=banks.primary.powerProfile;
    props["pw1"]=100.0;banks.apply(props);Test.assert(banks.primary.powerProfile.bounds==null);Test.assertEqual(100,retained.bounds[0]);
    var invalidProfile=banks.primary.powerProfile;banks.apply(props);Test.assert(invalidProfile==banks.primary.powerProfile);
    props["pw1"]=100;banks.apply(props);Test.assert(banks.primary.powerProfile.bounds!=null);
    Test.assert(TrainingZones.configured({},true,null)==null);
    return true;
}

(:testSupport)
class CustomConsumerScenario {
    var props;var settings;var engine;var raw;var dc;var renderer;
    function initialize() {
        props=customZoneProperties();props["a_theme"]=1;props["team"]="RIDE";
        settings=new DisplaySettings();engine=new SnapshotEngine();renderer=new FieldRenderer();
        dc=new TeamDrawDc(profileDrawWidth(),profileDrawHeight());
        raw={"current_heart_rate"=>170,"heart_rate_3s"=>110,"average_heart_rate"=>130,"lap_heart_rate"=>150,
            "current_power"=>351,"power_3s"=>325,"average_power"=>225,"lap_power"=>175};
    }
    function run() {
        var ids=["current_heart_rate","heart_rate_3s","average_heart_rate","lap_heart_rate","current_power","power_3s","average_power","lap_power","heart_rate_zone","power_zone","team","team"];
        var colors=["red","green","yellow","orange","dark_magenta","magenta","orange","yellow","red","dark_magenta","dark_magenta","red"];
        for(var i=0;i<ids.size();i+=1) {
            props["a1"]=ids[i];props["a2"]=ids[i];props["tsrc"]=i==11?2:1;
            for(var mode=0;mode<=2;mode+=1) {
                props["a1_bg"]=mode;props["a2_bg"]=mode;settings.apply(props);engine.selectProfiles(settings);
                var snapshot=engine.prepareWithPreferences(raw,settings,true,8,null);
                if(mode==0) { Test.assert(snapshot[:values][0][ValueRecord.BAND]==null); } else { Test.assertEqual(colors[i],snapshot[:values][0][ValueRecord.BAND]); }
                if(mode==0) { Test.assert(snapshot[:values][1][ValueRecord.BAND]==null); } else { Test.assertEqual(colors[i],snapshot[:values][1][ValueRecord.BAND]); }
            }
        }
        props["a1"]="current_power";props["a2"]="power_zone";props["a3"]="team";props["tsrc"]=1;
        props["a1_bg"]=1;props["a2_bg"]=2;props["a3_bg"]=1;props["pw1"]=0;
        settings.apply(props);engine.selectProfiles(settings);var invalid=engine.prepareWithPreferences(raw,settings,true,8,null);
        Test.assertEqual("351",invalid[:values][0][ValueRecord.TEXT]);Test.assert(invalid[:values][1][ValueRecord.TEXT]==null);
        Test.assertEqual("RIDE",invalid[:values][2][ValueRecord.TEXT]);Test.assertEqual("light_gray",invalid[:values][0][ValueRecord.BAND]);Test.assertEqual("light_gray",invalid[:values][2][ValueRecord.BAND]);
        props["pw1"]=100;settings.apply(props);engine.selectProfiles(settings);var recovered=engine.prepareWithPreferences(raw,settings,true,8,null);
        Test.assertEqual("7",recovered[:values][1][ValueRecord.TEXT]);Test.assertEqual("dark_magenta",recovered[:values][2][ValueRecord.BAND]);Test.assertEqual("light_gray",invalid[:values][0][ValueRecord.BAND]);
        // Actual prepared rendering: dark-magenta contrast for regular/enlarged cells and both banks.
        for(var bank=0;bank<2;bank+=1) {
            var prefix=bank==0?"a":"b";
            for(var big=0;big<3;big+=1) {
                var night=bank;var mode=big==1?2:1;
                props[prefix+"1"]="team";props[prefix+"2"]="current_power";props[prefix+"_big"]=big;
                props[prefix+"_theme"]=night+1;props[prefix+"_inv"]=big!=1;props["tsrc"]=1;
                props[prefix+"1_bg"]=mode;props[prefix+"2_bg"]=mode;
                settings.applyBank(props,prefix);engine.selectProfiles(settings);
                var snapshot=engine.prepareWithPreferences(raw,settings,true,8,null);
                dc=new TeamDrawDc(profileDrawWidth(),profileDrawHeight());
                renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.draw(dc,snapshot,settings);
                Test.assertEqual(0xAA00AA,renderer.color(snapshot[:values][0][ValueRecord.BAND]));
                Test.assertEqual(Graphics.COLOR_WHITE,renderer._packets[0].label[5]);
                Test.assertEqual(mode==2?Graphics.COLOR_WHITE:(renderer._packets[0].night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK),renderer._packets[0].primary[5]);
            }
        }
    }
}
(:test)
function selectedZoneConsumers(logger) { new CustomConsumerScenario().run();return true; }

(:test)
function customZoneSettingsPersistence(logger) {
    var app=Application.getApp();var previous=app._view;var saved={};var props=customZoneProperties();var keys=props.keys();
    for(var i=0;i<keys.size();i+=1) { saved[keys[i]]=Application.Properties.getValue(keys[i]); }
    try {
        var field=new SecondSetField();app._view=field;
        for(var i=0;i<keys.size();i+=1) { Application.Properties.setValue(keys[i],props[keys[i]]); }
        app.onSettingsChanged();Test.assert(field._settings.powerProfile!=null);Test.assertEqual(350,field._settings.powerProfile.bounds[5]);
        var reloaded=new FieldSetsSettings();reloaded.load();Test.assertEqual(160,reloaded.secondary.heartProfile.bounds[3]);
        // A reconstructed Data Field reads the same persistent app dictionary.
        var restarted=new SecondSetField();Test.assertEqual(100,restarted._settings.powerProfile.bounds[0]);
        Application.Properties.setValue("cpz",false);app.onSettingsChanged();Test.assert(field._settings.powerProfile==null);
        Test.assertEqual(350,Application.Properties.getValue("pw6"));Application.Properties.setValue("cpz",true);app.onSettingsChanged();Test.assertEqual(350,field._settings.powerProfile.bounds[5]);
        Application.Properties.setValue("pw1",0);app.onSettingsChanged();Test.assert(field._settings.powerProfile.bounds==null);Test.assertEqual(0,Application.Properties.getValue("pw1"));
    } finally {
        app._view=previous;for(var i=0;i<keys.size();i+=1) { Application.Properties.setValue(keys[i],saved[keys[i]]); }
    }
    return true;
}
(:test)
function customZoneLifecycle(logger) {
    var props=customZoneProperties();var banks=new FieldSetsSettings();banks.apply(props);var heart=banks.primary.heartProfile;var power=banks.primary.powerProfile;
    var validations=TrainingZones.validations;banks.apply(props);Test.assertEqual(validations,TrainingZones.validations);Test.assert(heart==banks.primary.heartProfile && power==banks.secondary.powerProfile);
    var engine=new CustomZoneEngine();engine.selectProfiles(banks.primary);engine.metadata();Test.assertEqual(0,engine.powerReads);Test.assertEqual(0,engine.heartReads);
    engine.zone(0,170);engine.zone(3,351);var builds=engine.zoneBuilds;props["pw6"]=400;banks.apply(props);engine.selectProfiles(banks.primary);
    Test.assertEqual(5,engine.zone(0,170));Test.assertEqual(6,engine.zone(3,351));Test.assertEqual(builds+1,engine.zoneBuilds);Test.assert(heart==banks.primary.heartProfile);
    var field=new SecondSetField();field.applyFieldSets(banks);field.onTimerStart();field._fieldSets.lap(true);Test.assert(field._fieldSets.second);
    var acquisition=field._acquisition;var rolling=field._engine._power;var laps=acquisition.currentLap;
    rolling.push(200,1);rolling.push(400,2);laps._power.push(100,1000,1000,true);laps._power.push(300,2000,2000,true);
    props["pw6"]=450;var next=new FieldSetsSettings();next.apply(props);field.applyFieldSets(next);
    Test.assert(field._fieldSets.second);Test.assert(field._acquisition==acquisition);Test.assert(field._engine._power==rolling);Test.assert(acquisition.currentLap==laps);
    Test.assertEqual(300.0,rolling.average());Test.assertEqual(200.0d,laps._power.value());
    Test.assertEqual(250,next.powerActivate);Test.assertEqual(220,next.powerReturn);
    Test.assertEqual(validations+3,TrainingZones.validations);
    return true;
}
