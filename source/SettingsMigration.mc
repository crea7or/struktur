using Toybox.Application;
using Toybox.Lang;

// One foreground bridge. Defaults and saved values are indistinguishable on Garmin.
class SettingsPropertyStore {
    function get(key) { try { return Application.Properties.getValue(key); } catch(e) { return null; } }
    function put(key,value) { Application.Properties.setValue(key,value); }
}
module SettingsMigration {
    function validMode(value) { return value instanceof Lang.Number && value>=0 && value<=2; }
    function load() {
        var fresh=false;
        try { var origin=Application.Storage.getValue("settings_install_origin");fresh=origin instanceof Lang.String && "fresh".equals(origin); } catch(e) {}
        return read(new SettingsPropertyStore(),fresh);
    }
    function read(store,fresh) {
        var values={};var keys=SettingsCatalogue.keys();
        for(var i=0;i<keys.size();i+=1) { var value=store.get(keys[i]);values[keys[i]]=keys[i].find("_team_text")!=null?TeamOptions.text(value):value; }
        var version=values["settings_schema_version"];
        if(version!=null && (!(version instanceof Lang.Number) || version!=0)) { return values; }
        var complete=true;
        for(var bank=0;bank<2;bank+=1) {
            for(var slot=1;slot<=10;slot+=1) {
                var prefix=(bank==1?"second_":"")+"slot_"+slot.toString();
                var key=prefix+"_background_mode";var mode=values[key];
                if(mode!=null && (!(mode instanceof Lang.Number) || mode!=-1)) { continue; }
                var fallback=bank==1 && slot<=4?1:0;
                var legacy=values[prefix+"_background_effects"];
                var field=SettingsCatalogue.decode(prefix+"_value",values[prefix+"_value"]);
                if(!fresh && legacy instanceof Lang.Boolean) { fallback=legacy?("grade".equals(field)?2:1):0; }
                values[key]=fallback;
                try { store.put(key,fallback); } catch(e) { complete=false; }
            }
        }
        if(complete) {
            try { store.put("settings_schema_version",1);values["settings_schema_version"]=1; } catch(e) {}
        }
        return values;
    }
}
