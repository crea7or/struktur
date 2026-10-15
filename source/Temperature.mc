using Toybox.Lang;
using Toybox.Time;
using Toybox.System;
using Toybox.Sensor;
using Toybox.Background;

// DVS-34: bounded foreground cache. No sensor acquisition or unit conversion here.
class TemperatureCache {
    var _value;
    var _readTime;
    var _watermark;
    var _receiptMono;
    var _deliveryAge;
    var _lastWall;
    var _lastMono;
    function initialize() {
        _value=null; _readTime=null; _watermark=null; _receiptMono=null;
        _deliveryAge=0; _lastWall=null; _lastMono=null;
    }
    function clocks(wall,mono) {
        if(!Numeric.finite(wall) || !Numeric.finite(mono) || wall<0 || mono<0) { _value=null; return false; }
        var ok=(_lastWall==null || wall>=_lastWall) && (_lastMono==null || mono>=_lastMono);
        _lastWall=wall; _lastMono=mono;
        if(!ok) { _value=null; }
        return ok;
    }
    function receive(packet,wall,mono,qualified) {
        if(!clocks(wall,mono)) { return false; }
        if(qualified!=true) { _value=null; return false; }
        if(!(packet instanceof Lang.Array) || packet.size()!=4 || !(packet[0] instanceof Lang.Number) || packet[0]!=1 ||
            !(packet[3] instanceof Lang.String) || !"onboard-v1".equals(packet[3])) { return false; }
        var stamp=packet[2];
        if(!(stamp instanceof Lang.Number) && !(stamp instanceof Lang.Long)) { return false; }
        if(stamp<0 || stamp>wall || (_watermark!=null && stamp<=_watermark)) { return false; }
        _watermark=stamp;
        _value=null;
        if(!Numeric.finite(packet[1]) || wall-stamp>360) { return false; }
        _value=packet[1]; _readTime=stamp; _receiptMono=mono; _deliveryAge=wall-stamp;
        return true;
    }
    function value(wall,mono) {
        if(!clocks(wall,mono) || _value==null) { return null; }
        if(wall-_readTime>360 || _deliveryAge+(mono-_receiptMono)/1000.0>360) { _value=null; }
        return _value;
    }
    function hasValue() { return _value!=null; }
}

(:background)
module TemperatureSchedule {
    function earliest(now,last) { return last!=null && last+300>now?last+300:now; }
    function start() {
        try {
            var last=Background.getLastTemporalEventTime();
            Background.registerForTemporalEvent(new Time.Moment(earliest(Time.now().value(),last==null?null:last.value())));
        } catch(e) {} // Unsupported/delayed service leaves the cache unavailable.
    }
}

// Only this annotated worker can touch Sensor.getInfo. No fonts/view/caches in background.
(:background)
class TemperatureService extends System.ServiceDelegate {
    function initialize() { ServiceDelegate.initialize(); }
    function onTemporalEvent() {
        var celsius=null;
        try {
            if(TemperatureQualification.current()) {
                var info=Sensor.getInfo();
                if(info has :temperature) {
                    var value=info.temperature;
                    if(Numeric.finite(value)) { celsius=value; }
                }
            }
        } catch(e) {}
        var readTime=Time.now().value();
        try { Background.registerForTemporalEvent(new Time.Duration(300)); } catch(e) {}
        Background.exit([1,celsius,readTime,"onboard-v1"]);
    }
}
