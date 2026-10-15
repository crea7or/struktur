using Toybox.Math;
using Toybox.Lang;
// DVS-43/44 use the canonical rounded grade; DVS-49 uses raw Celsius.
module Effects {
    function gradeBand(g) {
        if (!Numeric.finite(g)) { return null; }
        if (g <= 0) { return "green"; } if (g <= 2) { return "blue"; }
        if (g <= 5) { return "yellow"; } if (g <= 8) { return "orange"; }
        if (g <= 15) { return "red"; } if (g <= 20) { return "dark_red"; }
        return "black";
    }
    function temperatureBand(c) {
        if (!Numeric.finite(c)) { return null; }
        if (c <= -10) { return "blue"; } if (c <= 0) { return "cyan"; }
        if (c <= 10) { return "white"; } if (c <= 20) { return "green"; }
        if (c <= 30) { return "yellow"; } return "red";
    }
    function horizonAngle(g) { return Numeric.finite(g) ? Numeric.clamp(2.0 * g, -45.0, 45.0) : null; }
    function zoneColor(zone) {
        if (zone == null || zone < 1) { return null; }
        var names = ["blue", "green", "yellow", "orange", "red", "dark_red"];
        return zone > 6 ? "black" : names[zone - 1];
    }
    // Zone equality requires a reviewed policy; no inferred FTP thresholds.
    function zone(value, thresholds, upperInclusive) {
        if (!Numeric.finite(value) || !(thresholds instanceof Lang.Array) || thresholds.size() < 2 || upperInclusive == null) { return null; }
        for (var i = 0; i < thresholds.size(); i += 1) {
            if (!Numeric.finite(thresholds[i]) || thresholds[i]<0 || (i > 0 && thresholds[i] <= thresholds[i-1])) { return null; }
        }
        if (value < thresholds[0] || value > thresholds[thresholds.size()-1]) { return null; }
        for (var j = 1; j < thresholds.size(); j += 1) {
            if ((upperInclusive && value <= thresholds[j]) || (!upperInclusive && value < thresholds[j])) { return j; }
        }
        return thresholds.size()-1;
    }
}
