using Toybox.Math;

// Pure production formatting. Presentation markers are supplied by a reviewed contract.
// null means unavailable; "overflow" is an internal status, never the visible glyph.
module Formatting {
    const DIRECTIONS=["N","NE","E","SE","S","SW","W","NW"];
    // Explicit field precision; never discard requested decimal digits to fit.
    function fixed(value, precision) {
        if (!Numeric.finite(value)) { return null; }
        var scale=precision==2?100.0:(precision==1?10.0:1.0);
        // Bound before converting the scaled result to the VM's Number type.
        if (value.abs()>99999.5) { return "overflow"; }
        var result=Numeric.rounded(value*scale)/scale;
        if(result==0) { result=0.0; }
        return result.format(precision==2?"%.2f":(precision==1?"%.1f":"%.0f"));
    }
    // DVS-2: select decimal places by converted magnitude; promote on rounding carry.
    function floating(value) {
        if (!Numeric.finite(value)) { return null; }
        var magnitude=value.abs();
        var precision=magnitude<10?2:(magnitude<100?1:0);
        if(precision==0) { return integral(value); }
        var scale=precision==2?100.0:10.0;
        var result=Numeric.rounded(value*scale)/scale;
        if(precision==2 && result.abs()>=10) {
            precision=1;result=Numeric.rounded(value*10.0)/10.0;
        }
        if(precision==1 && result.abs()>=100) { return integral(value); }
        if(result==0) { result=0.0; }
        return result.format(precision==2?"%.2f":"%.1f");
    }
    function integral(value) {
        if (!Numeric.finite(value)) { return null; }
        if(value instanceof Toybox.Lang.Number || value instanceof Toybox.Lang.Long) { return value.toString(); }
        var whole=Numeric.whole(value);
        return whole==0?"0":whole.format("%.0f");
    }
    // DVS-13/DEC-DURATION: production selects two-digit leading minutes explicitly.
    function duration(milliseconds, padLeadingMinutes) {
        if (!Numeric.finite(milliseconds) || milliseconds < 0) { return null; }
        var seconds = Math.floor(milliseconds / 1000).toNumber();
        var hours = seconds / 3600;
        var minutes = (seconds % 3600) / 60;
        var remainder = seconds % 60;
        if (hours >= 10) { return hours.toString() + ":" + minutes.format("%02d"); }
        if (hours > 0) { return hours.toString() + ":" + minutes.format("%02d") + "." + remainder.format("%02d"); }
        if (padLeadingMinutes == null) { return null; }
        return minutes.format(padLeadingMinutes ? "%02d" : "%d") + "." + remainder.format("%02d");
    }
    // DVS-13: .SS uses LABELS_FONT only below ten hours.
    function durationParts(milliseconds, padLeadingMinutes) {
        var text=duration(milliseconds,padLeadingMinutes);
        if(text==null) { return [text,""]; }
        if(text.find(".")==null) { return [text,""]; }
        var primaryLength=text.length()-3;
        return [text.substring(0,primaryLength),text.substring(primaryLength,text.length())];
    }
    function clock(hour, minute, is24Hour) {
        if (!Numeric.finite(hour) || !Numeric.finite(minute) || hour<0 || hour>23 || minute<0 || minute>59 ||
            hour!=Math.floor(hour) || minute!=Math.floor(minute)) { return null; }
        if (is24Hour) { return hour.format("%02d") + ":" + minute.format("%02d"); }
        var h = hour % 12;
        if (h == 0) { h = 12; }
        return h.toString() + ":" + minute.format("%02d");
    }
    function clockPeriod(hour) { return hour < 12 ? "am" : "pm"; }
    function speed(mps, statute) { return Numeric.finite(mps) ? mps * (statute ? 2.2369362921 : 3.6) : null; }
    function distance(meters, statute) { return Numeric.finite(meters) ? meters / (statute ? 1609.344 : 1000.0) : null; }
    function elevation(meters, statute) { return Numeric.finite(meters) ? meters * (statute ? 3.280839895 : 1.0) : null; }
    function temperature(celsius, statute) { return Numeric.finite(celsius) ? (statute ? celsius * 1.8 + 32 : celsius) : null; }
    function degrees(radians) {
        if(!Numeric.finite(radians)) { return null; }
        var degrees=radians*180.0/Math.PI;
        return Numeric.finite(degrees)?degrees-Math.floor(degrees/360.0)*360.0:null;
    }
    function heading(degrees) { return Numeric.finite(degrees)?(Numeric.rounded(degrees)%360).toString():null; }
    function cardinal(degrees) {
        if(!Numeric.finite(degrees)) { return null; }
        var normalized=degrees-Math.floor(degrees/360.0)*360.0;
        return DIRECTIONS[Numeric.rounded(normalized/45.0)%8];
    }
}
