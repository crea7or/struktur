using Toybox.Activity;
using Toybox.Time;
using Toybox.Lang;

// FUNC-10: a bounded, channel-local trapezoidal accumulator.
class LapMean {
    var _sum=0.0d;
    var _covered=0.0d;
    var _previous as Lang.Array or Null;
    var _failed=false;
    var _positive;
    function initialize(positive) { _positive=positive; }
    function reset() { _sum=0.0d; _covered=0.0d; _previous=null; _failed=false; }
    function breakInterval() { _previous=null; }
    function push(value,elapsed,timer,running) {
        if(_failed) { return; }
        if(!running || !Numeric.finite(value) || value<0 || (_positive && value==0) ||
            !Numeric.finite(elapsed) || elapsed<0 || !Numeric.finite(timer) || timer<0) { breakInterval(); return; }
        if(_previous!=null) {
            var dt=elapsed-_previous[1]; var active=timer-_previous[2];
            if(dt<=0) { return; } // never replace a newer endpoint with an older/duplicate one
            if(dt<=2000 && active>0 && active<=dt) {
                _sum+=((_previous[0].toDouble()+value.toDouble())/2.0)*active;
                _covered+=active;
                if(!Numeric.finite(_sum) || !Numeric.finite(_covered)) { _failed=true; breakInterval(); return; }
            }
        }
        _previous=[value,elapsed,timer];
    }
    function value() { return !_failed && _covered>0?_sum/_covered:null; }
}

// FUNC-9: current lap is independent of the historical completed-lap total.
class CurrentLap {
    var _distanceBase as Lang.Numeric or Null;
    var _timerBase as Lang.Numeric or Null;
    var _identity as Lang.Numeric or Null;
    var _lastDistance as Lang.Numeric or Null;
    var _lastTimer as Lang.Numeric or Null;
    var _lastElapsed as Lang.Numeric or Null;
    var _distance as Lang.Numeric or Null;
    var _time as Lang.Numeric or Null;
    var _paused=false;
    var _acceptBoundary=true;
    var _speedFailed=false;
    var _heart;
    var _power;
    var _cadence;
    function initialize() { _heart=new LapMean(true); _power=new LapMean(false); _cadence=new LapMean(false); }
    function clear() {
        _distanceBase=null; _timerBase=null; _identity=null;
        _lastDistance=null; _lastTimer=null; _lastElapsed=null;
        _distance=null; _time=null;
        _speedFailed=false;
        _heart.reset(); _power.reset(); _cadence.reset();
    }
    function end() { clear(); _acceptBoundary=false; _paused=true; }
    function fresh() {
        clear(); _acceptBoundary=true; _paused=false;
        _distanceBase=0; _timerBase=0; _distance=0; _time=0;
        _lastDistance=0; _lastTimer=0; _lastElapsed=0;
    }
    function pause() { _paused=true; breakIntervals(); }
    function resume() { _paused=false; breakIntervals(); }
    function breakIntervals() { _heart.breakInterval(); _power.breakInterval(); _cadence.breakInterval(); }
    function counter(value) { return Numeric.finite(value) && value>=0?value:null; }
    function identity(info) {
        return info!=null && info has :startTime && info.startTime instanceof Time.Moment?info.startTime.value():null;
    }
    function boundary(info) {
        if(!_acceptBoundary) { return; }
        clear();
        if(info==null) { return; }
        _identity=identity(info);
        _distanceBase=info has :elapsedDistance?counter(info.elapsedDistance):null;
        _timerBase=info has :timerTime?counter(info.timerTime):null;
        _lastDistance=_distanceBase; _lastTimer=_timerBase;
        _lastElapsed=info has :elapsedTime?counter(info.elapsedTime):null;
        _distance=_distanceBase!=null?0:null; _time=_timerBase!=null?0:null;
        // Seed only; no weighted integration occurs in the callback.
        channels(info,_lastElapsed,_lastTimer,_timerBase!=null && !_paused && info has :timerState && info.timerState==Activity.TIMER_STATE_ON);
    }
    function channels(info,elapsed,timer,running) {
        _heart.push(info has :currentHeartRate?info.currentHeartRate:null,elapsed,timer,running);
        _power.push(info has :currentPower?info.currentPower:null,elapsed,timer,running);
        _cadence.push(info has :currentCadence?info.currentCadence:null,elapsed,timer,running);
    }
    function read(info,raw,activityIdentity) {
        var elapsed=info has :elapsedTime?counter(info.elapsedTime):null;
        var timer=info has :timerTime?counter(info.timerTime):null;
        var distance=info has :elapsedDistance?counter(info.elapsedDistance):null;
        // Local copies also avoid SDK 9.2's nullable-member flow-merge crash.
        var oldIdentity=_identity; var oldElapsed=_lastElapsed;
        var changed=false;
        if(oldIdentity!=null) { if(activityIdentity!=null) { if(oldIdentity!=activityIdentity) { changed=true; } } }
        if(oldElapsed!=null) { if(elapsed!=null) { if(elapsed<oldElapsed) { changed=true; } } }
        if(changed) { clear(); }
        if(activityIdentity!=null) { _identity=activityIdentity; }
        var oldTimer=_lastTimer;var oldDistance=_lastDistance;
        var timerRegressed=false; var distanceRegressed=false;
        if(oldTimer!=null) { if(timer!=null) { if(timer<oldTimer) { timerRegressed=true; } } }
        if(oldDistance!=null) { if(distance!=null) { if(distance<oldDistance) { distanceRegressed=true; } } }
        if(timerRegressed) {
            _timerBase=null; _heart.reset(); _power.reset(); _cadence.reset();
        }
        if(distanceRegressed) { _distanceBase=null; }
        if(distance!=null) { _lastDistance=distance; }
        if(timer!=null) { _lastTimer=timer; }
        if(elapsed!=null) { _lastElapsed=elapsed; }
        _distance=_distanceBase!=null && distance!=null?counter(distance-_distanceBase):null;
        _time=_timerBase!=null && timer!=null?counter(timer-_timerBase):null;
        channels(info,elapsed,timer,_timerBase!=null && !_paused && info has :timerState && info.timerState==Activity.TIMER_STATE_ON);
        publish(raw);
    }
    function publish(raw) {
        raw["lap_distance"]=_distance; raw["lap_time"]=_time;
        var speed=null;
        if(!_speedFailed && _distance!=null && _time!=null && _time>0) {
            speed=_distance/(_time/1000.0);
            if(!Numeric.finite(speed)) { _speedFailed=true; }
        }
        raw["lap_speed"]=Numeric.finite(speed)?speed:null;
        raw["lap_heart_rate"]=_time!=null?_heart.value():null;
        raw["lap_power"]=_time!=null?_power.value():null;
        raw["lap_cadence"]=_time!=null?_cadence.value():null;
    }
}
