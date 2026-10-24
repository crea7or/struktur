using Toybox.Test;
using Toybox.Activity;
using Toybox.Time;
using Toybox.Math;
using Toybox.Lang;

(:testSupport)
function secondSetConfiguration(values) { var s=new FieldSetsSettings();s.apply(values);return s; }

(:testSupport)
class SecondSetAcquisition extends ActivityAcquisition {
    var boundaries=0;var samples=0;
    function initialize() { ActivityAcquisition.initialize(); }
    function boundary(info) { boundaries+=1;ActivityAcquisition.boundary(info); }
    function read(info,raw) { samples+=1;return ActivityAcquisition.read(info,raw); }
}

(:testSupport)
class SecondSetField extends StrukturField {
    var batteryReads=0;var releasedPresentations=0;
    function initialize() { StrukturField.initialize();_acquisition=new SecondSetAcquisition(); }
    function selectSettings() {
        var changed=StrukturField.selectSettings();
        if(changed) {
            Test.assertEqual(0,_renderer._runs.size());Test.assertEqual(0,_renderer._packets.size());
            Test.assertEqual(0,_renderer._preparedValues.size());Test.assertEqual(0,_renderer._headerFits.size());releasedPresentations+=1;
        }
        return changed;
    }
    function batteryReading() { batteryReads+=1;return 64; }
    function temperatureReading() { return null; }
    function onLapNotification(manual) { handleLap(null,manual); }
}

(:test)
function secondarySettingsAndDefaults(logger) {
    var saved={"a_align"=>0,"a10"=>"battery","a10_bg"=>1,
        "b_align"=>1,"b1"=>"lap_power","b10"=>"future-field",
        "b1_bg"=>1,"b_big"=>2,"b_hideu"=>false};
    var s=secondSetConfiguration(saved);
    Test.assertEqual(75,SettingsCatalogue.keys().size());
    Test.assertEqual("center",s.primary.alignment);Test.assertEqual("right",s.secondary.alignment);
    Test.assertEqual("battery",s.primary.slots[9]);Test.assert(s.primary.effects[9]);
    Test.assertEqual("lap_power",s.secondary.slots[0]);Test.assertEqual("future-field",s.secondary.slots[9]);
    Test.assertEqual(2,s.secondary.enlarged);Test.assert(!s.secondary.hideValueUnits && s.secondary.effects[0]);
    Test.assertEqual(3,s.trigger);Test.assertEqual(250,s.powerActivate);Test.assertEqual(220,s.powerReturn);
    Test.assertEqual(160,s.heartActivate);Test.assertEqual(150,s.heartReturn);
    var defaults=secondSetConfiguration({"a_align"=>0,"a1"=>"battery"});
    Test.assertEqual("right",defaults.secondary.alignment);verifySecondFactoryPreset(defaults);
    verifySecondFactoryPreset(new FieldSetsSettings());
    verifySecondPresetFallbacks();
    var factoryController=new FieldSetController(new FieldSetsSettings());
    Test.assert(!factoryController.second);factoryController.lap(true);Test.assert(factoryController.second);
    factoryController.lap(true);Test.assert(!factoryController.second);
    factoryController.configure(secondSetConfiguration({"trig"=>0}));
    factoryController.lap(true);Test.assert(!factoryController.second);Test.assertEqual(0,factoryController.configuration.trigger);
    for(var i=0;i<32;i+=1) { Test.assertEqual(Catalog.IDS[i],SettingsCatalogue.decode("b1",i)); }
    Test.assertEqual("night",SettingsCatalogue.decode("b_theme",2));
    for(var mode=0;mode<=4;mode+=1) { s=secondSetConfiguration({"trig"=>mode});Test.assertEqual(mode,s.trigger); }
    var invalid=[null,-1,5,2.0,"2",true];
    for(var j=0;j<invalid.size();j+=1) {
        s=secondSetConfiguration({"trig"=>invalid[j],"p_on"=>invalid[j],"hr_off"=>invalid[j]});
        Test.assertEqual(3,s.trigger);
        if(j!=2) { Test.assertEqual(250,s.powerActivate); }
        Test.assertEqual(150,s.heartReturn);
    }
    s=secondSetConfiguration({"trig"=>1,"p_on"=>200,"p_off"=>220});
    var c=new FieldSetController(s);c.evaluate({"power_3s"=>300},true);Test.assert(!c.second);
    s=secondSetConfiguration({"trig"=>2,"p_on"=>200,"p_off"=>220});
    c.configure(s);c.evaluate({"current_heart_rate"=>170},true);Test.assert(c.second);
    s=secondSetConfiguration({"p_on"=>3000,"p_off"=>1,
        "hr_on"=>250,"hr_off"=>30});
    Test.assertEqual(3000,s.powerActivate);Test.assertEqual(1,s.powerReturn);Test.assertEqual(250,s.heartActivate);Test.assertEqual(30,s.heartReturn);
    s=secondSetConfiguration({"p_on"=>3001,"p_off"=>0,
        "hr_on"=>251,"hr_off"=>29});
    Test.assertEqual(250,s.powerActivate);Test.assertEqual(220,s.powerReturn);Test.assertEqual(160,s.heartActivate);Test.assertEqual(150,s.heartReturn);
    var restarted=secondSetConfiguration(saved);Test.assertEqual("lap_power",restarted.secondary.slots[0]);
    Test.assertEqual("future-field",restarted.secondary.slots[9]);Test.assertEqual(0,saved["a_align"]);
    return true;
}

