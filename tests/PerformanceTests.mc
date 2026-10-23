using Toybox.Test;
using Toybox.System;

(:test)
function snapshotCacheInvalidation(logger) {
    var e=new SnapshotEngine();var s=new DisplaySettings();var d=new PresentationDevice(false,true,false);var clock=new PresentationClock();
    var raw={"current_speed"=>10,"distance"=>10000,"elevation"=>100,"total_ascent"=>200};
    var first=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual(10,e.descriptorBuilds);Test.assertEqual(10,e.headerBuilds);Test.assertEqual(10,e.formatBuilds);
    e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual(10,e.descriptorBuilds);Test.assertEqual(10,e.headerBuilds);Test.assertEqual(10,e.formatBuilds);
    raw["current_speed"]=11;var changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("36.0",first[:values][0][ValueRecord.TEXT]);Test.assertEqual("39.6",changed[:values][0][ValueRecord.TEXT]);
    Test.assertEqual(11,e.formatBuilds);Test.assertEqual(10,e.headerBuilds);
    d.distanceUnits=System.UNIT_STATUTE;e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual(12,e.headerBuilds);Test.assertEqual(13,e.formatBuilds);
    Test.assertEqual(10,e.descriptorBuilds);
    d.is24Hour=false;clock.hour=0;changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("time | am",changed[:values][3][ValueRecord.LABEL]);Test.assertEqual("12:05",changed[:values][3][ValueRecord.TEXT]);
    clock.hour=13;changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("time | pm",changed[:values][3][ValueRecord.LABEL]);
    s.apply({"a_hideu"=>false,"a1"=>"distance"});
    changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("distance | mi",changed[:values][0][ValueRecord.LABEL]);Test.assertEqual(11,e.descriptorBuilds);
    // Unknown identifiers and unavailable initial clock state must invalidate safely.
    s.apply({"a1"=>"future-metric"});changed=e.prepareWithPreferences({},s,false,d,null);
    Test.assertEqual("field",changed[:values][0][ValueRecord.LABEL]);Test.assert(changed[:values][0][ValueRecord.TEXT]==null);
    Test.assertEqual("time",changed[:values][3][ValueRecord.LABEL]);Test.assert(changed[:values][3][ValueRecord.TEXT]==null);
    verifyLiveDevicePreferences();
    verifySnapshotSlotIsolation();
    verifyPresentationRecordReuse();
    return true;
}

// A retained snapshot must survive duplicate-slot reassignment and cache eviction.
(:testSupport)
function verifySnapshotSlotIsolation() {
    var e=new SnapshotEngine();var s=new DisplaySettings();var d=new PresentationDevice(false,true,false);
    s.apply({"a1"=>"current_speed","a2"=>"current_speed"});
    var raw={"current_speed"=>10,"distance"=>20000};
    var first=e.prepareWithPreferences(raw,s,true,d,null);
    raw["current_speed"]=11;
    s.apply({"a1"=>"distance","a2"=>"current_speed"});
    var next=e.prepareWithPreferences(raw,s,true,d,null);
    Test.assertEqual("20.0",next[:values][0][ValueRecord.TEXT]);Test.assertEqual("39.6",next[:values][1][ValueRecord.TEXT]);
    d.distanceUnits=System.UNIT_STATUTE;
    next=e.prepareWithPreferences(raw,s,true,d,null);
    Test.assertEqual("12.4",next[:values][0][ValueRecord.TEXT]);Test.assertEqual("24.6",next[:values][1][ValueRecord.TEXT]);
    for(var i=0;i<64;i+=1) {
        s.apply({"a1"=>Catalog.IDS[i%Catalog.IDS.size()],"a2"=>"current_speed"});
        e.prepareWithPreferences(raw,s,true,d,null);
        Test.assertEqual(10,e._descriptors.size());
    }
    Test.assertEqual("speed",first[:values][0][ValueRecord.LABEL]);Test.assertEqual("speed",first[:values][1][ValueRecord.LABEL]);
    Test.assertEqual("36.0",first[:values][0][ValueRecord.TEXT]);Test.assertEqual("36.0",first[:values][1][ValueRecord.TEXT]);
}

