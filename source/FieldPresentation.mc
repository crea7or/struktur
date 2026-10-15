// DVS-50/51: presentation decisions independent of sensor acquisition.
module FieldPresentation {
    function headerText(label,unit,override,hideUnits) {
        if(hideUnits || unit.length()==0) { return label; }
        if(override==null || override.length()==0) { return label+" | "+unit; }
        var marker=override.find("{unit}");
        return marker==null?override:override.substring(0,marker)+unit+override.substring(marker+6,override.length());
    }
    function physicalText(index, label, unit, settings) {
        return [headerText(label,unit,index==null?null:Catalog.HEADERS_WITH_UNITS[index],settings.hideValueUnits),""];
    }
    function baseNight(theme, available, deviceNight) {
        return "night".equals(theme) || ("auto".equals(theme) && available && deviceNight);
    }
    function effectiveNight(baseNight, enlarged, inverse) {
        return enlarged && inverse ? !baseNight : baseNight;
    }
}