(:test)
function secondaryThresholdSources(logger) {
    var c=new FieldSetController(secondSetConfiguration({"trig"=>1}));
    var values=[249,250,235,220,219];var expected=[false,true,true,true,false];
    for(var i=0;i<values.size();i+=1) { c.evaluate({"power_3s"=>values[i]},true);Test.assertEqual(expected[i],c.second); }
    c.evaluate({"power_3s"=>249.6},true);Test.assert(!c.second);
    c.evaluate({"power_3s"=>250},true);c.evaluate({"power_3s"=>219.6},true);Test.assert(!c.second);
    var invalid=[null,-1,Math.acos(2.0),Math.pow(2.0,128),"300",true];
    for(var k=0;k<invalid.size();k+=1) {
        c.evaluate({"power_3s"=>300},true);Test.assert(c.second);
        c.evaluate({"power_3s"=>invalid[k]},true);Test.assert(!c.second);
        c.evaluate({"power_3s"=>235},true);Test.assert(!c.second);
    }
    c.evaluate({"power_3s"=>300},true);c.evaluate({},false);Test.assert(c.second);
    c.evaluate({},true);Test.assert(!c.second); // Missing producer input is unavailable.
    c.configure(secondSetConfiguration({"trig"=>1,"p_on"=>250,"p_off"=>250}));
    c.evaluate({"power_3s"=>250},true);Test.assert(c.second);c.evaluate({"power_3s"=>249.9},true);Test.assert(!c.second);
    c.configure(secondSetConfiguration({"trig"=>2}));
    values=[159,160,155,150,149];
    for(var h=0;h<values.size();h+=1) { c.evaluate({"current_heart_rate"=>values[h],"heart_rate_3s"=>200},true);Test.assertEqual(expected[h],c.second); }
    c.evaluate({"current_heart_rate"=>170,"power_3s"=>null},true);Test.assert(c.second);
    c.evaluate({"current_heart_rate"=>0},true);Test.assert(!c.second);
    // Real Data Field pipeline: power activates on its first valid sample, even without visible power fields.
    var field=new SecondSetField();var props={"trig"=>1};
    for(var slot=1;slot<=10;slot+=1) {props["a"+slot]="current_heart_rate";props["b"+slot]="current_heart_rate";}
    field.applyFieldSets(secondSetConfiguration(props));var info=new AcquisitionInfo();info.timerState=Activity.TIMER_STATE_ON;info.currentPower=300;
    for(var second=0;second<3;second+=1) { info.elapsedTime=second*1000;info.timerTime=second*1000;field.processActivity(info);Test.assert(field._fieldSets.second);Test.assertEqual(300.0,field._snapshot[:raw]["power_3s"]); }
    Test.assertEqual(3,field._engine._power._count);Test.assertEqual(3,field._acquisition.samples);
    info.currentPower=null;info.elapsedTime=3000;info.timerTime=3000;field.processActivity(info);Test.assert(!field._fieldSets.second);
    info.currentPower=0;
    for(var zero=4;zero<=6;zero+=1) {info.elapsedTime=zero*1000;info.timerTime=zero*1000;field.processActivity(info);}
    Test.assertEqual(0.0,field._snapshot[:raw]["power_3s"]);Test.assert(!field._fieldSets.second);
    field.onTimerResume();
    var startupPower=[300,0,600];var startupMean=[300.0,150.0,300.0];var startupSecond=[true,false,true];
    for(var sample=0;sample<3;sample+=1) {
        info.currentPower=startupPower[sample];info.elapsedTime=(sample+7)*1000;info.timerTime=(sample+7)*1000;
        field.processActivity(info);Test.assertEqual(startupMean[sample],field._snapshot[:raw]["power_3s"]);
        Test.assertEqual(startupSecond[sample],field._fieldSets.second);
    }
    return true;
}

