using Toybox.System;
using Toybox.Time;
using Toybox.UserProfile;
using Toybox.Activity;
using Toybox.Lang;
using Toybox.Math;

// Fixed-shape slot state avoids a hash table per cached field on the shared heap.
// Published snapshots remain separate objects; the cache never mutates old readings.
class SnapshotDescriptor {
    var id;var index;var kind;var format;
    var hide=null;var statute=null;var label;var am;var pm;
    var ready=false;var reading;var converted;var lastLabel;var text;var unit;var expanded;
    var hour;var minute;var clock24;var hasSample;
    function initialize(fieldId,fieldIndex) {
        id=fieldId;index=fieldIndex;
        kind=index==null?"":Catalog.UNITS[index];
        format=index==null?"integer":Catalog.FORMATS[index];
    }
}

class SnapshotEngine {
    var _power;
    var _heart;
    var _hrZones;
    var _powerZones;
    var _identity as Lang.Numeric or Null;
    var _descriptors=[];
    var descriptorBuilds=0;
    var headerBuilds=0;
    var formatBuilds=0;
    function initialize() { _power=new RollingWindow(); _heart=new RollingWindow(); _hrZones=null; _powerZones=null; }
    // Ten bounded assignment caches, separate from the published snapshot and live readings.
    function descriptor(slot,id,hideUnits,distanceStatute,elevationStatute,temperatureStatute) {
        var d=slot<_descriptors.size()?_descriptors[slot]:null;
        if(d==null || !d.id.equals(id)) {
            var index=Catalog.index(id);
            d=new SnapshotDescriptor(id,index);
            if(slot<_descriptors.size()) { _descriptors[slot]=d; } else { _descriptors.add(d); }
            descriptorBuilds+=1;
        }
        var kind=d.kind;
        var statute="elevation".equals(kind)?elevationStatute:("temperature".equals(kind)?temperatureStatute:
            (("speed".equals(kind) || "distance".equals(kind)) && distanceStatute));
        if(d.hide!=hideUnits || d.statute!=statute) {
            var units=FieldPresentation.headerUnits(kind);
            var unit=units[statute && units.size()>1?1:0];
            var label=d.index==null?"field":Catalog.LABELS[d.index];
            var override=d.index==null?null:Catalog.HEADERS_WITH_UNITS[d.index];
            d.label=FieldPresentation.headerText(label,unit,override,hideUnits);
            if("clock".equals(d.format)) { d.am=d.label+" | am";d.pm=d.label+" | pm"; }
            d.hide=hideUnits;d.statute=statute;headerBuilds+=1;
            d.ready=false;
        }
        return d;
    }
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
        return prepareWithPreferences(raw,settings,hasSample,System.getDeviceSettings(),hasSample && settings.usesClock?System.getClockTime():null);
    }
    function prepareWithPreferences(raw,settings,hasSample,device,clock) as Lang.Dictionary {
        var distanceStatute=device has :distanceUnits && device.distanceUnits==System.UNIT_STATUTE;
        var elevationStatute=device has :elevationUnits && device.elevationUnits==System.UNIT_STATUTE;
        var temperatureStatute=device has :temperatureUnits && device.temperatureUnits==System.UNIT_STATUTE;
        var clock24=!(device has :is24Hour) || device.is24Hour!=false;
        var night=FieldPresentation.baseNight(settings.theme,device has :isNightModeEnabled,device has :isNightModeEnabled && device.isNightModeEnabled);
        var hour=clock!=null && clock has :hour?clock.hour:null;
        var minute=clock!=null && clock has :min?clock.min:null;
        var values=[] as Lang.Array;
        for(var i=0;i<10;i+=1) {
            var id=settings.slots[i];
            var d=descriptor(i,id,settings.hideValueUnits,distanceStatute,elevationStatute,temperatureStatute);
            var idx=d.index;var value=rawValue(raw,id);var kind=d.kind;var fmt=d.format;
            var label=d.label;var unit="";
            var reading=value;var text=null;var expandedUnit=null;
            if(d.ready && d.reading==reading && (!"clock".equals(fmt) ||
                (d.hour==hour && d.minute==minute && d.clock24==clock24 && d.hasSample==hasSample))) {
                value=d.converted;label=d.lastLabel;text=d.text;unit=d.unit;expandedUnit=d.expanded;
            } else {
            if("speed".equals(kind)) { value=Formatting.speed(value,distanceStatute); }
            else if("distance".equals(kind)) { value=Formatting.distance(value,distanceStatute); }
            else if("elevation".equals(kind)) { value=Formatting.elevation(value,elevationStatute); }
            else if("temperature".equals(kind)) { value=Formatting.temperature(value,temperatureStatute); }
            else if("degrees".equals(kind)) { value=Formatting.degrees(value); }
            // DVS-36: cardinal text is optional when the measured group fits.
            var cardinal="heading".equals(id)?Formatting.cardinal(value):null;
            expandedUnit=cardinal==null?null:unit+(unit.length()>0?" ":"")+cardinal;
            if("clock".equals(fmt)) {
                if(hasSample && clock!=null && clock has :hour && clock has :min) {
                    text=Formatting.clock(clock.hour,clock.min,clock24);
                    if(text!=null && !clock24) { label=clock.hour<12?d.am:d.pm; }
                }
            }
            else if("duration".equals(fmt)) {
                var duration=Formatting.durationParts(value,PresentationPolicy.PAD_LEADING_MINUTES);
                text=duration[0]; unit=duration[1];
            }
            else if("speed".equals(kind) || "grade".equals(id) || "temperature".equals(kind)) {
                text=Formatting.fixed(value,1);
            }
            else if("elevation".equals(id)) { text=Formatting.integral(value); }
            else { text="heading".equals(id)?Formatting.heading(value):("float".equals(fmt) ? Formatting.floating(value) : Formatting.integral(value)); }
            d.ready=true;d.reading=reading;d.converted=value;d.lastLabel=label;
            d.text=text;d.unit=unit;d.expanded=expandedUnit;
            if("clock".equals(fmt)) { d.hour=hour;d.minute=minute;d.clock24=clock24;d.hasSample=hasSample; }
            formatBuilds+=1;
            }
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
