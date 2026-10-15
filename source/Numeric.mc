using Toybox.Lang;
using Toybox.Math;

// APP-35: reject missing, nonnumeric and nonfinite readings; zero is valid.
(:background)
module Numeric {
    function finite(value) {
        if (!(value instanceof Lang.Number) && !(value instanceof Lang.Long) &&
            !(value instanceof Lang.Float) && !(value instanceof Lang.Double)) { return false; }
        return (value == value) && ((value - value) == 0);
    }
    function rounded(value) {
        return value < 0 ? -Math.floor(-value + 0.5).toNumber() : Math.floor(value + 0.5).toNumber();
    }
    // Do not narrow whole display values to the VM's 32-bit Number range.
    function whole(value) {
        return value < 0 ? -Math.floor(-value + 0.5) : Math.floor(value + 0.5);
    }
    function clamp(value, low, high) { return value < low ? low : (value > high ? high : value); }
}
