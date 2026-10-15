using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.System;

// APP-33: initial view constructs a safe snapshot before compute/onUpdate.
(:background)
class StrukturApp extends Application.AppBase {
    var _view;
    var _temperature;
    (:background)
    function initialize() { AppBase.initialize(); }
    // Garmin calls onStart in both processes. Foreground-only classes are unavailable in background.
    function onStart(state) {}
    (:background)
    function getServiceDelegate() { return [new TemperatureService()]; }
    function onBackgroundData(data) {
        if(_temperature==null) { _temperature=new TemperatureCache(); }
        _temperature.receive(data,Time.now().value(),System.getTimer(),TemperatureQualification.current());
        if(_view!=null) { _view.refreshPresentation(); }
        WatchUi.requestUpdate();
    }
    function temperatureValue() { return _temperature==null || !_temperature.hasValue()?null:_temperature.value(Time.now().value(),System.getTimer()); }
    function onStop(state) { if(_view!=null) { _view.resetSamples(); _view._acquisition.currentLap.end(); } }
    function getInitialView() {
        if(_temperature==null) { _temperature=new TemperatureCache(); }
        TemperatureSchedule.start();
        _view=new StrukturField(); return [_view];
    }
    function onSettingsChanged() { if(_view!=null) { _view.reloadSettings(); } WatchUi.requestUpdate(); }
    function onNightModeChanged() { if(_view!=null) { _view.refreshPresentation(); } WatchUi.requestUpdate(); }
}
