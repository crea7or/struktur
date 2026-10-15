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
        _settings.apply({"hide_value_units"=>false,"theme_mode"=>1,"alignment"=>1});
        _engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
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
            var first=_renderer._runs[0];var numericInfo=FontSelection.info(first[:size],false);
            if(Graphics.getFontHeight(labelFont)!=labelInfo[1] || Graphics.getFontHeight(first[:font])!=numericInfo[1] ||
                dc.getTextWidthInPixels("speed | km/h",labelFont)!=FontMetrics.width("speed | km/h",FontMetrics.label(labelInfo[1])) ||
                dc.getTextWidthInPixels("27.3",first[:font])!=FontMetrics.width("27.3",FontMetrics.numeric(numericInfo[1]))) {
                throw new Lang.InvalidValueException("Sample font resource mismatch");
            }
        }
        var signature=dc.getWidth()+"x"+dc.getHeight()+":"+_renderer._runs.size();
        if(!signature.equals(_reported)) {
            System.println("SAMPLE_FRAME product="+DeviceProfile.ID+" width="+dc.getWidth()+" height="+dc.getHeight()+" fields="+_renderer._runs.size());
            System.println("SAMPLE_DATA clock="+_snapshot[:values][3][:text]+" temperature="+_snapshot[:values][9][:text]);
            _reported=signature;
        }
    }
}