(:test)
function secondaryManualLapCallbacks(logger) {
    new TeamLapCallbackScenario().run();
    var field=new SecondSetField();field.applyFieldSets(secondSetConfiguration({}));
    Test.assertEqual(3,field._fieldSets.configuration.trigger);Test.assert(!field._fieldSets.second);
    if(field.typedLapSupported()) {
        var typedCallback=field.method(:onTimerLap2) as Lang.Method;
        typedCallback.invoke({:lapTrigger=>0});Test.assert(field._fieldSets.second);
        for(var cause=1;cause<=24;cause+=1) { Test.assert(typedCallback.invoke({:lapTrigger=>cause}));Test.assert(field._fieldSets.second); }
        Test.assert(typedCallback.invoke({}));Test.assert(typedCallback.invoke(null));Test.assert(typedCallback.invoke({:lapTrigger=>999}));
        Test.assertEqual(28,field._acquisition.boundaries);
        typedCallback.invoke({:lapTrigger=>0});Test.assert(!field._fieldSets.second);Test.assertEqual(29,field._acquisition.boundaries);
        typedCallback.invoke({:lapTrigger=>0});Test.assert(field._fieldSets.second);Test.assertEqual(30,field._acquisition.boundaries);
    } else {
        field.onTimerLap();Test.assert(field._fieldSets.second);field.onTimerLap();Test.assert(!field._fieldSets.second);
        field.onTimerLap();Test.assert(field._fieldSets.second);Test.assertEqual(3,field._acquisition.boundaries);
    }
    field.onTimerReset();field.onLapNotification(true);Test.assert(!field._fieldSets.second);
    field.onTimerStart();field.onLapNotification(true);Test.assert(field._fieldSets.second);
    for(var mode=0;mode<=4;mode+=1) {
        if(mode==3) {continue;}
        field.applyFieldSets(secondSetConfiguration({"trig"=>mode}));field.onLapNotification(true);Test.assert(!field._fieldSets.second);
    }
    return true;
}

(:test)
function secondaryWorkoutCallbacks(logger) {
    var field=new SecondSetField();field.applyFieldSets(secondSetConfiguration({"trig"=>4}));
    Test.assert(!field._fieldSets.second);field.onWorkoutStarted();Test.assert(field._fieldSets.second);
    field.onWorkoutStarted();field.onTimerPause();field.onTimerStop();field.onTimerResume();field.onTimerStart();
    field.onLapNotification(true);field.onLapNotification(false);field.onWorkoutStepComplete();field.onHide();field.onShow();
    field.processActivity(new AcquisitionInfo());Test.assert(field._fieldSets.second);
    field.onTimerReset();Test.assert(!field._fieldSets.second);field.onLapNotification(true);Test.assert(!field._fieldSets.second);
    field.onWorkoutStarted();Test.assert(field._fieldSets.second);
    field.applyFieldSets(secondSetConfiguration({"trig"=>0}));field.onWorkoutStarted();Test.assert(!field._fieldSets.second);
    field.applyFieldSets(secondSetConfiguration({"trig"=>4}));Test.assert(!field._fieldSets.second);
    var late=new FieldSetController(secondSetConfiguration({"trig"=>4}));late.evaluate({},true);Test.assert(!late.second);
    late.workout();late.evaluate({"_activity_identity"=>100},true);Test.assert(late.second);
    late.evaluate({"_activity_identity"=>200},true);Test.assert(!late.second);
    return true;
}

