// DVS-50/51: presentation decisions independent of sensor acquisition.
module FieldPresentation {
    function headerUnits(kind) {
        if("speed".equals(kind)) { return ["km/h","mph"]; }
        if("distance".equals(kind)) { return ["km","mi"]; }
        if("elevation".equals(kind)) { return ["m","ft"]; }
        if("temperature".equals(kind)) { return ["°c","°f"]; }
        return ["degrees".equals(kind)?"°":kind];
    }
    function includeHeader(text,metrics,top,limits) {
        var bounds=FontMetrics.bounds(text,metrics);
        var padded=2*top+bounds[0]+bounds[1];
        if(limits[0]==0 || padded<limits[0]) { limits[0]=padded; }
        var safe=top+bounds[1]+1;
        if(safe>limits[1]) { limits[1]=safe; }
    }
    // Once per renderer/profile, including hidden fields and preference variants.
    function headerBandHeight(metrics,top) {
        var limits=[0,0];
        for(var i=0;i<Catalog.LABELS.size();i+=1) {
            includeHeader(Catalog.LABELS[i],metrics,top,limits);
            var units=headerUnits(Catalog.UNITS[i]);
            for(var u=0;u<units.size();u+=1) {
                var header=headerText(Catalog.LABELS[i],units[u],Catalog.HEADERS_WITH_UNITS[i],false);
                includeHeader(header,metrics,top,limits);
                if("clock".equals(Catalog.FORMATS[i])) {
                    includeHeader(header+" | am",metrics,top,limits);
                    includeHeader(header+" | pm",metrics,top,limits);
                }
            }
        }
        return limits[0]>limits[1]?limits[0]:limits[1];
    }
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
