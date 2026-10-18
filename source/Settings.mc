using Toybox.Application;
using Toybox.Lang;

// APP-31/46/49: a complete validated snapshot; runtime never writes fallbacks to saved settings.
class DisplaySettings {
    var enlarged;
    var alignment;
    var theme;
    var slots;
    var effects;
    var modes;
    var teamText;var teamFonts;var teamSources;
    var cadenceBounds=[60,80,100,120];
    var hideValueUnits;
    var inverseEnlargedTheme;
    var gridType;
    var usesBattery;
    var usesClock;
    var revision=0;
    var _prefix="";
    function initialize() {
        enlarged = 0; alignment = "right"; theme = "auto";
        slots = Catalog.defaultSlots(); effects = [false,false,false,false,false,false,false,false,false,false];
        modes=[0,0,0,0,0,0,0,0,0,0];
        teamText="TEAM";
        teamFonts=[0,0,0,0,0,0,0,0,0,0];teamSources=[0,0,0,0,0,0,0,0,0,0];
        hideValueUnits=true; inverseEnlargedTheme=true; gridType="horizontal"; usesBattery=false; usesClock=true;
    }
    function load() {
        var values=SettingsMigration.load();
        apply(values);
    }
    function get(values as Lang.Dictionary, key) { var saved=_prefix+key;return values.hasKey(saved) ? values[saved] : null; }
    function applyBank(values,prefix) { _prefix=prefix;apply(values); }
    function booleanValue(values, key) {
        var value=get(values,key); return value instanceof Lang.Boolean ? value : true;
    }
    function apply(values as Lang.Dictionary) {
        revision+=1;var nextBounds=CadenceZones.configured(values);
        // One shared value; retain the original storage key across upgrades.
        teamText=TeamOptions.text(values.hasKey("slot_1_team_text")?values["slot_1_team_text"]:null);
        if(!CadenceZones.same(cadenceBounds,nextBounds)) { cadenceBounds=nextBounds; }
        // Retired field_count and use_units_as_labels are ignored. APP-20 derives the count
        // from measured rows and the selected number of enlarged top fields.
        var second="second_".equals(_prefix);
        var big = get(values, "enlarged_field_count");
        enlarged = big instanceof Lang.Number && big >= 0 && big <= 2 ? big : (second?1:0);
        var align = SettingsCatalogue.decode("alignment",get(values, "alignment")); alignment = "center".equals(align) ? "center" : "right";
        var mode = SettingsCatalogue.decode("theme_mode",get(values, "theme_mode")); theme = "day".equals(mode) || "night".equals(mode) ? mode : "auto";
        hideValueUnits=booleanValue(values,"hide_value_units");
        inverseEnlargedTheme=booleanValue(values,"inverse_enlarged_theme");
        var grid=SettingsCatalogue.decode("grid_type",get(values,"grid_type"));
        gridType="none".equals(grid)?"none":("full".equals(grid)?"full":"horizontal");
        var defaults = second?Catalog.secondaryDefaultSlots():Catalog.defaultSlots();
        usesBattery=false;usesClock=false;
        for (var i = 0; i < 10; i += 1) {
            var key = "slot_" + (i+1).toString() + "_value";
            var selected = SettingsCatalogue.decode(key,get(values,key));
            // A valid unknown identifier is retained and renders unavailable; malformed -> slot default.
            slots[i] = selected instanceof Lang.String && selected.length() > 0 ? selected : defaults[i];
            if("battery".equals(slots[i])) { usesBattery=true; }
            if("time_of_day".equals(slots[i])) { usesClock=true; }
            var enabled = get(values, "slot_" + (i+1).toString() + "_background_effects");
            var coverage=get(values,"slot_"+(i+1).toString()+"_background_mode");
            var version=values.hasKey("settings_schema_version")?values["settings_schema_version"]:0;
            var compatible=version==null || (version instanceof Lang.Number && version==0);
            var fallback=second && i<4?1:0;
            if(SettingsMigration.validMode(coverage)) { modes[i]=coverage; }
            else if(compatible && (coverage==null || (coverage instanceof Lang.Number && coverage==-1)) && enabled instanceof Lang.Boolean) {
                modes[i]=enabled?("grade".equals(slots[i])?2:1):0;
            } else { modes[i]=version instanceof Lang.Number && version==1?fallback:(compatible?fallback:0); }
            effects[i]=modes[i]!=0;
            var slot="slot_"+(i+1).toString();
            teamFonts[i]=TeamOptions.code(get(values,slot+"_team_font"),9);
            teamSources[i]=TeamOptions.code(get(values,slot+"_team_color_source"),2);
        }
    }
}
