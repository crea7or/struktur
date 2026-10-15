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
        _cellIndex+=1; _drawCount=0;
        _record={:x=>x,:y=>y,:w=>w,:h=>h,:background=>null,:texts=>[],:halos=>[],:rectangles=>[],:polygons=>[]};records.add(_record);
    }
    function clearClip() {}
    function fillRectangle(x,y,w,h) {
        if(_record[:background]==null) { _record[:background]=_color; }
        _record[:rectangles].add([x,y,w,h]);
    }
    function fillPolygon(points) { _record[:polygons].add({:color=>_color,:points=>points}); }
    function drawLine(x1,y1,x2,y2) { lines.add(_color); }
    function drawText(x,y,font,text,flags) {
        if(_record!=null) {
            Test.assertEqual(Graphics.COLOR_TRANSPARENT,_background);
            var count=_cellIndex<paintEffects.size() && paintEffects[_cellIndex]?9:1;
            var logical=_drawCount/count;
            var height=Graphics.getFontHeight(font);
            var metrics=logical==1?FontMetrics.numeric(height):FontMetrics.label(height);
            var ink=FontMetrics.bounds(text,metrics);
            var drawing={:inkTop=>y+ink[0],:inkBottom=>y+ink[1],:x=>x,:y=>y,:width=>getTextWidthInPixels(text,font),:height=>height,:text=>text,:color=>_color,:group=>logical,:flags=>flags};
            if(_drawCount%count==count-1) { _record[:texts].add(drawing); }
            else { _record[:halos].add(drawing); }
            _drawCount+=1;
        }
    }
}

// Smaller helpers retain the same matrix and assertions on constrained VM stacks.
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
        var expectedBackground=value[:band]==null || value[:angle]!=null?(night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE):renderer.color(value[:band]);
        Test.assertEqual(expectedBackground,record[:background]);
        Test.assertEqual(1,record[:rectangles].size()); // No opaque text panels.
        Test.assertEqual(record[:x],record[:rectangles][0][0]);
        Test.assertEqual(record[:y],record[:rectangles][0][1]);
        Test.assertEqual(record[:w],record[:rectangles][0][2]);
        Test.assertEqual(record[:h],record[:rectangles][0][3]);
        if(value[:angle]!=null) {
            Test.assertEqual(1,record[:polygons].size());
            Test.assertEqual(renderer.color(value[:band]),record[:polygons][0][:color]);
        } else { Test.assertEqual(0,record[:polygons].size()); }
        var texts=record[:texts];
        Test.assertEqual(renderer._runs[i][:unit].length()>0?3:2,texts.size());
        Test.assertEqual(value[:label],texts[0][:text]);
        Test.assertEqual(renderer._runs[i][:text],texts[1][:text]);
        if(value[:angle]==null) { Test.assert(texts[0][:color]!=expectedBackground && texts[1][:color]!=expectedBackground); }
        verifyGlyphHalo(record,radius);
        var center=record[:y]+renderer._labelHeight+(record[:h]-renderer._labelHeight)/2.0;
        Test.assert(((texts[1][:inkTop]+texts[1][:inkBottom])/2.0-center).abs()<=1);
        Test.assert(texts[1][:inkTop]-radius>=texts[0][:inkBottom]+radius+2);
        Test.assert(texts[1][:inkTop]-radius>=record[:y]+renderer._labelHeight);
        Test.assert(texts[1][:inkBottom]+radius<=record[:y]+record[:h]);
        var total=texts[1][:width];
        if(texts.size()==3) {
            Test.assertEqual(renderer._runs[i][:unit],texts[2][:text]);
            Test.assertEqual(texts[1][:x]+texts[1][:width]+2,texts[2][:x]);
            Test.assertEqual(texts[1][:inkTop],texts[2][:inkTop]);
            total+=texts[2][:width]+2;
        }
        Test.assertEqual(align==1?record[:x]+record[:w]-4-radius-total:record[:x]+(record[:w]-total)/2,texts[1][:x]);
        Test.assert(texts[1][:x]-radius>=record[:x]+4 && texts[1][:x]+total+radius<=record[:x]+record[:w]-4);
    }
}

