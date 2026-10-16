using Toybox.System;
using Toybox.Lang;
// Physical qualification evidence only. Runtime checks are in TemperatureSource.
(:background)
module TemperatureQualification {
    const TARGETS = [];
    function qualified(part,firmware) {
        if(!(part instanceof Lang.String) || !(firmware instanceof Lang.Array) || firmware.size()!=2) { return false; }
        return false;
    }
    function current() {
        var device=System.getDeviceSettings();
        return device has :partNumber && device has :firmwareVersion && qualified(device.partNumber,device.firmwareVersion);
    }
}
