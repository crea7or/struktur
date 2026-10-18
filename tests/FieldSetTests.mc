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
function secondarySettingsAndMigration(logger) {
    var saved={"alignment"=>0,"slot_10_value"=>"battery","slot_10_background_effects"=>true,
        "second_alignment"=>1,"second_slot_1_value"=>"lap_power","second_slot_10_value"=>"future-field",
        "second_slot_1_background_effects"=>true,"second_enlarged_field_count"=>2,"second_hide_value_units"=>false};
    var s=secondSetConfiguration(saved);
    Test.assertEqual(142,SettingsCatalogue.keys().size());
    Test.assertEqual("center",s.primary.alignment);Test.assertEqual("right",s.secondary.alignment);
    Test.assertEqual("battery",s.primary.slots[9]);Test.assert(s.primary.effects[9]);
    Test.assertEqual("lap_power",s.secondary.slots[0]);Test.assertEqual("future-field",s.secondary.slots[9]);
    Test.assertEqual(2,s.secondary.enlarged);Test.assert(!s.secondary.hideValueUnits && s.secondary.effects[0]);
    Test.assertEqual(3,s.trigger);Test.assertEqual(250,s.powerActivate);Test.assertEqual(220,s.powerReturn);
    Test.assertEqual(160,s.heartActivate);Test.assertEqual(150,s.heartReturn);
    var defaults=secondSetConfiguration({"alignment"=>0,"slot_1_value"=>"battery"});
    Test.assertEqual("right",defaults.secondary.alignment);verifySecondFactoryPreset(defaults);
    verifySecondFactoryPreset(new FieldSetsSettings());
    verifySecondPresetFallbacks();
    var factoryController=new FieldSetController(new FieldSetsSettings());
    Test.assert(!factoryController.second);factoryController.lap(true);Test.assert(factoryController.second);
    factoryController.lap(true);Test.assert(!factoryController.second);
    factoryController.configure(secondSetConfiguration({"second_set_trigger"=>0}));
    factoryController.lap(true);Test.assert(!factoryController.second);Test.assertEqual(0,factoryController.configuration.trigger);
    for(var i=0;i<32;i+=1) { Test.assertEqual(Catalog.IDS[i],SettingsCatalogue.decode("second_slot_1_value",i)); }
    Test.assertEqual("night",SettingsCatalogue.decode("second_theme_mode",2));
    for(var mode=0;mode<=4;mode+=1) { s=secondSetConfiguration({"second_set_trigger"=>mode});Test.assertEqual(mode,s.trigger); }
    var invalid=[null,-1,5,2.0,"2",true];
    for(var j=0;j<invalid.size();j+=1) {
        s=secondSetConfiguration({"second_set_trigger"=>invalid[j],"second_power_activate_w"=>invalid[j],"second_hr_return_bpm"=>invalid[j]});
        Test.assertEqual(3,s.trigger);
        if(j!=2) { Test.assertEqual(250,s.powerActivate); }
        Test.assertEqual(150,s.heartReturn);
    }
    s=secondSetConfiguration({"second_set_trigger"=>1,"second_power_activate_w"=>200,"second_power_return_w"=>220});
    var c=new FieldSetController(s);c.evaluate({"power_3s"=>300},true);Test.assert(!c.second);
    s=secondSetConfiguration({"second_set_trigger"=>2,"second_power_activate_w"=>200,"second_power_return_w"=>220});
    c.configure(s);c.evaluate({"current_heart_rate"=>170},true);Test.assert(c.second);
    s=secondSetConfiguration({"second_power_activate_w"=>3000,"second_power_return_w"=>1,
        "second_hr_activate_bpm"=>250,"second_hr_return_bpm"=>30});
    Test.assertEqual(3000,s.powerActivate);Test.assertEqual(1,s.powerReturn);Test.assertEqual(250,s.heartActivate);Test.assertEqual(30,s.heartReturn);
    s=secondSetConfiguration({"second_power_activate_w"=>3001,"second_power_return_w"=>0,
        "second_hr_activate_bpm"=>251,"second_hr_return_bpm"=>29});
    Test.assertEqual(250,s.powerActivate);Test.assertEqual(220,s.powerReturn);Test.assertEqual(160,s.heartActivate);Test.assertEqual(150,s.heartReturn);
    var restarted=secondSetConfiguration(saved);Test.assertEqual("lap_power",restarted.secondary.slots[0]);
    Test.assertEqual("future-field",restarted.secondary.slots[9]);Test.assertEqual(0,saved["alignment"]);
    return true;
}

