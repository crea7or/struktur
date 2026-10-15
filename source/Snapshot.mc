using Toybox.System;
using Toybox.Time;
using Toybox.UserProfile;
using Toybox.Activity;
using Toybox.Lang;
using Toybox.Math;

class SnapshotEngine {
    var _power;
    var _heart;
    var _hrZones;
    var _powerZones;
    var _identity as Lang.Numeric or Null;
    function initialize() { _power=new RollingWindow(); _heart=new RollingWindow(); _hrZones=null; _powerZones=null; }
    function reset() { _power.reset(); _heart.reset(); _identity=null; }
    function metadata() {
        _hrZones=null; _powerZones=null;
        try { if (UserProfile has :getHeartRateZones) { _hrZones=ZoneMetadata.heart(UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING)); } } catch(e) {}
        try { if (UserProfile has :getPowerZones && ZoneMetadata.powerQualified()) { _powerZones=ZoneMetadata.power(UserProfile.getPowerZones(Activity.SPORT_CYCLING),true); } } catch(e) {}
    }
    function rawValue(raw as Lang.Dictionary,key) { return raw.hasKey(key) ? raw[key] : null; }
    function initial(settings) { return prepare({},settings,false); }
    function compute(raw as Lang.Dictionary,settings) as Lang.Dictionary {
        var identity=rawValue(raw,"_activity_identity");
        if(_identity!=null && identity!=null && _identity!=identity) { reset(); }
        if(identity!=null) { _identity=identity; }
        var elapsed=rawValue(raw,"elapsed_time");
        var second=Numeric.finite(elapsed) && elapsed>=0?Math.floor(elapsed/1000.0):null;
        var active=rawValue(raw,"_sampling_enabled")==true;
        if(!active) { reset(); }
        var watts=rawValue(raw,"current_power");var heart=rawValue(raw,"current_heart_rate");
        raw["power_3s"]=active?_power.push(Numeric.finite(watts) && watts>=0?watts:null,second):null;
        raw["heart_rate_3s"]=active?_heart.push(Numeric.finite(heart) && heart>0?heart:null,second):null;
        raw["heart_rate_zone"]=ZoneMetadata.classify(heart,_hrZones);
        raw["power_zone"]=ZoneMetadata.classify(watts,_powerZones);
        return prepare(raw,settings,true);
    }
    function prepare(raw as Lang.Dictionary,settings,hasSample) as Lang.Dictionary {
        return prepareWithPreferences(raw,settings,hasSample,System.getDeviceSettings(),hasSample?System.getClockTime():null);
    }
    function prepareWithPreferences(raw,settings,hasSample,device,clock) as Lang.Dictionary {
        var distanceStatute=device has :distanceUnits && device.distanceUnits==System.UNIT_STATUTE;
        var elevationStatute=device has :elevationUnits && device.elevationUnits==System.UNIT_STATUTE;
        var temperatureStatute=device has :temperatureUnits && device.temperatureUnits==System.UNIT_STATUTE;
        var clock24=!(device has :is24Hour) || device.is24Hour!=false;
        var night=FieldPresentation.baseNight(settings.theme,device has :isNightModeEnabled,device has :isNightModeEnabled && device.isNightModeEnabled);
        var values=[] as Lang.Array;
        for(var i=0;i<10;i+=1) {
            var id=settings.slots[i]; var idx=Catalog.index(id); var value=rawValue(raw,id);
            var label=idx==null ? "field" : Catalog.LABELS[idx];
            var unit=idx==null ? "" : Catalog.UNITS[idx]; var fmt=idx==null ? "integer" : Catalog.FORMATS[idx];
            if("speed".equals(unit)) { value=Formatting.speed(value,distanceStatute); unit=distanceStatute?"mph":"km/h"; }
            else if("distance".equals(unit)) { value=Formatting.distance(value,distanceStatute); unit=distanceStatute?"mi":"km"; }
            else if("elevation".equals(unit)) { value=Formatting.elevation(value,elevationStatute); unit=elevationStatute?"ft":"m"; }
            else if("temperature".equals(unit)) { value=Formatting.temperature(value,temperatureStatute); unit=temperatureStatute?"°f":"°c"; }
            else if("degrees".equals(unit)) { value=Formatting.degrees(value); unit="°"; }
            var presentation=FieldPresentation.physicalText(idx,label,unit,settings);
            label=presentation[0]; unit=presentation[1];
            // DVS-36: cardinal text is optional when the measured group fits.
            var cardinal="heading".equals(id)?Formatting.cardinal(value):null;
            var expandedUnit=cardinal==null?null:unit+(unit.length()>0?" ":"")+cardinal;
            var text=null;
            if("clock".equals(fmt)) {
                if(hasSample && clock!=null && clock has :hour && clock has :min) {
                    text=Formatting.clock(clock.hour,clock.min,clock24);
                    if(text!=null && !clock24) { label+=" | "+Formatting.clockPeriod(clock.hour); }
                }
            }
            else if("duration".equals(fmt)) {
                var duration=Formatting.durationParts(value,PresentationPolicy.PAD_LEADING_MINUTES);
                text=duration[0]; unit=duration[1];
            }
            else if("speed".equals(idx==null?"":Catalog.UNITS[idx]) || "grade".equals(id)) {
                text=Formatting.fixed(value,1);
            }
            else if("elevation".equals(id)) { text=Formatting.integral(value); }
            else { text="heading".equals(id)?Formatting.heading(value):("float".equals(fmt) ? Formatting.floating(value) : Formatting.integral(value)); }
            var band=null; var angle=null;
            if(settings.effects[i] && value!=null && Effects.hasCustomBackground(id)) {
                if("grade".equals(id)) { band=Effects.gradeBand(rawValue(raw,id)); angle=Effects.horizonAngle(rawValue(raw,id)); }
                else if("temperature".equals(id)) { band=Effects.temperatureBand(rawValue(raw,id)); }
                else if("current_heart_rate".equals(id) || "heart_rate_3s".equals(id) || "average_heart_rate".equals(id)) {
                    band=Effects.zoneColor(ZoneMetadata.classify(value,_hrZones));
                } else if("current_power".equals(id) || "power_3s".equals(id) || "average_power".equals(id)) {
                    band=Effects.zoneColor(ZoneMetadata.classify(value,_powerZones));
                }
            }
            // Valid semantic effects win; every enabled known field has a gray default.
            if(settings.effects[i] && idx!=null && band==null) {
                band=FieldPresentation.effectiveNight(night,i<settings.enlarged,settings.inverseEnlargedTheme)?"dark_gray":"light_gray";
                angle=null;
            }
            values.add({:label=>label,:text=>text,:unit=>unit,:expandedUnit=>expandedUnit,:band=>band,:angle=>angle,:format=>fmt});
        }
        return {:values=>values,:night=>night,:raw=>raw,:hasSample=>hasSample,:inverse=>settings.inverseEnlargedTheme};
    }
}