(:test)
function secondaryAtomicAcquisition(logger) {
    var props={"trig"=>2,"b_align"=>0,"b_big"=>1,
        "b_theme"=>2,"b_hideu"=>false,"b_grid"=>0,"b10"=>"battery"};
    for(var slot=1;slot<=9;slot+=1) {props["a"+slot]="current_power";props["b"+slot]="current_heart_rate";}
    props["a10"]="current_power";
    var field=new SecondSetField();field.applyFieldSets(secondSetConfiguration(props));
    var info=new AcquisitionInfo();info.timerState=Activity.TIMER_STATE_ON;info.currentHeartRate=140;info.currentPower=200;info.startTime=new Time.Moment(100);
    field.processActivity(info);field._renderer.layout(new PresentationDrawDc(profileDrawWidth(),profileDrawHeight()),field._settings);var first=field._snapshot;Test.assertEqual(0,field.batteryReads);
    info.currentHeartRate=170;info.elapsedTime=1000;info.timerTime=1000;field.processActivity(info);
    Test.assert(field._fieldSets.second);Test.assert(field._settings==field._fieldSets.configuration.secondary);
    Test.assertEqual("center",field._settings.alignment);Test.assertEqual("none",field._settings.gridType);
    Test.assertEqual(1,field._settings.enlarged);Test.assert(field._snapshot[:night]);Test.assertEqual(1,field.batteryReads);
    Test.assert(field.releasedPresentations>0);Test.assertEqual("64",field._snapshot[:values][9][ValueRecord.TEXT]);Test.assertEqual("hr | bpm",field._snapshot[:values][0][ValueRecord.LABEL]);
    Test.assertEqual("watts",first[:values][0][ValueRecord.LABEL]);Test.assertEqual("200",first[:values][0][ValueRecord.TEXT]);
    Test.assertEqual(2,field._acquisition.samples);Test.assertEqual(2,field._engine._power._count);
    var originalPower=field._engine._power;var originalLap=field._acquisition.currentLap;
    props["a_align"]=0;props["p_off"]=999;
    field.applyFieldSets(secondSetConfiguration(props));Test.assert(field._fieldSets.second);
    Test.assert(field._engine._power==originalPower && field._acquisition.currentLap==originalLap);
    props["hr_off"]=140;field.applyFieldSets(secondSetConfiguration(props));Test.assert(!field._fieldSets.second);
    info.currentHeartRate=170;info.elapsedTime=2000;info.timerTime=2000;field.processActivity(info);Test.assert(field._fieldSets.second);
    Test.assertEqual(3,field._engine._power._count);
    field.onTimerPause();Test.assert(field._fieldSets.second);field.onTimerResume();Test.assert(field._fieldSets.second);
    info.currentHeartRate=null;info.elapsedTime=3000;info.timerTime=3000;field.processActivity(info);Test.assert(!field._fieldSets.second);
    Test.assertEqual(10,field._engine._descriptors.size());
    // A stable prepared frame can be replayed without transforming data or fitting runs.
    var renderer=new DrawOnlyRenderer();field._renderer=renderer;renderer.configure(field._settings);renderer.prepare(field._snapshot);
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());renderer.layout(dc,field._settings);
    var formats=field._engine.formatBuilds;var samples=field._acquisition.samples;renderer.locked=true;renderer.draw(dc,field._snapshot,field._settings);
    Test.assertEqual(formats,field._engine.formatBuilds);Test.assertEqual(samples,field._acquisition.samples);
    return true;
}


(:testSupport)
function verifySecondFactoryPreset(configuration) {
    var s=configuration.secondary;
    var expected=["power_3s","current_heart_rate","current_cadence","grade","lap_power","current_speed","lap_distance","lap_time","elevation","temperature"];
    Test.assertEqual(1,s.enlarged);Test.assertEqual("right",s.alignment);Test.assertEqual("horizontal",s.gridType);
    Test.assert(!s.usesClock && !s.usesBattery);
    for(var i=0;i<10;i+=1) {Test.assertEqual(expected[i],s.slots[i]);Test.assertEqual(i<4,s.effects[i]);}
}

(:testSupport)
function verifySecondPresetFallbacks() {
    var saved={"b_big"=>0,"b1_bg"=>0,"b1"=>"current_speed"};
    var s=secondSetConfiguration(saved);Test.assertEqual(0,s.secondary.enlarged);Test.assert(!s.secondary.effects[0]);
    Test.assertEqual("current_speed",s.secondary.slots[0]);Test.assertEqual(0,saved["b1_bg"]);
    s=secondSetConfiguration({"b_big"=>-1,"b1"=>null,"b1_bg"=>"false"});
    verifySecondFactoryPreset(s);
    s=secondSetConfiguration({"b4_bg"=>0,"b5_bg"=>1});
    Test.assert(!s.secondary.effects[3] && s.secondary.effects[4]);
}

