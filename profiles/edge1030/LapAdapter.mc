using Toybox.WatchUi;
// Profile-specific source keeps API 5.2.2 symbols out of legacy binaries.
class LapAwareDataField extends WatchUi.DataField {
    function initialize() { DataField.initialize(); }
    function typedLapSupported() { return false; }
    function onLapNotification(manual) {}
}
