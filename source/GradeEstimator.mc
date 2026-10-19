using Toybox.Lang;
using Toybox.Math;
// DVS-29: one bounded five-sample regression in producer metres/milliseconds.
class GradeEstimator {
    const CAPACITY=5;
    var _points as Lang.Array;
    var _head as Lang.Number=0;
    var _count as Lang.Number=0;
    var _lastTime as Lang.Numeric or Null;
    var _lastDistance as Lang.Numeric or Null;
    var _progressTime as Lang.Numeric or Null;
    var _identity as Lang.Numeric or Null;
    var _value as Lang.Numeric or Null;
    function initialize() { _points=new [CAPACITY]; reset(); }
    function clearWindow() {
        for(var i=0;i<CAPACITY;i+=1) { _points[i]=null; }
        _head=0; _count=0; _value=null;
    }
    function reset() { clearWindow(); _lastTime=null; _lastDistance=null; _progressTime=null; _identity=null; }
    function point(index) { return _points[(_head+index)%CAPACITY]; }
    function discardOldest() { _points[_head]=null; _head=(_head+1)%CAPACITY; _count-=1; }
    function sampleCount() { return _count; }
    function estimate() {
        if(_count<3) { return 0.0; }
        // Translating both axes preserves N/D and avoids cancellation at large ride totals.
        var origin=point(0);var sx=0.0d;var sy=0.0d;var sxx=0.0d;var sxy=0.0d;
        for(var i=0;i<_count;i+=1) {
            var p=point(i);var x=p[0].toDouble()-origin[0].toDouble();var y=p[1].toDouble()-origin[1].toDouble();
            sx+=x;sy+=y;sxx+=x*x;sxy+=x*y;
        }
        var d=_count*sxx-sx*sx;var n=_count*sxy-sx*sy;
        if(!Numeric.finite(sx) || !Numeric.finite(sy) || !Numeric.finite(sxx) || !Numeric.finite(sxy) ||
            !Numeric.finite(d) || !Numeric.finite(n)) { return null; }
        if(d.abs()<0.000000001d) { return 0.0; }
        if(d<0) { return null; }
        var g=100.0d*n/d;
        if(!Numeric.finite(g) || !Numeric.finite(g*100.0d)) { return null; }
        var rounded=Numeric.whole(g*100.0d)/100.0d;
        return Numeric.finite(rounded)?(rounded==0?0.0:rounded):null;
    }
    function push(altitude,distance,elapsedMs,running,identity) {
        if(running!=true || !Numeric.finite(altitude) || !Numeric.finite(distance) || distance<0 ||
           !Numeric.finite(elapsedMs) || elapsedMs<0) { reset(); return null; }
        var resetRequired=false;var oldIdentity=_identity;var previousTime=_lastTime;
        if(oldIdentity!=null) { if(identity!=null) { if(oldIdentity!=identity) { resetRequired=true; } } }
        if(previousTime!=null) {
            if(elapsedMs<previousTime || distance<_lastDistance) { resetRequired=true; }
        }
        if(resetRequired) { reset(); }
        if(identity!=null) { _identity=identity; }
        if(_lastTime!=null && elapsedMs==_lastTime) { return _value; } // ignored; no refreshed time
        if(_lastTime!=null && elapsedMs-_lastTime>2000) { clearWindow(); }
        if(_lastDistance==null || distance>_lastDistance) { _progressTime=elapsedMs; }
        _lastTime=elapsedMs;_lastDistance=distance;
        // Keep progress metadata while stalled; stationary updates cannot re-seed zero.
        if(elapsedMs-_progressTime>=3000) { clearWindow();return null; }
        if(_count>0 && Math.floor(point(_count-1)[2]/1000.0)==Math.floor(elapsedMs/1000.0)) { return _value; }
        if(_count==CAPACITY) { discardOldest(); }
        _points[(_head+_count)%CAPACITY]=[distance,altitude,elapsedMs]; _count+=1;
        _value=estimate();
        return _value;
    }
}
