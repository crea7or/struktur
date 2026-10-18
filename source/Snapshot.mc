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
    // Resolve static dispatch once per assignment, not once per delivered sample.
    var conversion=0;var style=0;var effect=0;var zoneChannel=-1;
    var record;var effectReady=false;var effectReading;var effectBounds;
    var effectBand;var effectAngle;
    function initialize(fieldId,fieldIndex) {
        id=fieldId;index=fieldIndex;
        kind=index==null?"":Catalog.UNITS[index];
        format=index==null?"integer":Catalog.FORMATS[index];
        conversion="speed".equals(kind)?1:("distance".equals(kind)?2:("elevation".equals(kind)?3:("temperature".equals(kind)?4:("degrees".equals(kind)?5:0))));
        style="clock".equals(format)?1:("duration".equals(format)?2:
            (conversion==4 || "grade".equals(id)?3:("heading".equals(id)?4:("float".equals(format) && !"elevation".equals(id)?5:0))));
        if("grade".equals(id)) { effect=1; }
        else if("temperature".equals(id)) { effect=2; }
        else {
            var channels=["current_heart_rate","average_heart_rate","heart_rate_3s","current_power","average_power","power_3s"];
            for(var i=0;i<channels.size();i+=1) { if(channels[i].equals(id)) { zoneChannel=i;effect=i<3?3:4;break; } }
        }
    }
}

