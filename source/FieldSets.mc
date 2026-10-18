using Toybox.Application;
using Toybox.Lang;

// SPEC-208..225: two saved banks; one transient controller and active presentation.
class FieldSetsSettings {
    var primary;var secondary;
    var trigger=3;
    var powerActivate=250;var powerReturn=220;
    var heartActivate=160;var heartReturn=150;
    function initialize() {
        primary=new DisplaySettings();secondary=new DisplaySettings();
        secondary.applyBank({},"second_");
    }
    function load() {
        var values=SettingsMigration.load();
        apply(values);
    }
    function integer(values,key,low,high,fallback) {
        var value=values.hasKey(key)?values[key]:null;
        return value instanceof Lang.Number && value>=low && value<=high?value:fallback;
    }
    function apply(values) {
        primary.applyBank(values,"");secondary.applyBank(values,"second_");
        secondary.cadenceBounds=primary.cadenceBounds;
        trigger=integer(values,"second_set_trigger",0,4,3);
        powerActivate=integer(values,"second_power_activate_w",1,3000,250);
        powerReturn=integer(values,"second_power_return_w",1,3000,220);
        heartActivate=integer(values,"second_hr_activate_bpm",30,250,160);
        heartReturn=integer(values,"second_hr_return_bpm",30,250,150);
    }
    function activation() { return trigger==1?powerActivate:heartActivate; }
    function returning() { return trigger==1?powerReturn:heartReturn; }
    function validPair() { return (trigger!=1 && trigger!=2) || returning()<=activation(); }
}

class FieldSetController {
    var configuration;
    var second=false;
    var _armed=true;
    var _identity=null;
    function initialize(settings) { configuration=settings; }
    function active() { return second?configuration.secondary:configuration.primary; }
    function configure(settings) {
        var changed=configuration.trigger!=settings.trigger;
        if(!changed && (settings.trigger==1 || settings.trigger==2)) {
            changed=configuration.activation()!=settings.activation() || configuration.returning()!=settings.returning();
        }
        configuration=settings;
        if(changed || configuration.trigger==0 || !configuration.validPair()) { second=false; }
    }
    function reset() { second=false;_armed=false;_identity=null; }
    function start() { _armed=true; }
    function lap(manual) { if(_armed && configuration.trigger==3 && manual) { second=!second; } }
    function workout() { _armed=true;if(configuration.trigger==4) { second=true; } }
    function evaluate(raw,running) {
        var identity=raw.hasKey("_activity_identity")?raw["_activity_identity"]:null;
        if(identity!=null) {
            if(_identity!=null && identity!=_identity) { second=false;_armed=true; }
            _identity=identity;
        }
        var mode=configuration.trigger;
        if(mode==0 || !configuration.validPair()) { second=false;return; }
        if(!_armed || !running || (mode!=1 && mode!=2)) { return; }
        var key=mode==1?"power_3s":"current_heart_rate";
        var value=raw.hasKey(key)?raw[key]:null;
        if(!Numeric.finite(value) || value<0 || (mode==2 && value==0)) { second=false;return; }
        if(second) { if(value<configuration.returning()) { second=false; } }
        else if(value>=configuration.activation()) { second=true; }
    }
}