// Actual app callbacks with SDK font measurement, rather than renderer-only dispatch.
(:testSupport)
class TeamLapField extends StrukturField {
    function initialize() { StrukturField.initialize(); }
    function temperatureReading() { return null; }
    function batteryReading() { return 50; }
}
(:testSupport)
class TeamLapCallbackScenario {
    var field;var properties;var configuration;var dc;
    function initialize() {
        properties={"trig"=>3};
        for(var slot=1;slot<=10;slot+=1) {
            properties["a"+slot]="team";properties["b"+slot]="team";
            properties["a"+slot+"_bg"]=1;properties["b"+slot+"_bg"]=2;
        }
    }
    function run() {
        field=new TeamLapField();configuration=new FieldSetsSettings();configuration.apply(properties);field.applyFieldSets(configuration);
        dc=new ScopedTeamDrawDc(profileDrawWidth(),profileDrawHeight());
        dc.active=true;field.method(:onLayout).invoke(dc);field.method(:onUpdate).invoke(dc);dc.active=false;Test.assert(field._renderer._nativeFonts._dc==null);
        for(var event=0;event<4;event+=1) {
            if(field.typedLapSupported()) { field.method(:onTimerLap2).invoke({:lapTrigger=>0}); } else { field.onTimerLap(); }
            Test.assertEqual(event%2==0,field._fieldSets.second);dc.active=true;field.method(:onLayout).invoke(dc);field.method(:onUpdate).invoke(dc);dc.active=false;Test.assert(field._renderer._nativeFonts._dc==null);
            Test.assert(field._renderer._runs[0].isNative);Test.assertEqual("TEAM",field._renderer._runs[0].text);
        }
    }
}

