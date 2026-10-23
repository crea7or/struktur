using Toybox.System;
using Toybox.WatchUi;

// App callbacks only: no synthetic inputs, fixture settings, matrix or switching
// state. This is an observed app build, not an uninstrumented heap measurement.
(:memoryNative)
class MemoryNativeField extends StrukturField {
    var _started;var _computes=0;var _draws=0;var _done=false;
    function initialize() {
        _started=System.getTimer();StrukturField.initialize();
        MemoryObservation.sample("initialized");
    }
    function compute(info) {
        StrukturField.compute(info);_computes+=1;MemoryObservation.sample("native_compute");
    }
    function onLayout(dc) {StrukturField.onLayout(dc);MemoryObservation.sample("native_layout");}
    function onUpdate(dc) {
        if(_done) {return;}
        StrukturField.onUpdate(dc);
        _draws+=1;MemoryObservation.sample(_draws<=3?"startup_draw":"native_draw");
        if(_computes>=10 && _draws>=3 && System.getTimer()-_started>=30000) {
            _done=true;_renderer.discardPresentation();_snapshot=null;MemoryObservation.report();
            System.println("DF_NATIVE_MEMORY_DONE product="+DeviceProfile.ID+
                " samples="+MemoryObservation.samples+" max_used="+MemoryObservation.maximum+
                " min_free="+MemoryObservation.minimum+" total_low="+MemoryObservation.totalLow+
                " total_high="+MemoryObservation.totalHigh+" native_compute="+_computes+
                " native_draw="+_draws+" elapsed_ms="+(System.getTimer()-_started));
        }
        WatchUi.requestUpdate();
    }
}
