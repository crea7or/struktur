using Toybox.Graphics;
using Toybox.System;
using Toybox.Test;
using Toybox.WatchUi;

// An isolated resource-load measurement, not full Data Field qualification.
(:test)
function profileFontLoad(logger) {
    var initial=System.getSystemStats();
    var baselineUsed=initial.usedMemory;
    initial=null;
    var large=WatchUi.loadResource(FontSelection.info(DeviceProfile.BIG_SIZE,false)[0]);
    var regular=WatchUi.loadResource(FontSelection.info(DeviceProfile.REGULAR_SIZE,false)[0]);
    var label=WatchUi.loadResource(FontSelection.info(DeviceProfile.LABEL_SIZE,true)[0]);
    Test.assert(Graphics.getFontHeight(large)>0);
    Test.assert(Graphics.getFontHeight(regular)>0);
    Test.assert(Graphics.getFontHeight(label)>0);
    var loaded=System.getSystemStats();
    logger.debug("FONT_MEMORY product="+DeviceProfile.ID+" baseline_used="+baselineUsed.toString()+
        " loaded_used="+loaded.usedMemory.toString()+" free="+loaded.freeMemory.toString()+
        " total="+loaded.totalMemory.toString());
    Test.assert(loaded.usedMemory<=loaded.totalMemory && loaded.usedMemory<=DeviceProfile.MEMORY_LIMIT);
    return true;
}

// SPEC-177: compile and exercise exactly the three profile resources.
// This checks loading independently of the three-font memory sample above.
(:test)
function allFontVariantsLoad(logger) {
    var resources=[FontSelection.info(DeviceProfile.BIG_SIZE,false)[0],
        FontSelection.info(DeviceProfile.REGULAR_SIZE,false)[0],FontSelection.info(DeviceProfile.LABEL_SIZE,true)[0]];
    Test.assertEqual(3,resources.size());
    for(var i=0;i<resources.size();i+=1) {
        var font=WatchUi.loadResource(resources[i]);
        Test.assert(Graphics.getFontHeight(font)>0);
        font=null;
    }
    logger.debug("FONT_VARIANTS product="+DeviceProfile.ID+" loaded="+resources.size().toString());
    return true;
}
