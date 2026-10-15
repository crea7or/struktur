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
class StorePreviewField extends StrukturField {
    var _reported=false;
    function initialize() {
        StrukturField.initialize();
        _settings.apply(StoreConfig.settings());
        _engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
        // Never turn on the unqualified production power-zone adapter.
        _engine._powerZones=null;
        if(StoreConfig.DEFAULT) {
            if(_settings.enlarged!=0 || !_settings.hideValueUnits || !_settings.inverseEnlargedTheme ||
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
        StrukturField.onUpdate(dc);
        if(dc.getWidth()!=StoreConfig.WIDTH || dc.getHeight()!=StoreConfig.HEIGHT) { return; }
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
                !(expected==null?PresentationPolicy.UNAVAILABLE:expected).equals(run[:text]) ||
                Graphics.getFontHeight(run[:font])!=FontSelection.height(run[:size],false) ||
                dc.getTextWidthInPixels(run[:text],run[:font])!=run[:width] ||
                dc.getTextWidthInPixels(value[:label],_renderer._labels)!=FontMetrics.width(value[:label],_renderer._labelMetrics)) {
                throw new Lang.InvalidValueException("Publishing field or font mismatch at "+slot);
            }
            if(!_settings.effects[slot] && (value[:band]!=null || value[:angle]!=null)) {
                throw new Lang.InvalidValueException("Publishing disabled effect painted");
            }
        }
        if(!_reported) {
            System.println("STORE_OK id="+StoreConfig.ID+" product="+DeviceProfile.ID+
                " width="+dc.getWidth()+" height="+dc.getHeight()+" fields="+count);
            _reported=true;
        }
    }
}