// A Data Field Dc expires when its callback returns; bitmap-backed test contexts do not.
(:testSupport)
class ScopedTeamDrawDc extends TeamDrawDc {
    var active=false;var widthReads=0;
    function initialize(w,h) { TeamDrawDc.initialize(w,h); }
    function getTextWidthInPixels(text,font) {
        Test.assert(active);widthReads+=1;return _measurement.getTextWidthInPixels(text,font);
    }
}
// Exercise the complete callback after layout with native text AND sprite values.
(:testSupport)
class MixedTeamLapCallbackScenario {
    var field;var props;var configuration;var dc;
    function initialize() {
        props={"trig"=>3,"a1"=>32,"a2"=>0,"a3"=>32,"b1"=>32,"b2"=>0,"b3"=>32,"team"=>"TEAM RIDE"};
        dc=new ScopedTeamDrawDc(profileDrawWidth(),profileDrawHeight());
    }
    function run() {
        field=new TeamLapField();
        for(var shape=0;shape<3;shape+=1) {
            for(var mode=0;mode<3;mode+=1) {
                props["a_big"]=shape;props["b_big"]=2-shape;
                props["a_align"]=shape%2;props["b_align"]=1-shape%2;
                props["a1_bg"]=mode;props["b1_bg"]=mode;
                configuration=new FieldSetsSettings();configuration.apply(props);field.applyFieldSets(configuration);
                dc.active=true;field.method(:onLayout).invoke(dc);dc.active=false;Test.assert(field._renderer._nativeFonts._dc==null);field.onTimerStart();
                for(var event=0;event<4;event+=1) {
                    if(field.typedLapSupported()) { field.method(:onTimerLap2).invoke({:lapTrigger=>0}); } else { field.onTimerLap(); }
                    Test.assertEqual(event%2==0,field._fieldSets.second);
                    dc.active=true;field.method(:onUpdate).invoke(dc);dc.active=false;Test.assert(field._renderer._nativeFonts._dc==null);
                    Test.assert(field._renderer._runs[0].isNative);Test.assertEqual("TEAM RIDE",field._renderer._runs[0].text);
                    Test.assert(!field._renderer._runs[1].isNative);Test.assert(field._renderer._packets[0].lines.size()>0);
                    Test.assert(field._renderer._packets[1].primary!=null);
                    if(field._renderer._runs.size()>2) { Test.assert(field._renderer._runs[2].isNative);Test.assertEqual(field._renderer._runs[0].text,field._renderer._runs[2].text); }
                }
            }
        }
    }
}
// Real Garmin Properties bridge and app callback; restore the test app's values.
(:testSupport)
class NativeSettingsCallbackScenario {
    var app;var oldView;var saved={};var props;var field;var dc;var loaded;
    function initialize() {
        props={"a1"=>32,"a2"=>32,"team"=>"NATIVE TEAM","tsrc"=>2,"a_align"=>0,"a_grid"=>2,"trig"=>3,"b1"=>32};
    }
    function run() {
        app=Toybox.Application.getApp();oldView=app._view;
        // Restore the isolated test application properties even after an assertion failure.
        var keys=SettingsCatalogue.keys();for(var i=0;i<keys.size();i+=1) { saved[keys[i]]=Toybox.Application.Properties.getValue(keys[i]); }
        try {
            field=new TeamLapField();app._view=field;dc=new ScopedTeamDrawDc(profileDrawWidth(),profileDrawHeight());
            var numeric=new FieldSetsSettings();numeric.apply({"a1"=>0,"a2"=>12,"b1"=>12});field.applyFieldSets(numeric);
            dc.active=true;field.method(:onLayout).invoke(dc);field.method(:onUpdate).invoke(dc);dc.active=false;
            Test.assert(!field._renderer._runs[0].isNative);Test.assert(field._renderer._nativeFonts._dc==null);
            var reads=dc.widthReads;
            keys=props.keys();for(var i=0;i<keys.size();i+=1) { Toybox.Application.Properties.setValue(keys[i],props[keys[i]]); }
            app.onSettingsChanged();Test.assertEqual(reads,dc.widthReads);Test.assert(field._renderer.needsLayout());
            dc.active=true;field.method(:onUpdate).invoke(dc);dc.active=false;
            Test.assert(field._renderer._nativeFonts._dc==null);Test.assert(dc.widthReads>reads);
            Test.assertEqual("team",field._settings.slots[0]);Test.assertEqual("team",field._settings.slots[1]);
Test.assertEqual(2,field._settings.teamSource);
            Test.assertEqual("NATIVE TEAM",field._snapshot[:values][1][ValueRecord.TEXT]);Test.assert(field._renderer._runs[0].isNative);
            Test.assertEqual("center",field._settings.alignment);Test.assertEqual("full",field._settings.gridType);
            reads=dc.widthReads;field.refreshPresentation();Test.assertEqual(reads,dc.widthReads);
            Test.assert(!field._renderer.needsLayout());
            field.onTimerStart();
            if(field.typedLapSupported()) { field.method(:onTimerLap2).invoke({:lapTrigger=>0}); } else { field.onTimerLap(); }
            Test.assert(field._fieldSets.second);
            Toybox.Application.Properties.setValue("team","UPDATED TEAM");
            Toybox.Application.Properties.setValue("tsrc",1);
            reads=dc.widthReads;app.onSettingsChanged();Test.assertEqual(reads,dc.widthReads);
            dc.active=true;field.method(:onUpdate).invoke(dc);dc.active=false;Test.assert(field._renderer._nativeFonts._dc==null);
            Test.assertEqual("UPDATED TEAM",field._renderer._runs[0].text);
            Test.assert(field._fieldSets.second);Test.assertEqual("UPDATED TEAM",field._snapshot[:values][0][ValueRecord.TEXT]);
            loaded=new FieldSetsSettings();loaded.load();

            Test.assertEqual(1,loaded.primary.teamSource);Test.assertEqual(1,loaded.secondary.teamSource);
            Test.assertEqual("UPDATED TEAM",loaded.primary.teamText);Test.assertEqual("UPDATED TEAM",loaded.secondary.teamText);
            Test.assertEqual("team",loaded.primary.slots[1]);
        } finally {
            app._view=oldView;
            keys=saved.keys();for(var i=0;i<keys.size();i+=1) { Toybox.Application.Properties.setValue(keys[i],saved[keys[i]]); }
        }
    }
}

(:test)
function mixedTeamLapCallbacks(logger) { new MixedTeamLapCallbackScenario().run();return true; }
(:test)
function nativeSettingsCallbacks(logger) { new NativeSettingsCallbackScenario().run();return true; }
