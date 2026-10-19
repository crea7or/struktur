using Toybox.Test;
using Toybox.Activity;
using Toybox.Time;
using Toybox.Math;
using Toybox.Sensor;

// DVS-29: fixed regression fixtures, including exactly representable halfway values.
(:test)
function gradeRegression(logger) {
    var g=new GradeEstimator();
    Test.assertEqual(0.0,g.push(100,0,0,true,100));
    Test.assertEqual(0.0,g.push(101,10,1000,true,100));
    Test.assertEqual(10.0d,g.push(102,20,2000,true,100));
    Test.assertEqual(10.0d,g.push(999,20,2000,true,100));
    g.push(103,30,3000,true,100);g.push(104,40,4000,true,100);
    Test.assertEqual(14.0d,g.push(107,50,5000,true,100)); // Latest regression is published immediately, without temporal averaging.
    Test.assertEqual(14.0d,g.estimate());
    Test.assertEqual(5,g.sampleCount());Test.assertEqual(10,g.point(0)[0]);
    g.reset();g.push(-10,0,0,true,100);g.push(-11,10,1000,true,100);
    Test.assertEqual(-10.0d,g.push(-12,20,2000,true,100));
    g.reset();g.push(0,0,0,true,100);g.push(20,10,1000,true,100);
    Test.assertEqual(200.0d,g.push(40,20,2000,true,100));
    Test.assertEqual("black",Effects.gradeBand(200));Test.assertEqual(45.0,Effects.horizonAngle(200));
    g.reset();g.push(0,0,0,true,100);g.push(1,0,1000,true,100);
    Test.assertEqual(0.0,g.push(2,0,2000,true,100)); // zero denominator
    g.reset();g.push(0,0,0,true,100);g.push(1.0625d,50,1000,true,100);
    Test.assertEqual(2.13d,g.push(2.125d,100,2000,true,100));
    g.reset();g.push(0,0,0,true,100);g.push(-1.0625d,50,1000,true,100);
    Test.assertEqual(-2.13d,g.push(-2.125d,100,2000,true,100));
    g.reset();g.push(1000000.0d,1000000000.0d,0,true,100);g.push(1000001.0d,1000000010.0d,1000,true,100);
    Test.assertEqual(10.0d,g.push(1000002.0d,1000000020.0d,2000,true,100));
    Test.assertEqual("10.0",Formatting.floating(10));
    Test.assertEqual("-2.1",Formatting.fixed(-2.06,1));
    Test.assertEqual("10000",Formatting.floating(9999.99));
    Test.assertEqual("100000",Formatting.floating(100000));
    Test.assertEqual("N",Formatting.cardinal(0.0));Test.assertEqual("NW",Formatting.cardinal(-45));
    Test.assert(Formatting.cardinal(null)==null);
    fixedSlopePrecision(logger);
    return true;
}

(:test)
function gradeResetAndBounds(logger) {
    var g=new GradeEstimator();g.push(0,0,0,true,100);g.push(1,10,1000,true,100);
    Test.assertEqual(10.0d,g.push(2,20,2000,true,100));
    Test.assertEqual(10.0d,g.push(999,20,2000,true,100));Test.assertEqual(3,g.sampleCount());
    Test.assert(g.push(2,20,3000,true,100)!=null); // repeated distance is a valid sample
    Test.assert(g.push(2,20,4000,true,100)!=null);
    Test.assert(g.push(2,20,5000,true,100)==null);Test.assertEqual(0,g.sampleCount());
    Test.assert(g.push(2,20,6000,true,100)==null); // remain stalled
    Test.assertEqual(0.0,g.push(3,30,7000,true,100));Test.assertEqual(1,g.sampleCount());
    g.reset();g.push(0,0,0,true,100);
    Test.assertEqual(0.0,g.push(1,10,2000,true,100)); // exactly 2s accepted, warm-up
    Test.assertEqual(0.0,g.push(2,20,4001,true,100));Test.assertEqual(1,g.sampleCount());
    Test.assertEqual(0.0,g.push(3,30,3000,true,100)); // time regression resets
    Test.assertEqual(0.0,g.push(3,29,4000,true,100)); // distance regression resets
    Test.assertEqual(0.0,g.push(4,39,5000,true,200)); // identity resets
    Test.assert(g.push(5,49,6000,false,200)==null);Test.assertEqual(0,g.sampleCount());
    for(var i=0;i<150;i+=1) {g.push(0,i/10.0,i*1000,true,200);Test.assert(g.sampleCount()<=5);}
    Test.assertEqual(5,g.sampleCount());Test.assertEqual(145000,g.point(0)[2]);
    g.reset();g.push(0,0,0,true,200);g.push(1,1,500,true,200);Test.assertEqual(1,g.sampleCount());
    Test.assert(g.push(null,2,1000,true,200)==null);Test.assertEqual(0,g.sampleCount());
    return true;
}

