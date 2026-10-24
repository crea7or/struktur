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
    var teamText;var teamSource;
    var cadenceBounds=[60,80,100,120];
    var heartProfile=null;var powerProfile=null;
    var hideValueUnits;
    var inverseEnlargedTheme;
    var gridType;
    var usesBattery;
    var usesClock;
    var revision=0;
    var _prefix="a";
    function initialize() {
        enlarged = 0; alignment = "right"; theme = "auto";
        slots = Catalog.defaultSlots(); effects = [false,false,false,false,false,false,false,false,false,false];
        modes=[0,0,0,0,0,0,0,0,0,0];
        teamText="TEAM";
        teamSource=0;
        hideValueUnits=true; inverseEnlargedTheme=true; gridType="horizontal"; usesBattery=false; usesClock=true;
    }
    function load() {
        var values=SettingsStore.load();
        apply(values);
    }
    function get(values as Lang.Dictionary, key) { var saved=_prefix+key.substring(1,key.length());return values.hasKey(saved) ? values[saved] : null; }
    function applyBank(values,prefix) { _prefix=prefix;apply(values); }
    function booleanValue(values, key) {
        var value=get(values,key); return value instanceof Lang.Boolean ? value : true;
    }
    function applySharedBank(values,prefix,shared) { _prefix=prefix;applySettings(values,shared); }
    function apply(values as Lang.Dictionary) { applySettings(values,null); }
    function applySettings(values,shared) {
        revision+=1;var nextBounds=shared==null?CadenceZones.configured(values):shared.cadenceBounds;
        heartProfile=shared==null?TrainingZones.configured(values,false,heartProfile):shared.heartProfile;
        powerProfile=shared==null?TrainingZones.configured(values,true,powerProfile):shared.powerProfile;
        // All Team slots in both sets share these two properties.
        teamText=TeamOptions.text(values.hasKey("team")?values["team"]:null);
        teamSource=TeamOptions.code(values.hasKey("tsrc")?values["tsrc"]:null,2);
        if(!CadenceZones.same(cadenceBounds,nextBounds)) { cadenceBounds=nextBounds; }
        var second="b".equals(_prefix);
        var big = get(values, "a_big");
        enlarged = big instanceof Lang.Number && big >= 0 && big <= 2 ? big : (second?1:0);
        var align = SettingsCatalogue.decode("a_align",get(values, "a_align")); alignment = "center".equals(align) ? "center" : "right";
        var mode = SettingsCatalogue.decode("a_theme",get(values, "a_theme")); theme = "day".equals(mode) || "night".equals(mode) ? mode : "auto";
        hideValueUnits=booleanValue(values,"a_hideu");
        inverseEnlargedTheme=booleanValue(values,"a_inv");
        var grid=SettingsCatalogue.decode("a_grid",get(values,"a_grid"));
        gridType="none".equals(grid)?"none":("full".equals(grid)?"full":"horizontal");
        var defaults = second?Catalog.secondaryDefaultSlots():Catalog.defaultSlots();
        usesBattery=false;usesClock=false;
        for (var i = 0; i < 10; i += 1) {
            var key = "a" + (i+1).toString() ;
            var selected = SettingsCatalogue.decode(key,get(values,key));
            // A valid unknown identifier is retained and renders unavailable; malformed -> slot default.
            slots[i] = selected instanceof Lang.String && selected.length() > 0 ? selected : defaults[i];
            if("battery".equals(slots[i])) { usesBattery=true; }
            if("time_of_day".equals(slots[i])) { usesClock=true; }
            var coverage=get(values,"a"+(i+1).toString()+"_bg");
            modes[i]=SettingsStore.validMode(coverage)?coverage:(second && i<4?1:0);
            effects[i]=modes[i]!=0;
        }
    }
}
