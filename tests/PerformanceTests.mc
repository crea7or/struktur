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
    Test.assertEqual("36.0",first[:values][0][:text]);Test.assertEqual("39.6",changed[:values][0][:text]);
    Test.assertEqual(11,e.formatBuilds);Test.assertEqual(10,e.headerBuilds);
    d.distanceUnits=System.UNIT_STATUTE;e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual(12,e.headerBuilds);Test.assertEqual(13,e.formatBuilds);
    Test.assertEqual(10,e.descriptorBuilds);
    d.is24Hour=false;clock.hour=0;changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("time | am",changed[:values][3][:label]);Test.assertEqual("12:05",changed[:values][3][:text]);
    clock.hour=13;changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("time | pm",changed[:values][3][:label]);
    s.apply({"hide_value_units"=>false,"slot_1_value"=>"distance"});
    changed=e.prepareWithPreferences(raw,s,true,d,clock);
    Test.assertEqual("distance | mi",changed[:values][0][:label]);Test.assertEqual(11,e.descriptorBuilds);
    // Unknown identifiers and unavailable initial clock state must invalidate safely.
    s.apply({"slot_1_value"=>"future-metric"});changed=e.prepareWithPreferences({},s,false,d,null);
    Test.assertEqual("field",changed[:values][0][:label]);Test.assert(changed[:values][0][:text]==null);
    Test.assertEqual("time",changed[:values][3][:label]);Test.assert(changed[:values][3][:text]==null);
    verifySnapshotSlotIsolation();
    return true;
}

// A retained snapshot must survive duplicate-slot reassignment and cache eviction.
(:testSupport)
function verifySnapshotSlotIsolation() {
    var e=new SnapshotEngine();var s=new DisplaySettings();var d=new PresentationDevice(false,true,false);
    s.apply({"slot_1_value"=>"current_speed","slot_2_value"=>"current_speed"});
    var raw={"current_speed"=>10,"distance"=>20000};
    var first=e.prepareWithPreferences(raw,s,true,d,null);
    raw["current_speed"]=11;
    s.apply({"slot_1_value"=>"distance","slot_2_value"=>"current_speed"});
    var next=e.prepareWithPreferences(raw,s,true,d,null);
    Test.assertEqual("20.00",next[:values][0][:text]);Test.assertEqual("39.6",next[:values][1][:text]);
    d.distanceUnits=System.UNIT_STATUTE;
    next=e.prepareWithPreferences(raw,s,true,d,null);
    Test.assertEqual("12.43",next[:values][0][:text]);Test.assertEqual("24.6",next[:values][1][:text]);
    for(var i=0;i<64;i+=1) {
        s.apply({"slot_1_value"=>Catalog.IDS[i%Catalog.IDS.size()],"slot_2_value"=>"current_speed"});
        e.prepareWithPreferences(raw,s,true,d,null);
        Test.assertEqual(10,e._descriptors.size());
    }
    Test.assertEqual("speed",first[:values][0][:label]);Test.assertEqual("speed",first[:values][1][:label]);
    Test.assertEqual("36.0",first[:values][0][:text]);Test.assertEqual("36.0",first[:values][1][:text]);
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
        props={"slot_1_value"=>"current_speed","slot_2_value"=>"grade","slot_2_background_effects"=>true};
        settings=new DisplaySettings();settings.apply(props);engine=new SnapshotEngine();renderer=new DrawOnlyRenderer();
        raw={"current_speed"=>10,"grade"=>3.4};sample();
        dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());renderer.layout(dc,settings);
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._cells.size());
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;polygons=renderer.polygonBuilds;packets=renderer.packetBuilds;
    }
    function sample() { snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,false),new PresentationClock());renderer.prepare(snapshot); }
    function run() {
        sample();Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);
        System.println("CORE_CACHE stable geometry="+renderer.geometryBuilds+" fits="+renderer.fitCount+" polygons="+renderer.polygonBuilds+" packets="+renderer.packetBuilds+" expected_packets="+packets);
        Test.assertEqual(polygons,renderer.polygonBuilds);Test.assertEqual(packets,renderer.packetBuilds);
        raw["current_speed"]=11;sample();Test.assertEqual(fits+1,renderer.fitCount);
        Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(polygons,renderer.polygonBuilds);Test.assertEqual(packets+1,renderer.packetBuilds);
        fits=renderer.fitCount;packets=renderer.packetBuilds;
        props["theme_mode"]=2;settings.apply(props);sample();
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(polygons,renderer.polygonBuilds);
        Test.assert(renderer.packetBuilds>packets);
        raw["grade"]=null;sample();Test.assertEqual("dark_gray",snapshot[:values][1][:band]);
        Test.assertEqual(renderer._labelBandHeight,renderer._runs[1][:labelBand]);Test.assert(renderer._polygons[1]==null);
        for(var i=0;i<snapshot[:values].size();i+=1) { dc.paintEffects.add(snapshot[:values][i][:band]!=null); }
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;packets=renderer.packetBuilds;
        renderer.locked=true;renderer.draw(dc,snapshot,settings);renderer.locked=false;
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(packets,renderer.packetBuilds);
        Test.assertEqual(renderer._cells.size(),dc.records.size());
        props["enlarged_field_count"]=1;props["alignment"]=0;settings.apply(props);renderer.configure(settings);sample();
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,1),renderer._cells.size());
        Test.assert(renderer.geometryBuilds>geometry);Test.assert(renderer._cells[0][:enlarged]);
        fits=renderer.fitCount;geometry=renderer.geometryBuilds;packets=renderer.packetBuilds;
        raw["temperature"]=20;sample(); // Slot 10 is hidden in every one-enlarged native layout.
        Test.assertEqual(fits,renderer.fitCount);Test.assertEqual(geometry,renderer.geometryBuilds);Test.assertEqual(packets,renderer.packetBuilds);
    }
}

(:test)
function rendererCacheAndDrawPurity(logger) { new RendererCacheScenario().run();return true; }

(:test)
function optionalRuntimeQueries(logger) {
    var settings=new DisplaySettings();Test.assert(!settings.usesBattery);
    Test.assert(settings.usesClock);
    settings.apply({"slot_10_value"=>"battery"});Test.assert(settings.usesBattery);
    settings.apply({});Test.assert(!settings.usesBattery);
    settings.apply({"slot_4_value"=>"battery"});Test.assert(!settings.usesClock && settings.usesBattery);
    settings.apply({"slot_4_value"=>"battery","slot_10_value"=>"time_of_day"});Test.assert(settings.usesClock);
    Test.assert(ActivityReader.readWithBattery(new AcquisitionInfo(),false)["battery"]==null);
    Test.assert(!RuntimeMetrics.enabled);
    var maximum=RuntimeMetrics.maxUsedBytes;var deadline=RuntimeMetrics.deadlineMisses;
    var field=new StrukturField();field.processActivity(new AcquisitionInfo());
    Test.assertEqual(maximum,RuntimeMetrics.maxUsedBytes);Test.assertEqual(deadline,RuntimeMetrics.deadlineMisses);
    return true;
}