(:testSupport)
function verifyGlyphHalo(record,radius) {
    Test.assertEqual(radius==1?record[:texts].size()*8:0,record[:halos].size());
    for(var group=0;group<record[:texts].size() && radius==1;group+=1) {
        var main=record[:texts][group]; var offsets=[];
        for(var i=0;i<record[:halos].size();i+=1) {
            var halo=record[:halos][i]; if(halo[:group]!=group) { continue; }
            Test.assertEqual(main[:text],halo[:text]); Test.assertEqual(main[:height],halo[:height]);
            Test.assertEqual(main[:flags],halo[:flags]);
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
function verifyColoredFields() {
    var ids=["grade","current_power","power_3s","average_power","current_heart_rate","heart_rate_3s","average_heart_rate","temperature"];
    for(var field=0;field<ids.size();field+=1) {
        for(var night=0;night<2;night+=1) {
            for(var align=0;align<2;align+=1) {
                for(var big=0;big<=2;big+=1) {
                    var settings=new DisplaySettings();settings.apply({"slot_1_value"=>ids[field],"enlarged_field_count"=>big,"alignment"=>align,
                        "theme_mode"=>night==1?2:1,"use_units_as_labels"=>false,"hide_value_units"=>false});
                    var raw={};raw[ids[field]]=10;
                    var engine=new SnapshotEngine();
                    var snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
                    // A declared valid effect fixture; no real threshold/source claim.
                    if(field>0 && field<7) { snapshot[:values][0][:band]="green"; }
                    // A wide synthetic context isolates every colored-field drawing contract,
                    // including labels that exceed the fixed font's native regular-cell width.
                    var dc=new PresentationDrawDc(profileDrawWidth()*2,profileDrawHeight());
                    for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
                    var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.prepare(snapshot);renderer.draw(dc,snapshot,settings);
                    verifyDrawRecords(dc,renderer,snapshot,Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,big),night,1,align);
                    // Removing the effect must discard its contour and repaint the ordinary cell.
                    var ordinary=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
                    ordinary[:values][0][:band]=null;ordinary[:values][0][:angle]=null;
                    renderer.prepare(ordinary);Test.assert(!renderer.needsLayout());
                    var plain=new PresentationDrawDc(dc.getWidth(),dc.getHeight());
                    for(var p=0;p<ordinary[:values].size();p+=1) { plain.paintEffects.add(ordinary[:values][p][:band]!=null || ordinary[:values][p][:angle]!=null); }
                    renderer.draw(plain,ordinary,settings);
                    Test.assertEqual(0,plain.records[0][:halos].size());
                }
            }
        }
    }
}

(:testSupport)
function verifyWhiteTemperatureContrast() {
    var engine=new SnapshotEngine(); var clock=new PresentationClock();
    // White semantic temperature band must survive both inversion directions.
    for(var night=0;night<2;night+=1) {
        var settings=new DisplaySettings();var props={"enlarged_field_count"=>0,"theme_mode"=>night==1?2:1};
        for(var slot=1;slot<=10;slot+=1) { props["slot_"+slot.toString()+"_value"]="temperature"; }
        settings.apply(props);
        var snapshot=engine.prepareWithPreferences({"temperature"=>5},settings,true,new PresentationDevice(false,true,night==1),clock);
        var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
        for(var n=0;n<snapshot[:values].size();n+=1) { dc.paintEffects.add(snapshot[:values][n][:band]!=null || snapshot[:values][n][:angle]!=null); }
        var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.prepare(snapshot);renderer.draw(dc,snapshot,settings);
        Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,0),renderer._runs.size());
        for(var f=0;f<renderer._runs.size();f+=1) { Test.assertEqual("5.00",renderer._runs[f][:text]); }
        Test.assertEqual(Graphics.COLOR_WHITE,dc.records[0][:background]);
        Test.assertEqual(Graphics.COLOR_BLACK,dc.records[0][:texts][0][:color]);

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


// Supported native assignments exercise real drawing in all layouts/alignments.
// Other fields' narrower ranges and unavailable contexts are tested separately.
(:testSupport)
function verifyGuaranteedNormalDraw(night,big,align) {
    var settings=new DisplaySettings();
    var props={"theme_mode"=>night==1?2:1,"enlarged_field_count"=>big,"alignment"=>align,"hide_value_units"=>true};
    var ids=["current_speed","current_heart_rate","activity_timer","battery","current_power","grade"];
    for(var slot=0;slot<10;slot+=1) { props["slot_"+(slot+1).toString()+"_value"]=ids[slot%ids.size()]; }
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