(:test)
function secondaryThresholdSources(logger) {
    var c=new FieldSetController(secondSetConfiguration({"second_set_trigger"=>1}));
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
    c.evaluate({},true);Test.assert(!c.second); // first resumed warm-up result is unavailable
    c.configure(secondSetConfiguration({"second_set_trigger"=>1,"second_power_activate_w"=>250,"second_power_return_w"=>250}));
    c.evaluate({"power_3s"=>250},true);Test.assert(c.second);c.evaluate({"power_3s"=>249.9},true);Test.assert(!c.second);
    c.configure(secondSetConfiguration({"second_set_trigger"=>2}));
    values=[159,160,155,150,149];
    for(var h=0;h<values.size();h+=1) { c.evaluate({"current_heart_rate"=>values[h],"heart_rate_3s"=>200},true);Test.assertEqual(expected[h],c.second); }
    c.evaluate({"current_heart_rate"=>170,"power_3s"=>null},true);Test.assert(c.second);
    c.evaluate({"current_heart_rate"=>0},true);Test.assert(!c.second);
    // Real Data Field pipeline: three consecutive power seconds, no power fields in either bank.
    var field=new SecondSetField();var props={"second_set_trigger"=>1};
    for(var slot=1;slot<=10;slot+=1) {props["slot_"+slot+"_value"]="current_heart_rate";props["second_slot_"+slot+"_value"]="current_heart_rate";}
    field.applyFieldSets(secondSetConfiguration(props));var info=new AcquisitionInfo();info.timerState=Activity.TIMER_STATE_ON;info.currentPower=300;
    for(var second=0;second<3;second+=1) { info.elapsedTime=second*1000;info.timerTime=second*1000;field.processActivity(info);Test.assertEqual(second==2,field._fieldSets.second); }
    Test.assertEqual(3,field._engine._power._count);Test.assertEqual(3,field._acquisition.samples);
    info.currentPower=null;info.elapsedTime=3000;info.timerTime=3000;field.processActivity(info);Test.assert(!field._fieldSets.second);
    info.currentPower=0;
    for(var zero=4;zero<=6;zero+=1) {info.elapsedTime=zero*1000;info.timerTime=zero*1000;field.processActivity(info);}
    Test.assertEqual(0.0,field._snapshot[:raw]["power_3s"]);Test.assert(!field._fieldSets.second);
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
        field.applyFieldSets(secondSetConfiguration({"second_set_trigger"=>mode}));field.onLapNotification(true);Test.assert(!field._fieldSets.second);
    }
    return true;
}

(:test)
function secondaryWorkoutCallbacks(logger) {
    var field=new SecondSetField();field.applyFieldSets(secondSetConfiguration({"second_set_trigger"=>4}));
    Test.assert(!field._fieldSets.second);field.onWorkoutStarted();Test.assert(field._fieldSets.second);
    field.onWorkoutStarted();field.onTimerPause();field.onTimerStop();field.onTimerResume();field.onTimerStart();
    field.onLapNotification(true);field.onLapNotification(false);field.onWorkoutStepComplete();field.onHide();field.onShow();
    field.processActivity(new AcquisitionInfo());Test.assert(field._fieldSets.second);
    field.onTimerReset();Test.assert(!field._fieldSets.second);field.onLapNotification(true);Test.assert(!field._fieldSets.second);
    field.onWorkoutStarted();Test.assert(field._fieldSets.second);
    field.applyFieldSets(secondSetConfiguration({"second_set_trigger"=>0}));field.onWorkoutStarted();Test.assert(!field._fieldSets.second);
    field.applyFieldSets(secondSetConfiguration({"second_set_trigger"=>4}));Test.assert(!field._fieldSets.second);
    var late=new FieldSetController(secondSetConfiguration({"second_set_trigger"=>4}));late.evaluate({},true);Test.assert(!late.second);
    late.workout();late.evaluate({"_activity_identity"=>100},true);Test.assert(late.second);
    late.evaluate({"_activity_identity"=>200},true);Test.assert(!late.second);
    return true;
}

