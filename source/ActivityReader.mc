using Toybox.System;
using Toybox.Lang;
// SPEC-156: explicit optional Activity.Info members, raw producer units.
module ActivityReader {
    function read(info) as Lang.Dictionary {
        var raw = {} as Lang.Dictionary;
        if (info has :currentSpeed) { raw["current_speed"] = Numeric.finite(info.currentSpeed) ? info.currentSpeed : null; }
        if (info has :averageSpeed) { raw["average_speed"] = Numeric.finite(info.averageSpeed) ? info.averageSpeed : null; }
        if (info has :currentCadence) { raw["current_cadence"] = Numeric.finite(info.currentCadence) ? info.currentCadence : null; }
        if (info has :averageCadence) { raw["average_cadence"] = Numeric.finite(info.averageCadence) ? info.averageCadence : null; }
        if (info has :currentHeartRate) { raw["current_heart_rate"] = Numeric.finite(info.currentHeartRate) ? info.currentHeartRate : null; }
        if (info has :averageHeartRate) { raw["average_heart_rate"] = Numeric.finite(info.averageHeartRate) ? info.averageHeartRate : null; }
        if (info has :currentPower) { raw["current_power"] = Numeric.finite(info.currentPower) ? info.currentPower : null; }
        if (info has :averagePower) { raw["average_power"] = Numeric.finite(info.averagePower) ? info.averagePower : null; }
        if (info has :elapsedDistance) { raw["distance"] = Numeric.finite(info.elapsedDistance) ? info.elapsedDistance : null; }
        if (info has :altitude) { raw["elevation"] = Numeric.finite(info.altitude) ? info.altitude : null; }
        if (info has :totalAscent) { raw["total_ascent"] = Numeric.finite(info.totalAscent) ? info.totalAscent : null; }
        if (info has :totalDescent) { raw["total_descent"] = Numeric.finite(info.totalDescent) ? info.totalDescent : null; }
        if (info has :timerTime) { raw["activity_timer"] = Numeric.finite(info.timerTime) ? info.timerTime : null; }
        if (info has :elapsedTime) { raw["elapsed_time"] = Numeric.finite(info.elapsedTime) ? info.elapsedTime : null; }
        if (info has :calories) { raw["calories"] = Numeric.finite(info.calories) ? info.calories : null; }
        if (info has :currentHeading) { raw["heading"] = Numeric.finite(info.currentHeading) ? info.currentHeading : null; }
        if (info has :distanceToNextPoint) { raw["distance_next_waypoint"] = Numeric.finite(info.distanceToNextPoint) ? info.distanceToNextPoint : null; }
        var stats=System.getSystemStats();
        raw["battery"] = stats has :battery && Numeric.finite(stats.battery) && stats.battery>=0 && stats.battery<=100 ? stats.battery : null;
        // Stateful acquisition is applied once by ActivityAcquisition and the app temperature cache.
        raw["grade"] = null; raw["completed_laps"] = null; raw["temperature"] = null;
        return raw;
    }
}