(:testSupport)
class DrawOnlyRenderer extends FieldRenderer {
    var locked=false;
    function initialize() { FieldRenderer.initialize(); }
    function metric(size,labelRole) { Test.assert(!locked);return FieldRenderer.metric(size,labelRole); }
    function fitRun(cell,value,labelSize,text,unit) { Test.assert(!locked);return FieldRenderer.fitRun(cell,value,labelSize,text,unit); }
    function prepareGeometry() { Test.assert(!locked);FieldRenderer.prepareGeometry(); }
    function color(name) { Test.assert(!locked);return FieldRenderer.color(name); }
}

(:testSupport)
class RendererCacheScenario {
    var settings;var raw;var engine;var renderer;var snapshot;var dc;var props;
    var fits;var geometry;var polygons;var packets;
    function initialize() {
        props={"a1"=>"current_speed","a2"=>"grade","a2_bg"=>2};
        settings=new DisplaySettings();settings.apply(props);engine=new SnapshotEngine();renderer=new DrawOnlyRenderer();
        raw={"current_speed"=>10,"grade"=>3.4};sample();
        dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());renderer.layout(dc,settings);
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._cells.size());
        Test.assert(renderer._runs[0] instanceof FittedRun);Test.assert(renderer._packets[0] instanceof PreparedCell);
        Test.assertEqual(2*DeviceProfile.DESIGN_ROWS,renderer._separators.size());
        Test.assert(renderer._separators[0][0]==renderer._separators[2][0]);
        Test.assert(renderer._separators[1][0]==renderer._separators[3][0]);
        Test.assertEqual(96,renderer._separators[0][0].size());
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;polygons=renderer.polygonBuilds;packets=renderer.packetBuilds;
    }
    function sample() { snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,false),new PresentationClock());renderer.prepare(snapshot); }
    function run() {
        var checks=renderer.recordChecks;var passes=renderer.geometryPasses;
        sample();Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);
        Test.assertEqual(checks,renderer.recordChecks);Test.assertEqual(passes,renderer.geometryPasses);
        raw["current_speed"]=10.001;sample(); // Different raw reading, same displayed 36.0.
        Test.assertEqual(checks,renderer.recordChecks);Test.assertEqual(passes,renderer.geometryPasses);
        System.println("CORE_CACHE stable geometry="+renderer.geometryBuilds+" fits="+renderer.fitCount+" polygons="+renderer.polygonBuilds+" packets="+renderer.packetBuilds+" expected_packets="+packets);
        Test.assertEqual(polygons,renderer.polygonBuilds);Test.assertEqual(packets,renderer.packetBuilds);
        var headers=renderer.headerMeasures;
        raw["current_speed"]=11;sample();Test.assertEqual(fits+1,renderer.fitCount);
        Test.assertEqual(headers,renderer.headerMeasures);
        Test.assertEqual(checks+1,renderer.recordChecks);Test.assertEqual(passes+1,renderer.geometryPasses);
        Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(polygons,renderer.polygonBuilds);Test.assertEqual(packets+1,renderer.packetBuilds);
        fits=renderer.fitCount;packets=renderer.packetBuilds;
        props["a_theme"]=2;settings.apply(props);sample();
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(polygons,renderer.polygonBuilds);
        Test.assert(renderer.packetBuilds>packets);
        raw["grade"]=null;sample();Test.assertEqual("dark_gray",snapshot[:values][1][ValueRecord.BAND]);
        Test.assertEqual(0,renderer._runs[1].labelBand);Test.assert(renderer._polygons[1]==null);
        Test.assertEqual(0x333333,renderer._packets[1].background);
        for(var i=0;i<snapshot[:values].size();i+=1) { dc.paintEffects.add(snapshot[:values][i][ValueRecord.BAND]!=null);dc.wholeEffects.add(snapshot[:values][i][ValueRecord.COVERAGE]==2); }
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;packets=renderer.packetBuilds;
        renderer.locked=true;renderer.draw(dc,snapshot,settings);renderer.locked=false;
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(packets,renderer.packetBuilds);
        Test.assertEqual(renderer._cells.size(),dc.records.size());
        var fills=0;
        for(var cell=0;cell<renderer._packets.size();cell+=1) {
            var packet=renderer._packets[cell];
            if(packet.fillBase) { fills+=1; }
            if(packet.labelEffect) { fills+=1; }
            Test.assertEqual(packet.background!=dc.clearBackground,packet.fillBase);
        }
        Test.assertEqual(fills,dc.rectangleCalls);
        props["a_big"]=1;props["a_align"]=0;settings.apply(props);renderer.configure(settings);sample();
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,1),renderer._cells.size());
        Test.assert(renderer.geometryBuilds>geometry);Test.assert(renderer._cells[0][Cell.ENLARGED]);
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;packets=renderer.packetBuilds;
        passes=renderer.geometryPasses;checks=renderer.recordChecks;
        raw["temperature"]=20;sample(); // Slot 10 is hidden in every one-enlarged native layout.
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(packets,renderer.packetBuilds);
        Test.assertEqual(passes,renderer.geometryPasses);
        renderer.discardPresentation();Test.assertEqual(0,renderer._runs.size());Test.assertEqual(0,renderer._packets.size());Test.assertEqual(0,renderer._headerFits.size());
        renderer.prepare(snapshot);renderer.layout(dc,settings);Test.assert(renderer._runs.size()>0 && renderer._packets.size()>0);
    }
}

