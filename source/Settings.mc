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
    function initialize() {
        enlarged = 0; alignment = "right"; theme = "auto";
        slots = Catalog.defaultSlots(); effects = [true,true,true,true,true,true,true,true,true,true];
        hideValueUnits=true; inverseEnlargedTheme=true;
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
        var defaults = Catalog.defaultSlots();
        for (var i = 0; i < 10; i += 1) {
            var key = "slot_" + (i+1).toString() + "_value";
            var selected = SettingsCatalogue.decode(key,get(values,key));
            // A valid unknown identifier is retained and renders unavailable; malformed -> slot default.
            slots[i] = selected instanceof Lang.String && selected.length() > 0 ? selected : defaults[i];
            var enabled = get(values, "slot_" + (i+1).toString() + "_background_effects");
            effects[i] = enabled instanceof Lang.Boolean ? enabled : true;
        }
    }
}