class SnapshotEngine {
    var _power;
    var _heart;
    var _hrZones;
    var _powerZones;
    var _identity as Lang.Numeric or Null;
    var _descriptors=[];
    var _configuration;var _configurationRevision=-1;
    var _distanceStatute;var _elevationStatute;var _temperatureStatute;
    function sameText(a,b) { return a==b || (a!=null && b!=null && a.equals(b)); }
    var descriptorBuilds=0;
    var headerBuilds=0;
    var formatBuilds=0;
    var recordBuilds=0;var effectBuilds=0;var zoneBuilds=0;
    // Six fixed channels share results across duplicate slots and numeric zone fields.
    var _zoneReadings=new [6];var _zoneBounds=new [6];var _zoneResults=new [6];var _zoneReady=[false,false,false,false,false,false];
    function zone(channel,value) {
        var bounds=channel<3?_hrZones:_powerZones;
        if(!_zoneReady[channel] || _zoneReadings[channel]!=value || _zoneBounds[channel]!=bounds) {
            _zoneResults[channel]=ZoneMetadata.classifyValidated(value,bounds);
            _zoneReadings[channel]=value;_zoneBounds[channel]=bounds;_zoneReady[channel]=true;zoneBuilds+=1;
        }
        return _zoneResults[channel];
    }
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
        var statute=d.conversion==3?elevationStatute:(d.conversion==4?temperatureStatute:
            ((d.conversion==1 || d.conversion==2) && distanceStatute));
        if(d.hide!=hideUnits || d.statute!=statute) {
            var units=FieldPresentation.headerUnits(kind);
            var unit=units[statute && units.size()>1?1:0];
            var label=d.index==null?"field":Catalog.LABELS[d.index];
            var override=d.index==null?null:Catalog.HEADERS_WITH_UNITS[d.index];
            d.label=FieldPresentation.headerText(label,unit,override,hideUnits);
            if(d.style==1) { d.am=d.label+" | am";d.pm=d.label+" | pm"; }
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
        raw["heart_rate_zone"]=zone(0,heart);
        raw["power_zone"]=zone(3,watts);
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
        var configure=_configuration!=settings || _configurationRevision!=settings.revision ||
            _distanceStatute!=distanceStatute || _elevationStatute!=elevationStatute || _temperatureStatute!=temperatureStatute;
        var values=[] as Lang.Array;
        for(var i=0;i<10;i+=1) {
            var d=configure?descriptor(i,settings.slots[i],settings.hideValueUnits,distanceStatute,elevationStatute,temperatureStatute):_descriptors[i];
            var value=rawValue(raw,d.id);
            var label=d.label;var unit="";
            var reading=value;var text=null;var expandedUnit=null;
            if(d.ready && d.reading==reading && (d.style!=1 ||
                (d.hour==hour && d.minute==minute && d.clock24==clock24 && d.hasSample==hasSample))) {
                value=d.converted;label=d.lastLabel;text=d.text;unit=d.unit;expandedUnit=d.expanded;
            } else {
            if(d.conversion==1) { value=Formatting.speed(value,distanceStatute); }
            else if(d.conversion==2) { value=Formatting.distance(value,distanceStatute); }
            else if(d.conversion==3) { value=Formatting.elevation(value,elevationStatute); }
            else if(d.conversion==4) { value=Formatting.temperature(value,temperatureStatute); }
            else if(d.conversion==5) { value=Formatting.degrees(value); }
            // DVS-36: cardinal text is optional when the measured group fits.
            var cardinal=d.style==4?Formatting.cardinal(value):null;
            expandedUnit=cardinal==null?null:unit+(unit.length()>0?" ":"")+cardinal;
            if(d.style==1) {
                if(hasSample && clock!=null && clock has :hour && clock has :min) {
                    text=Formatting.clock(clock.hour,clock.min,clock24);
                    if(text!=null && !clock24) { label=clock.hour<12?d.am:d.pm; }
                }
            }
            else if(d.style==2) {
                var duration=Formatting.durationParts(value,PresentationPolicy.PAD_LEADING_MINUTES);
                text=duration[0]; unit=duration[1];
            }
            else if(d.style==3) {
                text=Formatting.fixed(value,1);
            }
            else { text=d.style==4?Formatting.heading(value):(d.style==5?Formatting.floating(value):Formatting.integral(value)); }
            d.ready=true;d.reading=reading;d.converted=value;d.lastLabel=label;
            d.text=text;d.unit=unit;d.expanded=expandedUnit;
            if(d.style==1) { d.hour=hour;d.minute=minute;d.clock24=clock24;d.hasSample=hasSample; }
            formatBuilds+=1;
            }
            var band=null; var angle=null;
            if(settings.effects[i] && value!=null && d.effect!=0) {
                var bounds=d.effect==3?_hrZones:(d.effect==4?_powerZones:null);
                if(!d.effectReady || d.effectReading!=reading || d.effectBounds!=bounds) {
                    d.effectBand=null;d.effectAngle=null;
                    if(d.effect==1) { d.effectBand=Effects.gradeBand(reading);d.effectAngle=Effects.horizonAngle(reading); }
                    else if(d.effect==2) { d.effectBand=Effects.temperatureBand(reading); }
                    else { d.effectBand=Effects.zoneColor(zone(d.zoneChannel,reading)); }
                    d.effectReady=true;d.effectReading=reading;d.effectBounds=bounds;effectBuilds+=1;
                }
                band=d.effectBand;angle=d.effectAngle;
            }
            // Valid semantic effects win; every enabled known field has a gray default.
            if(settings.effects[i] && d.index!=null && band==null) {
                band=FieldPresentation.effectiveNight(night,i<settings.enlarged,settings.inverseEnlargedTheme)?"dark_gray":"light_gray";
                angle=null;
            }
            var old=d.record;
            if(old==null || !sameText(old[:label],label) || !sameText(old[:text],text) || !sameText(old[:unit],unit) ||
                !sameText(old[:expandedUnit],expandedUnit) || !sameText(old[:band],band) || old[:angle]!=angle) {
                d.record={:label=>label,:text=>text,:unit=>unit,:expandedUnit=>expandedUnit,:band=>band,:angle=>angle,:format=>d.format};
                recordBuilds+=1;
            }
            values.add(d.record); // Never mutate a record retained by an earlier snapshot.
        }
        _configuration=settings;_configurationRevision=settings.revision;
        _distanceStatute=distanceStatute;_elevationStatute=elevationStatute;_temperatureStatute=temperatureStatute;
        return {:values=>values,:night=>night,:raw=>raw,:hasSample=>hasSample,:inverse=>settings.inverseEnlargedTheme};
    }
}