(:test)
function rendererCacheAndDrawPurity(logger) {
    new RendererCacheScenario().run();new FieldDrawScenario().run();
    return true;
}

(:test)
function optionalRuntimeQueries(logger) {
    verifyHiddenTemperatureAge();
    var settings=new DisplaySettings();Test.assert(!settings.usesBattery);
    Test.assert(settings.usesClock);
    settings.apply({"a10"=>"battery"});Test.assert(settings.usesBattery);
    settings.apply({});Test.assert(!settings.usesBattery);
    settings.apply({"a4"=>"battery"});Test.assert(!settings.usesClock && settings.usesBattery);
    settings.apply({"a4"=>"battery","a10"=>"time_of_day"});Test.assert(settings.usesClock);
    Test.assert(ActivityReader.readWithBattery(new AcquisitionInfo(),false)["battery"]==null);
    Test.assert(!RuntimeMetrics.enabled);
    var maximum=RuntimeMetrics.maxUsedBytes;var deadline=RuntimeMetrics.deadlineMisses;
    var field=new StrukturField();field.processActivity(new AcquisitionInfo());
    Test.assertEqual(maximum,RuntimeMetrics.maxUsedBytes);Test.assertEqual(deadline,RuntimeMetrics.deadlineMisses);
    var retained=field._snapshot;var raw=retained[:raw];
    field.processActivity(new AcquisitionInfo());
    Test.assert(retained[:raw]==raw && raw!=null);Test.assert(field._snapshot[:raw]!=raw);
    field.onTimerReset();Test.assert(retained[:raw]==raw);Test.assertEqual(10,retained[:values].size());
    return true;
}

