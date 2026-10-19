using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

// Synthetic visual fixture only. Production builds do not include this folder.
// Shares the production snapshot engine, field renderer and native Data Field DC.
class SampleClock { var hour=13;var min=5; }
class SamplePreferences {
    var distanceUnits=System.UNIT_METRIC;
    var elevationUnits=System.UNIT_METRIC;
    var temperatureUnits=System.UNIT_METRIC;
    var is24Hour=true;
    var isNightModeEnabled=false;
}
class SamplePreviewField extends StrukturField {
    var _reported="";
    function initialize() {
        StrukturField.initialize();
        var props={"a_hideu"=>false,"a_theme"=>1,"a_align"=>1,"a_big"=>1};
        var ids=["power_3s","current_speed","current_heart_rate","grade","temperature","distance","elevation",
            "activity_timer","time_of_day","total_ascent"];
        for(var slot=0;slot<ids.size();slot+=1) { props["a"+(slot+1).toString()]=ids[slot]; }
        _settings.apply(props);
        _engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
        // Synthetic thresholds for color presentation only; production qualification is unchanged.
        _engine._powerZones=ZoneMetadata.power([0,100,200,300,400,500,650,1000],true);
        refreshPresentation();
    }
    // Background deliveries/settings callbacks must also retain sample data.
    function refreshPresentation() {
        var raw={"current_speed"=>27.3/3.6,"distance"=>12340,"activity_timer"=>5025000,"current_heart_rate"=>154,
            "power_3s"=>245,"elevation"=>1456,"grade"=>6.8,"total_ascent"=>456,"temperature"=>24.5};
        _snapshot=_engine.prepareWithPreferences(raw,_settings,true,new SamplePreferences(),new SampleClock());
        _renderer.prepare(_snapshot);_layoutDirty=true;
    }
    function compute(info) {} // No sensor/provenance or memory qualification.
    function onShow() {} // Preserve the deterministic clock and sample readings.
    function onUpdate(dc) {
        StrukturField.onUpdate(dc);
        if(_renderer._runs.size()>0) {
            var labelFont=_renderer._labels;
            var labelInfo=FontSelection.info(DeviceProfile.LABEL_SIZE,true);
            var first=_renderer._runs[0];var numericInfo=FontSelection.info(first.size,false);
            if(Graphics.getFontHeight(labelFont)!=labelInfo[1] || Graphics.getFontHeight(first.font)!=numericInfo[1] ||
                dc.getTextWidthInPixels("speed | km/h",labelFont)!=FontMetrics.width("speed | km/h",FontMetrics.label(labelInfo[1])) ||
                dc.getTextWidthInPixels("245",first.font)!=FontMetrics.width("245",FontMetrics.numeric(numericInfo[1]))) {
                throw new Lang.InvalidValueException("Sample font resource mismatch");
            }
            if(_settings.enlarged!=1 || !_renderer._cells[0][Cell.ENLARGED] || first.size!=DeviceProfile.BIG_SIZE ||
                !"245".equals(first.text) || !"3s watts".equals(_snapshot[:values][0][ValueRecord.LABEL]) ||
                _renderer._runs.size()!=Grid.capacity(DeviceProfile.DESIGN_ROWS,1)) {
                throw new Lang.InvalidValueException("Sample enlarged power layout mismatch");
            }
        }
        var signature=dc.getWidth()+"x"+dc.getHeight()+":"+_renderer._runs.size();
        if(!signature.equals(_reported)) {
            System.println("SAMPLE_FRAME product="+DeviceProfile.ID+" width="+dc.getWidth()+" height="+dc.getHeight()+" fields="+_renderer._runs.size());
            System.println("SAMPLE_DATA clock="+_snapshot[:values][8][ValueRecord.TEXT]+" temperature="+_snapshot[:values][4][ValueRecord.TEXT]+
                " enlarged=1 field=power_3s power="+_snapshot[:values][0][ValueRecord.TEXT]);
            _reported=signature;
        }
    }
}
