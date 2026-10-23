using Toybox.WatchUi;
// Profile-specific source keeps API 5.2.2 symbols out of legacy binaries.
class LapAwareDataField extends WatchUi.DataField {
    function initialize() { DataField.initialize(); }
    function typedLapSupported() { return true; }
    function onLapNotification(manual) {}
    function onTimerLap2(trigger) {
        var manual=trigger!=null && trigger.hasKey(:lapTrigger) && trigger[:lapTrigger]==WatchUi.DataField.LAP_TRIGGER_MANUAL;
        onLapNotification(manual);return true;
    }
}
