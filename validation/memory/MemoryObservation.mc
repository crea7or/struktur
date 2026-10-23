using Toybox.System;
using Toybox.Lang;

// Qualification-only fixed counters. The measured critical path performs no I/O
// or diagnostic formatting; native console output itself can exhaust low heap.
module MemoryObservation {
    var samples=0;var maximum=0;var minimum=null;var totalLow=null;var totalHigh=0;
    var initializedUsed=null;var startupUsed=null;var maximumStage=null;
    function sample(stage) {
        var stats=System.getSystemStats();
        var used=stats.usedMemory;var free=stats.freeMemory;var total=stats.totalMemory;
        stats=null;
        samples+=1;
        if(used>maximum) {maximum=used;maximumStage=stage;}
        if(minimum==null || free<minimum) {minimum=free;}
        if(totalLow==null || total<totalLow) {totalLow=total;}
        if(total>totalHigh) {totalHigh=total;}
        if(initializedUsed==null && "initialized".equals(stage)) {initializedUsed=used;}
        if(startupUsed==null && "startup_draw".equals(stage)) {startupUsed=used;}
        if(total<=0 || total>DeviceProfile.MEMORY_LIMIT || used>total || used>DeviceProfile.MEMORY_LIMIT || free<0) {
            throw new Lang.InvalidValueException("Data Field allocation/limit violation");
        }
        return used;
    }
    // Called after fixture temporaries have returned, in the reference state.
    function report() {
        System.print("DF_MEMORY_OBSERVER product=");System.print(DeviceProfile.ID);
        System.print(" initial_used=");System.print(initializedUsed);
        System.print(" startup_used=");System.print(startupUsed);
        System.print(" peak_stage=");System.println(maximumStage);
    }
}