(:test)
function lapBaselineLifecycle(logger) {
    var laps=new LapTracker();
    laps.onStart(); laps.onLap();
    Test.assert(laps.value()==null); // loading a running activity never invents zero
    laps.observe(true,100,false,65000,65000,300);
    laps.onLap(); Test.assert(laps.value()==null);
    laps.onReset(); laps.onLap(); Test.assert(laps.value()==null); // old/end-session event
    Test.assert(laps.observe(true,null,true,0,0,0)==null);
    laps.onStart(); Test.assertEqual(0,laps.value());
    laps.observe(true,200,false,1000,1000,10);
    laps.onLap(); laps.onLap(); Test.assertEqual(2,laps.value());
    // Pause/stop followed by start do not establish a new counter.
    laps.observe(true,200,true,1000,2000,10); laps.onStart();
    Test.assertEqual(2,laps.observe(true,200,false,2000,3000,20));
    laps.onReset(); laps.onLap(); laps.onStart(); Test.assertEqual(0,laps.value());
    return true;
}

(:test)
function lapIdentityAndOverflow(logger) {
    var laps=new LapTracker();
    Test.assert(laps.observe(false,null,true,0,0,0)==null);
    Test.assert(laps.observe(true,null,true,null,0,0)==null);
    Test.assert(laps.observe(true,100,true,0,0,0)==null);
    Test.assert(laps.observe(true,null,true,0,0,0)==null);
    laps.onStart(); laps.observe(true,100,false,1000,1000,10); laps.onLap();
    Test.assert(laps.observe(true,200,false,2000,2000,20)==null);
    laps.onLap(); Test.assert(laps.value()==null);
    for(var regression=0;regression<3;regression+=1) {
        laps.onReset(); laps.onStart(); laps.observe(true,300,false,100,100,100);
        Test.assert(laps.observe(true,300,false,regression==0?99:101,regression==1?99:101,regression==2?99:101)==null);
    }
    laps.onReset(); laps.onStart(); laps._count=2147483647;
    laps.onLap(); Test.assert(laps.value()==null);
    // Proven continuity loss invalidates the total; hiding an existing view alone does not.
    laps.onReset(); laps.onStart(); laps.onLap(); laps.invalidate(); Test.assert(laps.value()==null);
    return true;
}

