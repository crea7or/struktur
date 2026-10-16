using Toybox.Lang;
// DVS-42: HR's six min/max bounds are documented; power's shape is not.
module ZoneMetadata {
    function bounds(values, count) {
        if(!(values instanceof Lang.Array) || values.size()<2 || (count!=null && values.size()!=count)) { return null; }
        for(var i=0;i<values.size();i+=1) {
            if(!Numeric.finite(values[i]) || values[i]<0 || (i>0 && values[i]<=values[i-1])) { return null; }
        }
        return values;
    }
    function heart(values) { return bounds(values,6); }
    function power(values,qualifiedMinMax) {
        return qualifiedMinMax==true?bounds(values,null):null;
    }
    function powerQualified() {
        // No pinned SDK/device evidence establishes the power array interpretation.
        // See requirements/zone-api-assessment.json. Never assume HR's representation.
        return false;
    }
    // Internal path: bounds are an immutable result of heart()/power(), or null.
    function classifyValidated(value,bounds) {
        if(!Numeric.finite(value) || value<0 || bounds==null) { return null; }
        var whole=Numeric.whole(value);
        if(whole<bounds[0] || whole>bounds[bounds.size()-1]) { return null; }
        for(var i=1;i<bounds.size();i+=1) { if(whole<=bounds[i]) { return i; } }
        return null;
    }
    function classify(value,bounds) {
        return Numeric.finite(value) && value>=0?Effects.zone(Numeric.whole(value),bounds,true):null;
    }
}
