using Toybox.System;
// APP-37/48: bounded counters; values are observations, never fabricated qualification.
module RuntimeMetrics {
    var enabled=false;
    var maxComputeMs=0;
    var deadlineMisses=0;
    var maxUsedBytes=0;
    var minFreeBytes=null;
    var maxTotalBytes=0;
    function sampleCompute(elapsed) {
        if(!enabled) { return; }
        if(elapsed>maxComputeMs) { maxComputeMs=elapsed; }
        if(elapsed>=1000) { deadlineMisses+=1; }
        var stats=System.getSystemStats();
        if(stats has :usedMemory && stats.usedMemory>maxUsedBytes) { maxUsedBytes=stats.usedMemory; }
        if(stats has :freeMemory && (minFreeBytes==null || stats.freeMemory<minFreeBytes)) { minFreeBytes=stats.freeMemory; }
        if(stats has :totalMemory && stats.totalMemory>maxTotalBytes) { maxTotalBytes=stats.totalMemory; }
    }
}
