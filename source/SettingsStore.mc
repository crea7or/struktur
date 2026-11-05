using Toybox.Application;
// Foreground-only read bridge. Runtime fallbacks never rewrite saved settings.
class SettingsPropertyStore {
    function get(key) { try { return Application.Properties.getValue(key); } catch(e) { return null; } }
}
module SettingsStore {
    function validMode(value) { return value instanceof Toybox.Lang.Number && value>=0 && value<=2; }
    function load() { return read(new SettingsPropertyStore()); }
    function read(store) {
        var values={};var keys=SettingsCatalogue.keys();
        for(var i=0;i<keys.size();i+=1) {
            var value=store.get(keys[i]);
            // An unavailable native property is missing, not an explicitly malformed cutoff.
            if(value!=null) { values[keys[i]]=value; }
        }
        return values;
    }
}
