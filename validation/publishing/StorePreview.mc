using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

// Deterministic display fixtures only; excluded from the production app.
class StoreClock { var hour=13;var min=5; }
class StorePreferences {
    var distanceUnits;var elevationUnits;var temperatureUnits;
    var is24Hour=StoreConfig.CLOCK24;
    var isNightModeEnabled=false;
    function initialize() {
        distanceUnits=StoreConfig.STATUTE?System.UNIT_STATUTE:System.UNIT_METRIC;
        elevationUnits=distanceUnits;temperatureUnits=distanceUnits;
    }
}
// Observe real graphics dispatch without altering the production renderer.
class StoreDrawDc {
    var _dc;var lines=0;var vertical=0;
    function initialize(dc) { _dc=dc; }
    function getWidth() { return _dc.getWidth(); }
    function getHeight() { return _dc.getHeight(); }
    function getTextWidthInPixels(text,font) { return _dc.getTextWidthInPixels(text,font); }
    function setColor(a,b) { _dc.setColor(a,b); }
    function clear() { _dc.clear(); }
    function drawText(x,y,font,text,flags) { _dc.drawText(x,y,font,text,flags); }
    function setClip(x,y,w,h) { _dc.setClip(x,y,w,h); }
    function clearClip() { _dc.clearClip(); }
    function fillRectangle(x,y,w,h) { _dc.fillRectangle(x,y,w,h); }
    function fillPolygon(points) { _dc.fillPolygon(points); }
    function drawLine(x1,y1,x2,y2) { lines+=1;if(x1==x2) { vertical+=1; }_dc.drawLine(x1,y1,x2,y2); }
}
class StorePreviewField extends StrukturField {
    var _reported=false;
    function initialize() {
        StrukturField.initialize();
        _settings.apply(StoreConfig.settings());
        _engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
        // Never turn on the unqualified production power-zone adapter.
        _engine._powerZones=null;
        if(StoreConfig.DEFAULT) {
            if(_settings.enlarged!=0 || !_settings.hideValueUnits || !_settings.inverseEnlargedTheme || !"horizontal".equals(_settings.gridType) ||
                !"right".equals(_settings.alignment) || !"auto".equals(_settings.theme)) {
                throw new Lang.InvalidValueException("Publishing default settings mismatch");
            }
            for(var i=0;i<10;i+=1) {
                if(_settings.effects[i] || !_settings.slots[i].equals(Catalog.defaultSlots()[i])) {
                    throw new Lang.InvalidValueException("Publishing default slot mismatch");
                }
            }
        }
        refreshPresentation();
    }
    function refreshPresentation() {
        _snapshot=_engine.prepareWithPreferences(StoreConfig.raw(),_settings,true,new StorePreferences(),new StoreClock());
        _renderer.prepare(_snapshot);_layoutDirty=true;
    }
    function compute(info) {}
    function onShow() {}
    function onUpdate(dc) {
        var observed=new StoreDrawDc(dc);
        // SDK onUpdate is typed as Graphics.Dc; use the same preparation guard
        // with a forwarding observer, then invoke the production renderer.
        if(_layoutDirty || _renderer.needsLayout()) { _renderer.layout(observed,_settings);_layoutDirty=false; }
        _renderer.draw(observed,_snapshot,_settings);
        if(dc.getWidth()!=StoreConfig.WIDTH || dc.getHeight()!=StoreConfig.HEIGHT) { return; }
        if(!_settings.gridType.equals(StoreConfig.GRID_TYPE) || !_settings.alignment.equals(StoreConfig.ALIGNMENT) ||
            ("none".equals(StoreConfig.GRID_TYPE)?observed.lines!=0:observed.lines==0) ||
            ("horizontal".equals(StoreConfig.GRID_TYPE) && observed.vertical!=0) ||
            ("full".equals(StoreConfig.GRID_TYPE) && observed.vertical==0)) {
            throw new Lang.InvalidValueException("Publishing grid/alignment dispatch mismatch");
        }
        var count=Grid.capacity(DeviceProfile.DESIGN_ROWS,_settings.enlarged);
        if(_renderer._runs.size()!=count || _renderer._compactLines.size()!=0 || count!=StoreConfig.PRIMARY.size()) {
            throw new Lang.InvalidValueException("Publishing grid does not fit");
        }
        if(Graphics.getFontHeight(_renderer._labels)!=FontSelection.height(DeviceProfile.LABEL_SIZE,true)) {
            throw new Lang.InvalidValueException("Publishing label font mismatch");
        }
        for(var slot=0;slot<count;slot+=1) {
            var value=_snapshot[:values][slot];var run=_renderer._runs[slot];
            var expected=StoreConfig.PRIMARY[slot];
            if((expected==null?value[:text]!=null:!expected.equals(value[:text])) ||
                !StoreConfig.HEADERS[slot].equals(value[:label]) || !StoreConfig.SECONDARY[slot].equals(value[:unit]) ||
                !(expected==null?PresentationPolicy.UNAVAILABLE:expected).equals(run.text) ||
                Graphics.getFontHeight(run.font)!=FontSelection.height(run.size,false) ||
                dc.getTextWidthInPixels(run.text,run.font)!=run.width ||
                dc.getTextWidthInPixels(value[:label],_renderer._labels)!=FontMetrics.width(value[:label],_renderer._labelMetrics)) {
                throw new Lang.InvalidValueException("Publishing field or font mismatch at "+slot);
            }
            if(!_settings.effects[slot] && (value[:band]!=null || value[:angle]!=null)) {
                throw new Lang.InvalidValueException("Publishing disabled effect painted");
            }
        }
        if(!_reported) {
            System.println("STORE_OK id="+StoreConfig.ID+" product="+DeviceProfile.ID+
                " width="+dc.getWidth()+" height="+dc.getHeight()+" fields="+count+
                " grid="+StoreConfig.GRID_TYPE+" alignment="+StoreConfig.ALIGNMENT+" lines="+observed.lines);
            _reported=true;
        }
    }
}
