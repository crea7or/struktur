using Toybox.Lang;
// DVS-42: documented HR bounds and the accepted, device-unconfirmed power layout.
module ZoneMetadata {
    function bounds(values, count) {
        if(!(values instanceof Lang.Array) || values.size()<2 || (count!=null && values.size()!=count)) { return null; }
        for(var i=0;i<values.size();i+=1) {
            if(!Numeric.finite(values[i]) || values[i]<0 || (i>0 && values[i]<=values[i-1])) { return null; }
        }
        return values;
    }
    function heart(values) { return bounds(values,6); }
    // DEC-ZONES: power uses HR's documented layout, zone-1 minimum then each zone maximum.
    // The accepted power layout starts at 0 W; reject any other first bound.
    function power(values,qualifiedMinMax) {
        var result=qualifiedMinMax==true?bounds(values,null):null;
        return result!=null && result[0]==0?result:null;
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

// Four saved upper bounds, validated only when configuration is applied.
module CadenceZones {
    function same(a,b) {
        if(a==b) { return true; } if(a==null || b==null) { return false; }
        for(var i=0;i<4;i+=1) { if(a[i]!=b[i]) { return false; } } return true;
    }
    function configured(values) {
        var defaults=[60,80,100,120];var result=[];
        for(var i=0;i<4;i+=1) {
            var key="cad"+(i+1).toString();
            var value=values.hasKey(key)?values[key]:defaults[i];
            if(!(value instanceof Lang.Number) || value<0 || value>300 || (i>0 && value<=result[i-1])) { return null; }
            result.add(value);
        }
        return result;
    }
    function classify(value,bounds) {
        if(!Numeric.finite(value) || value<0 || bounds==null) { return null; }
        var whole=Numeric.whole(value);
        for(var i=0;i<4;i+=1) { if(whole<=bounds[i]) { return i+1; } }
        return 5;
    }
}