(:testSupport)
function verifyPresentationRecordReuse() {
    var settings=new DisplaySettings();settings.apply({"a1"=>"current_heart_rate","a2"=>"current_heart_rate",
        "a1_bg"=>1,"a2_bg"=>1,"a3"=>"heart_rate_zone","a4"=>"current_heart_rate"});
    var engine=new SnapshotEngine();engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
    var first=engine.compute({"current_heart_rate"=>130},settings);
    Test.assertEqual(2,engine.zoneBuilds); // One heart classification + one unavailable power classification.
    Test.assertEqual("2",first[:values][2][ValueRecord.TEXT]);Test.assertEqual("green",first[:values][0][ValueRecord.BAND]);
    var builds=engine.recordBuilds;var effects=engine.effectBuilds;
    var next=engine.compute({"current_heart_rate"=>130},settings);
    Test.assertEqual(builds,engine.recordBuilds);Test.assertEqual(effects,engine.effectBuilds);Test.assertEqual(2,engine.zoneBuilds);
    Test.assert(first[:values][0]==next[:values][0]);
    next=engine.compute({"current_heart_rate"=>131},settings);
    Test.assertEqual(3,engine.zoneBuilds);Test.assertEqual("yellow",next[:values][1][ValueRecord.BAND]);
    Test.assertEqual("130",first[:values][0][ValueRecord.TEXT]);Test.assertEqual("green",first[:values][1][ValueRecord.BAND]);
    engine._hrZones=ZoneMetadata.heart([90,140,150,160,170,190]);
    next=engine.compute({"current_heart_rate"=>131},settings);
    Test.assertEqual("blue",next[:values][0][ValueRecord.BAND]);Test.assertEqual(4,engine.zoneBuilds);
    next=engine.compute({"current_heart_rate"=>null},settings);
    Test.assert(next[:values][0][ValueRecord.TEXT]==null);
    settings.apply({});
    first=engine.prepareWithPreferences({"current_speed"=>10},settings,true,new PresentationDevice(false,true,false),null);
    builds=engine.recordBuilds;
    next=engine.prepareWithPreferences({"current_speed"=>10.001},settings,true,new PresentationDevice(false,true,false),null);
    Test.assertEqual("36.0",next[:values][0][ValueRecord.TEXT]);Test.assertEqual(builds,engine.recordBuilds);
    Test.assert(first[:values][0]==next[:values][0]);
    Test.assert(ZoneMetadata.heart([90,90,130,150,170,190])==null);
    Test.assert(ZoneMetadata.classifyValidated(130,null)==null);
}

(:testSupport)
class FieldDrawScenario {
    var field;var renderer;var dc;var layouts;var fits;var headers;var loads;
    function initialize() {
        field=new StrukturField();renderer=new DrawOnlyRenderer();
        // Isolate draw-purity coverage from persistent simulator app properties.
        field._settings=new DisplaySettings();field._snapshot=field._engine.initial(field._settings);
        field._renderer=renderer;renderer.prepare(field._snapshot);
        dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    }
    function run() {
        // The recording fixture exercises the real inherited callback without Dc static typing.
        deliverFieldCallback(field,:onUpdate,dc);
        layouts=renderer.layoutCount;fits=renderer.fitCount;headers=renderer.headerMeasures;loads=renderer.fontLoads;
        deliverFieldCallback(field,:onLayout,dc);Test.assertEqual(layouts,renderer.layoutCount);
        renderer.locked=true;deliverFieldCallback(field,:onUpdate,dc);deliverFieldCallback(field,:onUpdate,dc);renderer.locked=false;
        Test.assertEqual(layouts,renderer.layoutCount);Test.assertEqual(fits,renderer.fitCount);
        Test.assertEqual(headers,renderer.headerMeasures);Test.assertEqual(loads,renderer.fontLoads);
        Test.assertEqual(0,dc.rectangleCalls);
    }
}

(:testSupport)
function deliverFieldCallback(target,name,dc) { target.method(name).invoke(dc); }

// Exercise the production prepare entry on consecutive samples without modifying device preferences.
(:testSupport)
class LivePreferenceEngine extends SnapshotEngine {
    var selected;var reads=0;
    function initialize() { SnapshotEngine.initialize();selected=new PresentationDevice(false,true,false); }
    function preferences(device) { reads+=1;return SnapshotEngine.preferences(selected); }
}

(:testSupport)
class LivePreferenceField extends StrukturField {
    function initialize() { StrukturField.initialize();_engine=new LivePreferenceEngine();_snapshot=_engine.initial(_settings); }
    function temperatureReading() { return 20; }
}

(:testSupport)
class PreferenceActivityInfo extends AcquisitionInfo { var currentSpeed=10; }

