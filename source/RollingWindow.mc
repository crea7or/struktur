// DVS-41/DVS-22/DVS-47: fixed three-value buffer; no retained unbounded history.
class RollingWindow {
    var _samples;
    var _count;
    var _next;
    var _lastSecond;
    var _minimumSamples;
    function initialize(minimumSamples) { _minimumSamples = minimumSamples; _samples = [0.0, 0.0, 0.0]; reset(); }
    function reset() { _count = 0; _next = 0; _lastSecond = null; }
    function push(value, second) {
        if (!Numeric.finite(value) || !Numeric.finite(second)) { reset(); return null; }
        if (_lastSecond != null && second == _lastSecond) { return average(); }
        if (_lastSecond != null && second != _lastSecond + 1) { reset(); }
        _samples[_next] = value;
        _next = (_next + 1) % 3;
        _count = _count < 3 ? _count + 1 : 3;
        _lastSecond = second;
        return average();
    }
    function average() {
        if (_count < _minimumSamples) { return null; }
        var sum = 0.0;
        // Partial windows occupy [0,count); stale buffer entries after reset are excluded.
        for (var i = 0; i < _count; i += 1) { sum += _samples[i]; }
        return sum / _count;
    }
}
