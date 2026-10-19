using Toybox.System;
using Toybox.Time;
using Toybox.UserProfile;
using Toybox.Activity;
using Toybox.Lang;
using Toybox.Math;

// Fixed-shape slot state avoids a hash table per cached field on the shared heap.
// Published snapshots remain separate objects; the cache never mutates old readings.
// Packed slot descriptors avoid per-instance member tables on legacy shared heaps.
module ValueRecord {
    const LABEL=0;const TEXT=1;const UNIT=2;const EXPANDEDUNIT=3;const BAND=4;const ANGLE=5;const FORMAT=6;const COVERAGE=7;
}
module SnapshotDescriptor {
    const ID=0;const INDEX=1;const KIND=2;const FORMAT=3;const HIDE=4;const STATUTE=5;const LABEL=6;const AM=7;const PM=8;const READY=9;const READING=10;const CONVERTED=11;const LASTLABEL=12;const TEXT=13;const UNIT=14;const EXPANDED=15;const HOUR=16;const MINUTE=17;const CLOCK24=18;const HASSAMPLE=19;const CONVERSION=20;const STYLE=21;const EFFECT=22;const ZONECHANNEL=23;const RECORD=24;const EFFECTREADY=25;const EFFECTREADING=26;const EFFECTBOUNDS=27;const EFFECTBAND=28;const EFFECTANGLE=29;const EFFECTINPUT=30;
    function create(fieldId,fieldIndex) {
        var d=new [31];
        d[SnapshotDescriptor.HIDE]=null;d[SnapshotDescriptor.STATUTE]=null;d[SnapshotDescriptor.READY]=false;d[SnapshotDescriptor.CONVERSION]=0;d[SnapshotDescriptor.STYLE]=0;d[SnapshotDescriptor.EFFECT]=0;d[SnapshotDescriptor.ZONECHANNEL]=-1;d[SnapshotDescriptor.EFFECTREADY]=false;
        d[SnapshotDescriptor.ID]=fieldId;d[SnapshotDescriptor.INDEX]=fieldIndex;
        d[SnapshotDescriptor.KIND]=d[SnapshotDescriptor.INDEX]==null?"":Catalog.UNITS[d[SnapshotDescriptor.INDEX]];
        d[SnapshotDescriptor.FORMAT]=d[SnapshotDescriptor.INDEX]==null?"integer":Catalog.FORMATS[d[SnapshotDescriptor.INDEX]];
        // Flat branches bound temporary stack use when rebuilding a bank in a lap callback.
        if("speed".equals(d[SnapshotDescriptor.KIND])) { d[SnapshotDescriptor.CONVERSION]=1; }
        else if("distance".equals(d[SnapshotDescriptor.KIND])) { d[SnapshotDescriptor.CONVERSION]=2; }
        else if("elevation".equals(d[SnapshotDescriptor.KIND])) { d[SnapshotDescriptor.CONVERSION]=3; }
        else if("temperature".equals(d[SnapshotDescriptor.KIND])) { d[SnapshotDescriptor.CONVERSION]=4; }
        else if("degrees".equals(d[SnapshotDescriptor.KIND])) { d[SnapshotDescriptor.CONVERSION]=5; }
        if("text".equals(d[SnapshotDescriptor.FORMAT])) { d[SnapshotDescriptor.STYLE]=6; }
        else if("clock".equals(d[SnapshotDescriptor.FORMAT])) { d[SnapshotDescriptor.STYLE]=1; }
        else if("duration".equals(d[SnapshotDescriptor.FORMAT])) { d[SnapshotDescriptor.STYLE]=2; }
        else if(d[SnapshotDescriptor.CONVERSION]==4 || "grade".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.STYLE]=3; }
        else if("heading".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.STYLE]=4; }
        else if("float".equals(d[SnapshotDescriptor.FORMAT]) && !"elevation".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.STYLE]=5; }
        if("grade".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.EFFECT]=1; }
        else if("temperature".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.EFFECT]=2; }
        else {
            if("current_heart_rate".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=0; }
            else if("average_heart_rate".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=1; }
            else if("heart_rate_3s".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=2; }
            else if("current_power".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=3; }
            else if("average_power".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=4; }
            else if("power_3s".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=5; }
            else if("lap_heart_rate".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=6; }
            else if("lap_power".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=7; }
            else if("current_cadence".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=8; }
            else if("average_cadence".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=9; }
            else if("lap_cadence".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.ZONECHANNEL]=10; }
            if(d[SnapshotDescriptor.ZONECHANNEL]>=0) { d[SnapshotDescriptor.EFFECT]=3; }
            else if("heart_rate_zone".equals(d[SnapshotDescriptor.ID]) || "power_zone".equals(d[SnapshotDescriptor.ID])) { d[SnapshotDescriptor.EFFECT]=5; }
        }
        return d;
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
    // Eleven fixed channels share results across duplicate slots and numeric zone fields.
    var _zoneReadings=new [11];var _zoneBounds=new [11];var _zoneResults=new [11];var _zoneReady=[false,false,false,false,false,false,false,false,false,false,false];
    var _cadenceZones=null;
    function boundsFor(channel) { return channel>=8?_cadenceZones:(channel<3 || channel==6?_hrZones:_powerZones); }
    function zone(channel,value) {
        var bounds=boundsFor(channel);
        if(!_zoneReady[channel] || _zoneReadings[channel]!=value || _zoneBounds[channel]!=bounds) {
            _zoneResults[channel]=channel>=8?CadenceZones.classify(value,bounds):ZoneMetadata.classifyValidated(value,bounds);
            _zoneReadings[channel]=value;_zoneBounds[channel]=bounds;_zoneReady[channel]=true;zoneBuilds+=1;
        }
        return _zoneResults[channel];
    }
    function initialize() { _power=new RollingWindow(1); _heart=new RollingWindow(3); _hrZones=null; _powerZones=null; }
    // Ten bounded assignment caches, separate from the published snapshot and live readings.
    function descriptor(slot,id,hideUnits,distanceStatute,elevationStatute,temperatureStatute) {
        var d=slot<_descriptors.size()?_descriptors[slot]:null;
        if(d==null || !d[SnapshotDescriptor.ID].equals(id)) {
            var index=Catalog.index(id);
            d=SnapshotDescriptor.create(id,index);
            if(slot<_descriptors.size()) { _descriptors[slot]=d; } else { _descriptors.add(d); }
            descriptorBuilds+=1;
        }
        var kind=d[SnapshotDescriptor.KIND];
        var statute=d[SnapshotDescriptor.CONVERSION]==3?elevationStatute:(d[SnapshotDescriptor.CONVERSION]==4?temperatureStatute:
            ((d[SnapshotDescriptor.CONVERSION]==1 || d[SnapshotDescriptor.CONVERSION]==2) && distanceStatute));
        if(d[SnapshotDescriptor.HIDE]!=hideUnits || d[SnapshotDescriptor.STATUTE]!=statute) {
            var units=FieldPresentation.headerUnits(kind);
            var unit=units[statute && units.size()>1?1:0];
            var label=d[SnapshotDescriptor.INDEX]==null?"field":Catalog.LABELS[d[SnapshotDescriptor.INDEX]];
            var override=d[SnapshotDescriptor.INDEX]==null?null:Catalog.HEADERS_WITH_UNITS[d[SnapshotDescriptor.INDEX]];
            d[SnapshotDescriptor.LABEL]=FieldPresentation.headerText(label,unit,override,hideUnits);
            if(d[SnapshotDescriptor.STYLE]==1) { d[SnapshotDescriptor.AM]=d[SnapshotDescriptor.LABEL]+" | am";d[SnapshotDescriptor.PM]=d[SnapshotDescriptor.LABEL]+" | pm"; }
            d[SnapshotDescriptor.HIDE]=hideUnits;d[SnapshotDescriptor.STATUTE]=statute;headerBuilds+=1;
            d[SnapshotDescriptor.READY]=false;
        }
        return d;
    }
    function configureTeam(d,settings) {
        var channel=settings.teamSource==1?3:(settings.teamSource==2?0:-1);
        if(d[SnapshotDescriptor.ZONECHANNEL]!=channel) { d[SnapshotDescriptor.EFFECTREADY]=false; }
        d[SnapshotDescriptor.ZONECHANNEL]=channel;d[SnapshotDescriptor.EFFECT]=channel>=0?3:0;
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
        advance(raw);return prepare(raw,settings,true);
    }
    function advance(raw as Lang.Dictionary) {
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
        _cadenceZones=settings.cadenceBounds;
        var values=[] as Lang.Array;
        for(var i=0;i<10;i+=1) {
            var d=configure?descriptor(i,settings.slots[i],settings.hideValueUnits,distanceStatute,elevationStatute,temperatureStatute):_descriptors[i];
            if(d[SnapshotDescriptor.STYLE]==6 && configure) { configureTeam(d,settings); }
            var value=d[SnapshotDescriptor.STYLE]==6?settings.teamText:rawValue(raw,d[SnapshotDescriptor.ID]);
            // A profile refresh can occur between delivered samples. Reuse the
            // current-source cache instead of a stale zone number in retained raw data.
            if(d[SnapshotDescriptor.EFFECT]==5) {
                if("heart_rate_zone".equals(d[SnapshotDescriptor.ID]) && raw.hasKey("current_heart_rate")) { value=zone(0,raw["current_heart_rate"]); }
                else if("power_zone".equals(d[SnapshotDescriptor.ID]) && raw.hasKey("current_power")) { value=zone(3,raw["current_power"]); }
            }
            var label=d[SnapshotDescriptor.LABEL];var unit="";
            var reading=value;var text=null;var expandedUnit=null;
            if(d[SnapshotDescriptor.READY] && d[SnapshotDescriptor.READING]==reading && (d[SnapshotDescriptor.STYLE]!=1 ||
                (d[SnapshotDescriptor.HOUR]==hour && d[SnapshotDescriptor.MINUTE]==minute && d[SnapshotDescriptor.CLOCK24]==clock24 && d[SnapshotDescriptor.HASSAMPLE]==hasSample))) {
                value=d[SnapshotDescriptor.CONVERTED];label=d[SnapshotDescriptor.LASTLABEL];text=d[SnapshotDescriptor.TEXT];unit=d[SnapshotDescriptor.UNIT];expandedUnit=d[SnapshotDescriptor.EXPANDED];
            } else {
            if(d[SnapshotDescriptor.CONVERSION]==1) { value=Formatting.speed(value,distanceStatute); }
            else if(d[SnapshotDescriptor.CONVERSION]==2) { value=Formatting.distance(value,distanceStatute); }
            else if(d[SnapshotDescriptor.CONVERSION]==3) { value=Formatting.elevation(value,elevationStatute); }
            else if(d[SnapshotDescriptor.CONVERSION]==4) { value=Formatting.temperature(value,temperatureStatute); }
            else if(d[SnapshotDescriptor.CONVERSION]==5) { value=Formatting.degrees(value); }
            // DVS-36: cardinal text is optional when the measured group fits.
            var cardinal=d[SnapshotDescriptor.STYLE]==4?Formatting.cardinal(value):null;
            expandedUnit=cardinal==null?null:unit+(unit.length()>0?" ":"")+cardinal;
            if(d[SnapshotDescriptor.STYLE]==6) { text=value; }
            else if(d[SnapshotDescriptor.STYLE]==1) {
                if(hasSample && clock!=null && clock has :hour && clock has :min) {
                    text=Formatting.clock(clock.hour,clock.min,clock24);
                    if(text!=null && !clock24) { label=clock.hour<12?d[SnapshotDescriptor.AM]:d[SnapshotDescriptor.PM]; }
                }
            }
            else if(d[SnapshotDescriptor.STYLE]==2) {
                var duration=Formatting.durationParts(value,PresentationPolicy.PAD_LEADING_MINUTES);
                text=duration[0]; unit=duration[1];
            }
            else if(d[SnapshotDescriptor.STYLE]==3) {
                text=Formatting.fixed(value,1);
            }
            else { text=d[SnapshotDescriptor.STYLE]==4?Formatting.heading(value):(d[SnapshotDescriptor.STYLE]==5?Formatting.floating(value):Formatting.integral(value)); }
            d[SnapshotDescriptor.READY]=true;d[SnapshotDescriptor.READING]=reading;d[SnapshotDescriptor.CONVERTED]=value;d[SnapshotDescriptor.LASTLABEL]=label;
            d[SnapshotDescriptor.TEXT]=text;d[SnapshotDescriptor.UNIT]=unit;d[SnapshotDescriptor.EXPANDED]=expandedUnit;
            if(d[SnapshotDescriptor.STYLE]==1) { d[SnapshotDescriptor.HOUR]=hour;d[SnapshotDescriptor.MINUTE]=minute;d[SnapshotDescriptor.CLOCK24]=clock24;d[SnapshotDescriptor.HASSAMPLE]=hasSample; }
            formatBuilds+=1;
            }
            var band=null; var angle=null;
            if(settings.effects[i] && value!=null && d[SnapshotDescriptor.EFFECT]!=0) {
                d[SnapshotDescriptor.EFFECTINPUT]=d[SnapshotDescriptor.STYLE]==6?rawValue(raw,d[SnapshotDescriptor.ZONECHANNEL]==3?"current_power":"current_heart_rate"):reading;
                var bounds=d[SnapshotDescriptor.ZONECHANNEL]>=0?boundsFor(d[SnapshotDescriptor.ZONECHANNEL]):(d[SnapshotDescriptor.EFFECT]==5?("heart_rate_zone".equals(d[SnapshotDescriptor.ID])?_hrZones:_powerZones):null);
                if(!d[SnapshotDescriptor.EFFECTREADY] || d[SnapshotDescriptor.EFFECTREADING]!=d[SnapshotDescriptor.EFFECTINPUT] || d[SnapshotDescriptor.EFFECTBOUNDS]!=bounds) {
                    d[SnapshotDescriptor.EFFECTBAND]=null;d[SnapshotDescriptor.EFFECTANGLE]=null;
                    if(d[SnapshotDescriptor.EFFECT]==1) { d[SnapshotDescriptor.EFFECTBAND]=Effects.gradeBand(d[SnapshotDescriptor.EFFECTINPUT]);d[SnapshotDescriptor.EFFECTANGLE]=Effects.horizonAngle(d[SnapshotDescriptor.EFFECTINPUT]); }
                    else if(d[SnapshotDescriptor.EFFECT]==2) { d[SnapshotDescriptor.EFFECTBAND]=Effects.temperatureBand(d[SnapshotDescriptor.EFFECTINPUT]); }
                    else if(d[SnapshotDescriptor.EFFECT]==5) { d[SnapshotDescriptor.EFFECTBAND]=bounds!=null && reading instanceof Lang.Number && reading<bounds.size()?Effects.zoneColor(reading):null; }
                    else { d[SnapshotDescriptor.EFFECTBAND]=Effects.zoneColor(zone(d[SnapshotDescriptor.ZONECHANNEL],d[SnapshotDescriptor.EFFECTINPUT])); }
                    d[SnapshotDescriptor.EFFECTREADY]=true;d[SnapshotDescriptor.EFFECTREADING]=d[SnapshotDescriptor.EFFECTINPUT];d[SnapshotDescriptor.EFFECTBOUNDS]=bounds;effectBuilds+=1;
                }
                band=d[SnapshotDescriptor.EFFECTBAND];angle=settings.modes[i]==2?d[SnapshotDescriptor.EFFECTANGLE]:null;
            }
            // Valid semantic effects win; every enabled known field has a gray default.
            if(settings.effects[i] && d[SnapshotDescriptor.INDEX]!=null && band==null) {
                band=FieldPresentation.effectiveNight(night,i<settings.enlarged,settings.inverseEnlargedTheme)?"dark_gray":"light_gray";
                angle=null;
            }
            var old=d[SnapshotDescriptor.RECORD];
            if(old==null || !sameText(old[ValueRecord.LABEL],label) || !sameText(old[ValueRecord.TEXT],text) || !sameText(old[ValueRecord.UNIT],unit) ||
                !sameText(old[ValueRecord.EXPANDEDUNIT],expandedUnit) || !sameText(old[ValueRecord.BAND],band) || old[ValueRecord.ANGLE]!=angle || old[ValueRecord.COVERAGE]!=settings.modes[i]) {
                d[SnapshotDescriptor.RECORD]=[label,text,unit,expandedUnit,band,angle,d[SnapshotDescriptor.FORMAT],settings.modes[i]];
                recordBuilds+=1;
            }
            values.add(d[SnapshotDescriptor.RECORD]); // Never mutate a record retained by an earlier snapshot.
        }
        _configuration=settings;_configurationRevision=settings.revision;
        _distanceStatute=distanceStatute;_elevationStatute=elevationStatute;_temperatureStatute=temperatureStatute;
        return {:values=>values,:night=>night,:raw=>raw,:hasSample=>hasSample,:inverse=>settings.inverseEnlargedTheme};
    }
}