(:testSupport)
function verifyLiveDevicePreferences() {
    var field=new LivePreferenceField();
    field.applyFieldSets(secondSetConfiguration({"a1"=>"current_speed","a2"=>"elevation","a3"=>"temperature","a4"=>"time_of_day","a_hideu"=>false}));
    var engine=field._engine;engine.reads=0;
    var info=new PreferenceActivityInfo();info.altitude=100;
    field.processActivity(info);var first=field._snapshot;
    Test.assertEqual(1,engine.reads);Test.assertEqual("speed | km/h",first[:values][0][ValueRecord.LABEL]);
    engine.selected.distanceUnits=System.UNIT_STATUTE;
    field.processActivity(info);var next=field._snapshot;
    Test.assertEqual(2,engine.reads);Test.assertEqual("speed | mph",next[:values][0][ValueRecord.LABEL]);
    Test.assertEqual(Formatting.floating(Formatting.speed(10,true)),next[:values][0][ValueRecord.TEXT]);
    Test.assertEqual("elevation | m",next[:values][1][ValueRecord.LABEL]);
    engine.selected.elevationUnits=System.UNIT_STATUTE;engine.selected.temperatureUnits=System.UNIT_STATUTE;
    engine.selected.is24Hour=false;engine.selected.isNightModeEnabled=true;
    field.processActivity(info);next=field._snapshot;
    Test.assertEqual(3,engine.reads);Test.assertEqual("elevation | ft",next[:values][1][ValueRecord.LABEL]);
    Test.assertEqual(Formatting.fixed(Formatting.temperature(20,true),1),next[:values][2][ValueRecord.TEXT]);
    Test.assert(!engine._descriptors[3][SnapshotDescriptor.CLOCK24]);Test.assert(next[:night]);
    engine.selected.distanceUnits=System.UNIT_METRIC;engine.selected.elevationUnits=System.UNIT_METRIC;
    engine.selected.temperatureUnits=System.UNIT_METRIC;engine.selected.is24Hour=true;engine.selected.isNightModeEnabled=false;
    field.processActivity(info);next=field._snapshot;
    Test.assertEqual(4,engine.reads);Test.assertEqual("speed | km/h",next[:values][0][ValueRecord.LABEL]);
    Test.assertEqual("elevation | m",next[:values][1][ValueRecord.LABEL]);Test.assert(!next[:night]);
    Test.assert(engine._descriptors[3][SnapshotDescriptor.CLOCK24]);
    Test.assertEqual("speed | km/h",first[:values][0][ValueRecord.LABEL]);
}

// Keep real app/cache dispatch, substituting only time at the cache boundary.
(:testSupport)
class ObservedTemperatureCache extends TemperatureCache {
    var wall=1000;var mono=1000000;var ageReads=0;
    function initialize() { TemperatureCache.initialize(); }
    function value(actualWall,actualMono) { ageReads+=1;return TemperatureCache.value(wall,mono); }
    function seed(temperature) {
        Test.assert(receive([TemperatureSource.PROTOCOL,temperature,wall,TemperatureSource.PATH],wall,mono,true));
    }
}

(:testSupport)
function verifyHiddenTemperatureAge() {
    var app=Toybox.Application.getApp();var original=app._temperature;
    var cache=new ObservedTemperatureCache();app._temperature=cache;
    try {
        cache.seed(25);
        var field=new StrukturField();var props={"trig"=>3};
        for(var i=1;i<=10;i+=1) { props["a"+i]="current_speed";props["b"+i]="current_speed"; }
        props["b1"]="temperature";
        field.applyFieldSets(secondSetConfiguration(props));
        var reads=cache.ageReads;var info=new AcquisitionInfo();
        cache.wall=1001;cache.mono=1001000;field.processActivity(info);
        Test.assertEqual(reads+1,cache.ageReads);Test.assertEqual(25,field._snapshot[:raw]["temperature"]);
        cache.wall=1361;cache.mono=1361000;field.processActivity(info);
        Test.assertEqual(reads+2,cache.ageReads);Test.assert(!cache.hasValue());
        Test.assert(field._snapshot[:raw]["temperature"]==null);
        field.processActivity(info);Test.assertEqual(reads+2,cache.ageReads); // Empty cache skips age/clock work.
        field.handleLap(null,true);Test.assert(field._fieldSets.second);
        Test.assert(field._snapshot[:values][0][ValueRecord.TEXT]==null);
        field.handleLap(null,true);Test.assert(!field._fieldSets.second);
        cache.wall=1500;cache.mono=1500000;cache.seed(0);field.processActivity(info);
        Test.assertEqual(0,field._snapshot[:raw]["temperature"]);
        cache.wall=1499;cache.mono=1501000;field.processActivity(info); // Clock rollback while unassigned.
        Test.assert(!cache.hasValue());Test.assert(field._snapshot[:raw]["temperature"]==null);
    } finally { app._temperature=original; }
}