(:test)
function secondaryAtomicAcquisition(logger) {
    var props={"second_set_trigger"=>2,"second_alignment"=>0,"second_enlarged_field_count"=>1,
        "second_theme_mode"=>2,"second_hide_value_units"=>false,"second_grid_type"=>0,"second_slot_10_value"=>"battery"};
    for(var slot=1;slot<=9;slot+=1) {props["slot_"+slot+"_value"]="current_power";props["second_slot_"+slot+"_value"]="current_heart_rate";}
    props["slot_10_value"]="current_power";
    var field=new SecondSetField();field.applyFieldSets(secondSetConfiguration(props));
    var info=new AcquisitionInfo();info.timerState=Activity.TIMER_STATE_ON;info.currentHeartRate=140;info.currentPower=200;info.startTime=new Time.Moment(100);
    field.processActivity(info);field._renderer.layout(new PresentationDrawDc(profileDrawWidth(),profileDrawHeight()),field._settings);var first=field._snapshot;Test.assertEqual(0,field.batteryReads);
    info.currentHeartRate=170;info.elapsedTime=1000;info.timerTime=1000;field.processActivity(info);
    Test.assert(field._fieldSets.second);Test.assert(field._settings==field._fieldSets.configuration.secondary);
    Test.assertEqual("center",field._settings.alignment);Test.assertEqual("none",field._settings.gridType);
    Test.assertEqual(1,field._settings.enlarged);Test.assert(field._snapshot[:night]);Test.assertEqual(1,field.batteryReads);
    Test.assert(field.releasedPresentations>0);Test.assertEqual("64",field._snapshot[:values][9][:text]);Test.assertEqual("hr | bpm",field._snapshot[:values][0][:label]);
    Test.assertEqual("watts",first[:values][0][:label]);Test.assertEqual("200",first[:values][0][:text]);
    Test.assertEqual(2,field._acquisition.samples);Test.assertEqual(2,field._engine._power._count);
    var originalPower=field._engine._power;var originalLap=field._acquisition.currentLap;
    props["alignment"]=0;props["second_power_return_w"]=999;
    field.applyFieldSets(secondSetConfiguration(props));Test.assert(field._fieldSets.second);
    Test.assert(field._engine._power==originalPower && field._acquisition.currentLap==originalLap);
    props["second_hr_return_bpm"]=140;field.applyFieldSets(secondSetConfiguration(props));Test.assert(!field._fieldSets.second);
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
    var saved={"second_enlarged_field_count"=>0,"second_slot_1_background_effects"=>false,"second_slot_1_value"=>"current_speed"};
    var s=secondSetConfiguration(saved);Test.assertEqual(0,s.secondary.enlarged);Test.assert(!s.secondary.effects[0]);
    Test.assertEqual("current_speed",s.secondary.slots[0]);Test.assertEqual(false,saved["second_slot_1_background_effects"]);
    s=secondSetConfiguration({"second_enlarged_field_count"=>-1,"second_slot_1_value"=>null,"second_slot_1_background_effects"=>"false"});
    verifySecondFactoryPreset(s);
    s=secondSetConfiguration({"second_slot_4_background_effects"=>false,"second_slot_5_background_effects"=>true});
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
        properties={"second_set_trigger"=>3};
        for(var slot=1;slot<=10;slot+=1) {
            properties["slot_"+slot+"_value"]="team";properties["second_slot_"+slot+"_value"]="team";
            properties["slot_"+slot+"_background_mode"]=1;properties["second_slot_"+slot+"_background_mode"]=2;
        }
    }
    function run() {
        field=new TeamLapField();configuration=new FieldSetsSettings();configuration.apply(properties);field.applyFieldSets(configuration);
        dc=new TeamDrawDc(profileDrawWidth(),profileDrawHeight());
        field.method(:onLayout).invoke(dc);field.method(:onUpdate).invoke(dc);
        for(var event=0;event<4;event+=1) {
            if(field.typedLapSupported()) { field.onLapNotification(true); } else { field.onTimerLap(); }
            Test.assertEqual(event%2==0,field._fieldSets.second);field.method(:onLayout).invoke(dc);field.method(:onUpdate).invoke(dc);
            Test.assert(field._renderer._runs[0].isNative);Test.assertEqual("TEAM",field._renderer._runs[0].text);
        }
    }
}
