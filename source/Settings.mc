using Toybox.Application;
using Toybox.Lang;

// APP-31/46/49: a complete validated snapshot; runtime never writes fallbacks to saved settings.
class DisplaySettings {
    var enlarged;
    var alignment;
    var theme;
    var slots;
    var effects;
    var hideValueUnits;
    var inverseEnlargedTheme;
    var gridType;
    var usesBattery;
    var usesClock;
    function initialize() {
        enlarged = 0; alignment = "right"; theme = "auto";
        slots = Catalog.defaultSlots(); effects = [false,false,false,false,false,false,false,false,false,false];
        hideValueUnits=true; inverseEnlargedTheme=true; gridType="horizontal"; usesBattery=false; usesClock=true;
    }
    function load() {
        var values = {} as Lang.Dictionary;
        var keys = SettingsCatalogue.keys();
        for (var i = 0; i < keys.size(); i += 1) {
            try { values[keys[i]] = Application.Properties.getValue(keys[i]); }
            catch (e) { values[keys[i]] = null; }
        }
        apply(values);
    }
    function get(values as Lang.Dictionary, key) { return values.hasKey(key) ? values[key] : null; }
    function booleanValue(values, key) {
        var value=get(values,key); return value instanceof Lang.Boolean ? value : true;
    }
    function apply(values as Lang.Dictionary) {
        // Retired field_count and use_units_as_labels are ignored. APP-20 derives the count
        // from measured rows and the selected number of enlarged top fields.
        var big = get(values, "enlarged_field_count");
        enlarged = big instanceof Lang.Number && big >= 0 && big <= 2 ? big : 0;
        var align = SettingsCatalogue.decode("alignment",get(values, "alignment")); alignment = "center".equals(align) ? "center" : "right";
        var mode = SettingsCatalogue.decode("theme_mode",get(values, "theme_mode")); theme = "day".equals(mode) || "night".equals(mode) ? mode : "auto";
        hideValueUnits=booleanValue(values,"hide_value_units");
        inverseEnlargedTheme=booleanValue(values,"inverse_enlarged_theme");
        var grid=SettingsCatalogue.decode("grid_type",get(values,"grid_type"));
        gridType="none".equals(grid)?"none":("full".equals(grid)?"full":"horizontal");
        var defaults = Catalog.defaultSlots();
        usesBattery=false;usesClock=false;
        for (var i = 0; i < 10; i += 1) {
            var key = "slot_" + (i+1).toString() + "_value";
            var selected = SettingsCatalogue.decode(key,get(values,key));
            // A valid unknown identifier is retained and renders unavailable; malformed -> slot default.
            slots[i] = selected instanceof Lang.String && selected.length() > 0 ? selected : defaults[i];
            if("battery".equals(slots[i])) { usesBattery=true; }
            if("time_of_day".equals(slots[i])) { usesClock=true; }
            var enabled = get(values, "slot_" + (i+1).toString() + "_background_effects");
            effects[i] = enabled instanceof Lang.Boolean ? enabled : false;
        }
    }
}
