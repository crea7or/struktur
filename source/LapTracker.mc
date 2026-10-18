using Toybox.Lang;
// DVS-39: one total per continuously observed app/activity, independent of rolling samples.
class LapTracker {
    const UNKNOWN=0;
    const FRESH_READY=1;
    const TRACKING=2;
    var _state as Lang.Number=UNKNOWN;
    var _count as Lang.Number=0;
    var _freshSnapshot as Lang.Boolean=false;
    var _identity as Lang.Numeric or Null;
    var _lastTimer as Lang.Numeric or Null;
    var _lastElapsed as Lang.Numeric or Null;
    var _lastDistance as Lang.Numeric or Null;
    function initialize() { invalidate(); }
    function invalidate() {
        _state=UNKNOWN; _count=0; _freshSnapshot=false; _identity=null;
        _lastTimer=null; _lastElapsed=null; _lastDistance=null;
    }
    function onReset() { invalidate(); _state=FRESH_READY; }
    function ready() { return _state==FRESH_READY; }
    function onStart() {
        if(_state==FRESH_READY) { _state=TRACKING; _count=0; _freshSnapshot=false; }
    }
    function onLap() {
        if(_state!=TRACKING) { return; }
        if(_count>=2147483647) { invalidate(); return; } // unavailable instead of wrapping
        _count+=1;
    }
    // DVS-39: a clean pre-start snapshot readies the baseline; start establishes zero.
    function value() { return _state==TRACKING?_count:null; }
    function observe(startPresent,identity,off,timerMs,elapsedMs,distance) {
        var complete=startPresent && identity==null && off==true && Numeric.finite(timerMs) && timerMs==0 &&
            Numeric.finite(elapsedMs) && elapsedMs==0 && Numeric.finite(distance) && distance==0;
        if(_state==TRACKING) {
            var regressed=false;
            var bound=_identity;
            if(bound!=null) { if(identity!=null) { if(identity!=bound) { regressed=true; } } }
            if(Numeric.finite(timerMs)) { if(_lastTimer!=null) { if(timerMs<_lastTimer) { regressed=true; } } }
            if(Numeric.finite(elapsedMs)) { if(_lastElapsed!=null) { if(elapsedMs<_lastElapsed) { regressed=true; } } }
            if(Numeric.finite(distance)) { if(_lastDistance!=null) { if(distance<_lastDistance) { regressed=true; } } }
            if(regressed) {
                invalidate(); // require a new reset/fresh sequence, never retain a partial total
                return null;
            }
            if(identity!=null) { _identity=identity; }
            if(Numeric.finite(timerMs)) { _lastTimer=timerMs; }
            if(Numeric.finite(elapsedMs)) { _lastElapsed=elapsedMs; }
            if(Numeric.finite(distance)) { _lastDistance=distance; }
        } else if(complete) {
            _state=FRESH_READY; _freshSnapshot=true; _count=0;
        } else if(_state==FRESH_READY && _freshSnapshot) {
            // A clean snapshot followed by an active sample without observing start
            // cannot prove callback continuity. A reset-ready path waits for start.
            invalidate();
        }
        return value();
    }
}