(:test)
function temperatureProtocolAndAge(logger) {
    var c=new TemperatureCache();
    Test.assert(c.value(1000,0)==null);
    Test.assertEqual(true,c.receive([2,0,1000,"edge-native-v2"],1000,0,true));
    Test.assertEqual(0,c.value(1000,0));
    Test.assertEqual(0,c.value(1359,359000));
    Test.assertEqual(0,c.value(1360,360000));
    Test.assert(c.value(1361,361000)==null);
    c=new TemperatureCache(); c.receive([2,10,1000,"edge-native-v2"],1000,0,true);
    Test.assertEqual(false,c.receive([2,20,1000,"edge-native-v2"],1100,100000,true));
    Test.assertEqual(false,c.receive([2,20,999,"edge-native-v2"],1100,100000,true));
    Test.assertEqual(false,c.receive([2,20,1101,"edge-native-v2"],1100,100000,true));
    Test.assertEqual(false,c.receive([3,20,1100,"edge-native-v2"],1100,100000,true));
    Test.assertEqual(false,c.receive([2,20,1100,"external"],1100,100000,true));
    Test.assertEqual(false,c.receive("invalid",1100,100000,true));
    Test.assertEqual(false,c.receive([1,20,1100,"onboard-v1"],1100,100000,true));
    Test.assertEqual(10,c.value(1100,100000));
    Test.assertEqual(false,c.receive([2,null,1100,"edge-native-v2"],1100,100000,true));
    Test.assert(c.value(1100,100000)==null); // newer invalid read clears cache
    Test.assertEqual(false,c.receive([2,20,1000,"edge-native-v2"],1100,100000,true));
    var settings=new DisplaySettings();settings.apply({"a1"=>"temperature","a1_bg"=>1});
    var engine=new SnapshotEngine();
    var samples=[[0,"0.0","32.0","cyan"],[12.34,"12.3","54.2","green"],
        [1.25,"1.3","34.3","white"],[-1.25,"-1.3","29.8","cyan"],
        [-0.04,"0.0","31.9","cyan"],[20.04,"20.0","68.1","yellow"],
        [-40,"-40.0","-40.0","blue"],[60,"60.0","140.0","red"]];
    for(var i=0;i<samples.size();i+=1) {
        for(var statute=0;statute<2;statute+=1) {
            var snapshot=engine.prepareWithPreferences({"temperature"=>samples[i][0]},settings,true,
                new PresentationDevice(statute==1,true,false),new PresentationClock());
            Test.assertEqual(samples[i][statute==1?2:1],snapshot[:values][0][ValueRecord.TEXT]);
            Test.assertEqual(samples[i][3],snapshot[:values][0][ValueRecord.BAND]);
        }
    }
    var missing=engine.prepareWithPreferences({"temperature"=>null},settings,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assert(missing[:values][0][ValueRecord.TEXT]==null);
    return true;
}

(:test)
function temperatureClockAndDelivery(logger) {
    var c=new TemperatureCache();
    Test.assertEqual(true,c.receive([2,-10,1000,"edge-native-v2"],1359,0,true));
    Test.assertEqual(-10,c.value(1360,1000));
    Test.assert(c.value(1360,2000)==null); // monotonic guard includes delivery age
    c=new TemperatureCache();
    Test.assertEqual(false,c.receive([2,0,1000,"edge-native-v2"],1361,0,true));
    c=new TemperatureCache(); c.receive([2,0,1000,"edge-native-v2"],1000,0,true);
    Test.assertEqual(0,c.value(1100,100000));
    Test.assert(c.value(1099,101000)==null); // wall-clock rollback
    c=new TemperatureCache(); c.receive([2,0,1000,"edge-native-v2"],1000,1000,true);
    Test.assert(c.value(1001,999)==null); // timer wrap/rollback fails conservatively
    c=new TemperatureCache(); c.receive([2,0,1000,"edge-native-v2"],1000,0,true);
    Test.assert(c.value(1400,1000)==null); // forward clock change
    c=new TemperatureCache(); c.receive([2,0,1000,"edge-native-v2"],1000,0,true);
    Test.assertEqual(false,c.receive([2,20,1100,"edge-native-v2"],1100,100000,false));
    Test.assert(c.value(1100,100000)==null);
    return true;
}

(:testSupport)
class TemperatureRegistration {
    var type=Sensor.SENSOR_TEMPERATURE;var technology;
    function initialize(tech) { technology=tech; }
}
(:testSupport)
class TemperatureRegistry {
    var sensors;var index=0;
    function initialize(items) { sensors=items; }
    function next() { if(index>=sensors.size()) { return null; } var item=sensors[index];index+=1;return item; }
}

(:test)
function temporalAndSourceQualification(logger) {
    Test.assertEqual(1000,TemperatureSchedule.earliest(1000,null));
    Test.assertEqual(1300,TemperatureSchedule.earliest(1000,1000));
    Test.assertEqual(1300,TemperatureSchedule.earliest(1300,1000));
    Test.assertEqual(1400,TemperatureSchedule.earliest(1400,1000));
    Test.assertEqual(true,TemperatureSource.registeredOnboard(new TemperatureRegistry([])));
    Test.assertEqual(true,TemperatureSource.registeredOnboard(new TemperatureRegistry([new TemperatureRegistration(Sensor.SENSOR_TECHNOLOGY_ONBOARD)])));
    Test.assertEqual(false,TemperatureSource.registeredOnboard(null));
    Test.assertEqual(false,TemperatureSource.registeredOnboard({}));
    var technologies=[Sensor.SENSOR_TECHNOLOGY_ANT,Sensor.SENSOR_TECHNOLOGY_BLE,null,99,2.0];
    for(var i=0;i<technologies.size();i+=1) {
        Test.assertEqual(false,TemperatureSource.registeredOnboard(new TemperatureRegistry([new TemperatureRegistration(technologies[i])])));
    }
    Test.assertEqual(false,TemperatureSource.registeredOnboard(new TemperatureRegistry([{}])));
    var wrong=new TemperatureRegistration(Sensor.SENSOR_TECHNOLOGY_ONBOARD);wrong.type=Sensor.SENSOR_HEARTRATE;
    Test.assertEqual(false,TemperatureSource.registeredOnboard(new TemperatureRegistry([wrong])));
    var many=[];
    for(var n=0;n<33;n+=1) { many.add(new TemperatureRegistration(Sensor.SENSOR_TECHNOLOGY_ONBOARD)); }
    Test.assertEqual(false,TemperatureSource.registeredOnboard(new TemperatureRegistry(many)));
    var c=new TemperatureCache();
    Test.assertEqual(false,c.receive([2,20,1000,"edge-native-v2"],1000,0,false));
    Test.assert(c.value(1000,0)==null); // callback admission and packet compatibility remain mandatory
    return true;
}

(:testSupport)
class AcquisitionInfo {
    var altitude=0;
    var elapsedDistance=0;
    var elapsedTime=0;
    var timerTime=0;
    var timerState=Activity.TIMER_STATE_OFF;
    var startTime=null;
    var currentHeartRate=100;
    var currentPower=100;
    var currentCadence=80;
}

(:test)
function rollingActivityClockAndValidity(logger) {
    var engine=new SnapshotEngine();var settings=new DisplaySettings();
    var raw={"_sampling_enabled"=>true,"_activity_identity"=>100,"current_power"=>100,"current_heart_rate"=>100};
    for(var i=1;i<=3;i+=1) {
        raw["elapsed_time"]=i*1000;raw["current_power"]=i*100;engine.compute(raw,settings);
        Test.assertEqual((i+1)*50.0,raw["power_3s"]);
        if(i<3) { Test.assert(raw["heart_rate_3s"]==null); }
    }
    Test.assertEqual(200.0,raw["power_3s"]);Test.assertEqual(100.0,raw["heart_rate_3s"]);
    raw["current_power"]=999;raw["elapsed_time"]=3999;engine.compute(raw,settings);
    Test.assertEqual(200.0,raw["power_3s"]); // duplicate activity second, independent of wall time
    raw["elapsed_time"]=4000;raw["current_heart_rate"]=0;raw["current_power"]=-1;engine.compute(raw,settings);
    Test.assert(raw["heart_rate_3s"]==null && raw["power_3s"]==null);
    raw["current_power"]=0;raw["current_heart_rate"]=120;
    for(var j=5;j<=7;j+=1) { raw["elapsed_time"]=j*1000;engine.compute(raw,settings); }
    Test.assertEqual(0.0,raw["power_3s"]);Test.assertEqual(120.0,raw["heart_rate_3s"]);
    raw["_activity_identity"]=200;raw["elapsed_time"]=8000;engine.compute(raw,settings);
    Test.assertEqual(0.0,raw["power_3s"]);Test.assert(raw["heart_rate_3s"]==null);
    raw["elapsed_time"]=9000;raw["current_power"]=300;engine.compute(raw,settings);Test.assertEqual(150.0,raw["power_3s"]);
    raw["elapsed_time"]=12000;raw["current_power"]=90;engine.compute(raw,settings);Test.assertEqual(90.0,raw["power_3s"]);
    Test.assert(raw["heart_rate_3s"]==null); // Both channels reset on a gap; power resumes immediately.
    raw["elapsed_time"]=null;engine.compute(raw,settings);Test.assert(engine._power._count==0);
    raw["elapsed_time"]=10000;raw["_sampling_enabled"]=false;engine.compute(raw,settings);
    Test.assert(engine._heart._count==0 && engine._power._count==0);
    raw["elapsed_time"]=11000;raw["_sampling_enabled"]=true;raw["current_power"]=60;engine.compute(raw,settings);
    Test.assertEqual(60.0,raw["power_3s"]);Test.assert(raw["heart_rate_3s"]==null);
    raw["elapsed_time"]=12000;raw["current_power"]=-1;engine.compute(raw,settings);Test.assert(raw["power_3s"]==null);
    raw["elapsed_time"]=13000;raw["current_power"]=0;engine.compute(raw,settings);Test.assertEqual(0.0,raw["power_3s"]);
    return true;
}

(:test)
function approvedZoneSnapshot(logger) {
    var bounds=[90,110,130,150,170,190];
    Test.assert(ZoneMetadata.heart([0,100,200])==null);
    Test.assert(ZoneMetadata.heart([-1,110,130,150,170,190])==null);
    Test.assert(ZoneMetadata.heart([90,110,110,150,170,190])==null);
    Test.assert(ZoneMetadata.power(bounds,false)==null);
    Test.assertEqual(1,ZoneMetadata.classify(110.4,bounds));
    Test.assertEqual(2,ZoneMetadata.classify(110.5,bounds));
    Test.assert(ZoneMetadata.classify(89,bounds)==null);
    Test.assert(ZoneMetadata.classify(191,bounds)==null);
    var e=new SnapshotEngine();e._hrZones=ZoneMetadata.heart(bounds);
    // Qualified normalized power fixture; it does not qualify the production API adapter.
    e._powerZones=ZoneMetadata.power([0,110,200,300],true);
    var s=new DisplaySettings();s.apply({"a1"=>4,"a2"=>6,"a3"=>7,"a4"=>10,
        "a1_bg"=>1,"a3_bg"=>1});
    var snapshot=e.compute({"current_heart_rate"=>110.4,"current_power"=>110.4},s);
    Test.assertEqual("110",snapshot[:values][0][ValueRecord.TEXT]);Test.assertEqual("1",snapshot[:values][1][ValueRecord.TEXT]);
    Test.assertEqual("blue",snapshot[:values][0][ValueRecord.BAND]);Test.assertEqual("blue",snapshot[:values][2][ValueRecord.BAND]);
    Test.assertEqual("1",snapshot[:values][3][ValueRecord.TEXT]);
    return true;
}

(:test)
function currentLapAcquisition(logger) {
    var a=new ActivityAcquisition();var info=new AcquisitionInfo();
    a.read(info,{});a.onStart();info.startTime=new Time.Moment(100);info.timerState=Activity.TIMER_STATE_ON;
    var raw=a.read(info,{});Test.assertEqual(0,raw["lap_distance"]);Test.assertEqual(0,raw["lap_time"]);
    Test.assert(raw["lap_speed"]==null && raw["lap_power"]==null);
    info.elapsedTime=1000;info.timerTime=1000;info.elapsedDistance=10;
    info.currentPower=200;info.currentCadence=100;info.currentHeartRate=140;
    raw=a.read(info,{});
    Test.assertEqual(150.0d,raw["lap_power"]);Test.assertEqual(90.0d,raw["lap_cadence"]);
    Test.assertEqual(120.0d,raw["lap_heart_rate"]);Test.assertEqual(10.0,raw["lap_speed"]);
    info.elapsedTime=3000;info.timerTime=3000;info.elapsedDistance=30;
    info.currentPower=0;info.currentCadence=0;info.currentHeartRate=0;
    raw=a.read(info,{});
    Test.assertEqual("117",Formatting.integral(raw["lap_power"]));
    Test.assertEqual("63",Formatting.integral(raw["lap_cadence"]));
    Test.assertEqual(120.0d,raw["lap_heart_rate"]); // invalid HR contributes no time
    a.currentLap.pause();info.elapsedTime=6000;raw=a.read(info,{});
    Test.assertEqual(3000,raw["lap_time"]);a.currentLap.resume();
    info.elapsedTime=7000;info.timerTime=4000;info.currentPower=500;raw=a.read(info,{});
    Test.assertEqual("117",Formatting.integral(raw["lap_power"])); // resume only seeds
    a.boundary(info);raw={};a.currentLap.publish(raw);
    Test.assertEqual(0,raw["lap_time"]);Test.assertEqual(0,raw["lap_distance"]);Test.assert(raw["lap_power"]==null);
    info.elapsedTime=8000;info.timerTime=5000;info.elapsedDistance=40;info.currentPower=100;
    raw=a.read(info,{});Test.assertEqual(300.0d,raw["lap_power"]);Test.assertEqual(10,raw["lap_distance"]);
    // Distance regression invalidates distance/speed but preserves independent timer/channel state.
    info.elapsedTime=9000;info.timerTime=6000;info.elapsedDistance=29;raw=a.read(info,{});
    Test.assert(raw["lap_distance"]==null && raw["lap_speed"]==null);Test.assertEqual(2000,raw["lap_time"]);
    info.elapsedDistance=100;info.elapsedTime=10000;info.timerTime=7000;raw=a.read(info,{});Test.assert(raw["lap_distance"]==null);
    a.onReset();a.boundary(info);raw={};a.currentLap.publish(raw);Test.assert(raw["lap_time"]==null);
    return true;
}

(:test)
function currentLapLateAttachAndGaps(logger) {
    var lap=new CurrentLap();var info=new AcquisitionInfo();info.startTime=new Time.Moment(100);
    info.timerState=Activity.TIMER_STATE_ON;info.elapsedTime=10000;info.timerTime=9000;info.elapsedDistance=100;
    var raw={};lap.read(info,raw,100);Test.assert(raw["lap_time"]==null);
    lap.boundary(info);info.elapsedTime=11000;info.timerTime=10000;info.elapsedDistance=110;lap.read(info,raw,100);
    Test.assertEqual(1000,raw["lap_time"]);Test.assertEqual(100.0d,raw["lap_power"]);
    info.elapsedTime=14001;info.timerTime=13001;info.currentPower=500;lap.read(info,raw,100);
    Test.assertEqual(100.0d,raw["lap_power"]); // gap excluded, current endpoint seeded
    lap.read(info,raw,100);Test.assertEqual(100.0d,raw["lap_power"]); // duplicate adds no weight
    info.elapsedTime=15001;info.timerTime=14001;lap.read(info,raw,200);
    Test.assert(raw["lap_time"]==null && raw["lap_power"]==null); // changed activity
    info.startTime=new Time.Moment(200);info.timerTime=null;lap.boundary(info);
    info.timerTime=15001;info.elapsedTime=16001;lap.read(info,raw,200);
    Test.assert(raw["lap_time"]==null && raw["lap_power"]==null); // no invented boundary baseline
    Test.assertEqual(0,raw["lap_distance"]);
    var mean=new LapMean(false);mean.push(100,1000,1000,true);mean.push(200,2000,2000,true);
    mean.push(999,1500,1500,true);mean.push(0,3000,3000,true);
    Test.assertEqual(125.0d,mean.value()); // older endpoint never replaces the newest
    return true;
}

(:test)
function acquisitionToSnapshot(logger) {
    var acquisition=new ActivityAcquisition(); var info=new AcquisitionInfo();
    var raw=acquisition.read(info,{}); Test.assert(raw["completed_laps"]==null);
    acquisition.laps.onStart(); info.startTime=new Time.Moment(100);
    info.timerState=Activity.TIMER_STATE_ON;
    acquisition.read(info,{});
    info.altitude=3; info.elapsedDistance=30; info.elapsedTime=1000; info.timerTime=1000;
    acquisition.read(info,{});
    info.altitude=6;info.elapsedDistance=60;info.elapsedTime=2000;info.timerTime=2000;
    raw=acquisition.read(info,{}); Test.assertEqual(10.0d,raw["grade"]);
    acquisition.laps.onLap(); raw=acquisition.read(info,{}); Test.assertEqual(1,raw["completed_laps"]);
    var s=new DisplaySettings();
    s.apply({"a1"=>15,"a2"=>15,"a3"=>24,"a4"=>24,"a5"=>20,"a6"=>20,
        "a1_bg"=>1,"a2_bg"=>1,"a5_bg"=>1,"a6_bg"=>1});
    var cache=new TemperatureCache(); cache.receive([2,0,1000,"edge-native-v2"],1000,0,true);
    raw["temperature"]=cache.value(1000,0);
    var e=new SnapshotEngine(); var snap=e.prepareWithPreferences(raw,s,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assertEqual(snap[:values][0][ValueRecord.TEXT],snap[:values][1][ValueRecord.TEXT]);
    Test.assertEqual("red",snap[:values][0][ValueRecord.BAND]);
    Test.assertEqual("1",snap[:values][2][ValueRecord.TEXT]); Test.assertEqual("1",snap[:values][3][ValueRecord.TEXT]);
    Test.assertEqual("cyan",snap[:values][4][ValueRecord.BAND]); Test.assertEqual("cyan",snap[:values][5][ValueRecord.BAND]);
    Test.assertEqual("0.0",snap[:values][4][ValueRecord.TEXT]);
    snap=e.prepareWithPreferences(raw,s,true,new PresentationDevice(true,true,false),new PresentationClock());
    Test.assertEqual("32.0",snap[:values][4][ValueRecord.TEXT]); Test.assertEqual("cyan",snap[:values][4][ValueRecord.BAND]);
    raw["temperature"]=cache.value(1361,361000);
    snap=e.prepareWithPreferences(raw,s,true,new PresentationDevice(true,true,false),new PresentationClock());
    Test.assert(snap[:values][4][ValueRecord.TEXT]==null);
    Test.assertEqual("light_gray",snap[:values][4][ValueRecord.BAND]);
    info.timerState=Activity.TIMER_STATE_PAUSED;
    raw=acquisition.read(info,{}); Test.assert(raw["grade"]==null);
    Test.assertEqual(1,raw["completed_laps"]);
    var headingSettings=new DisplaySettings(); headingSettings.apply({"a1"=>22});
    var heading=e.prepareWithPreferences({"heading"=>Math.PI/4.0},headingSettings,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assertEqual("NE",heading[:values][0][ValueRecord.EXPANDEDUNIT]);
    var dc=new PresentationDrawDc(246,470); var renderer=new FieldRenderer();
    renderer.prepare(heading); renderer.layout(dc,headingSettings); renderer.prepare(heading);
    Test.assertEqual("NE",renderer.visibleUnit(dc,{Cell.W=>1000},heading[:values][0],10));
    Test.assertEqual("",renderer.visibleUnit(dc,{Cell.W=>10},heading[:values][0],10));
    return true;
}

(:test)
function datafieldCallbackIsolation(logger) {
    var field=new StrukturField(); var info=new AcquisitionInfo();
    field.processActivity(info); field.onTimerStart();
    info.startTime=new Time.Moment(100); info.timerState=Activity.TIMER_STATE_ON;
    field.processActivity(info); field.onTimerLap(); field.onTimerLap();
    Test.assertEqual(2,field._snapshot[:raw]["completed_laps"]);
    field.onTimerPause(); field.onTimerStop(); field.onTimerResume(); field.onTimerStart();
    Test.assertEqual(2,field._acquisition.laps.value());
    field.onHide(); field.onShow(); field.reloadSettings();
    Test.assertEqual(2,field._acquisition.laps.value());
    field.onTimerReset(); field.onTimerLap();
    Test.assert(field._acquisition.laps.value()==null);
    field.onTimerStart(); Test.assertEqual(0,field._acquisition.laps.value());
    var attached=new StrukturField(); attached.onTimerStart(); attached.processActivity(info); attached.onTimerLap();
    Test.assert(attached._acquisition.laps.value()==null);
    return true;
}

(:test)
function acquisitionInvalidInputs(logger) {
    var app=new StrukturApp(); app.onStart(null);
    Test.assert(app._temperature==null && app._view==null); // startup must be safe in background too
    app.onStop(null);
    var g=new GradeEstimator();
    var invalid=[null,"0",true,Math.acos(2.0)];
    for(var i=0;i<invalid.size();i+=1) {
        g.push(0,0,0,true,100);
        Test.assert(g.push(invalid[i],10,1000,true,100)==null);
        Test.assertEqual(0,g.sampleCount());
        Test.assert(g.push(0,invalid[i],1000,true,100)==null);
        Test.assert(g.push(0,10,invalid[i],true,100)==null);
        var c=new TemperatureCache();
        Test.assertEqual(false,c.receive([2,invalid[i],1000,"edge-native-v2"],1000,0,true));
        Test.assert(c.value(1000,0)==null);
    }
    Test.assert(g.push(0,-1,1000,true,100)==null);
    Test.assert(g.push(0,10,-1,true,100)==null);
    Test.assert(g.push(0,10,1000,null,100)==null);
    var packetCache=new TemperatureCache();
    Test.assertEqual(false,packetCache.receive([2.0,0,1000,"edge-native-v2"],1000,0,true));
    Test.assertEqual(false,packetCache.receive([2,0,1000.0,"edge-native-v2"],1000,0,true));
    return true;
}

(:testSupport)
function fixedSlopePrecision(logger) {
    var cases=[[0,"0.0"],[-0.04,"0.0"],[2.01,"2.0"],[5.1,"5.1"],[-5.15,"-5.2"],
        [9.95,"10.0"],[99.96,"100.0"],[100,"100.0"],[-100,"-100.0"]];
    var banks=new FieldSetsSettings();var engine=new SnapshotEngine();var clock=new PresentationClock();
    var device=new PresentationDevice(false,true,false);
    for(var enlarged=0;enlarged<=2;enlarged+=1) {
        banks.apply({"a_big"=>enlarged,"b_big"=>enlarged,
            "a1"=>"grade","a2"=>"grade","a1_bg"=>1,
            "b1"=>"grade","b2"=>"grade","b1_bg"=>2});
        for(var bank=0;bank<2;bank+=1) {
            var settings=bank==0?banks.primary:banks.secondary;
            for(var i=0;i<cases.size();i+=1) {
                var frame=engine.prepareWithPreferences({"grade"=>cases[i][0]},settings,true,device,clock);
                Test.assertEqual(cases[i][1],frame[:values][0][ValueRecord.TEXT]);
                Test.assertEqual(cases[i][1],frame[:values][1][ValueRecord.TEXT]);
                Test.assertEqual(Effects.gradeBand(cases[i][0]),frame[:values][0][ValueRecord.BAND]);
            }
        }
    }
    return true;
}
