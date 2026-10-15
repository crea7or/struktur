using Toybox.WatchUi;
using Toybox.Time;
using Toybox.System;
using Toybox.Activity;
using Toybox.Application;

class StrukturField extends WatchUi.DataField {
    var _settings;
    var _engine;
    var _snapshot;
    var _renderer;
    var _layoutDirty;
    var _samplingEnabled;
    var _acquisition;
    function initialize() {
        DataField.initialize();
        _settings=new DisplaySettings(); _settings.load();
        _acquisition=new ActivityAcquisition();
        _engine=new SnapshotEngine(); _engine.metadata();
        _snapshot=_engine.initial(_settings); _renderer=new FieldRenderer(); _renderer.prepare(_snapshot); _layoutDirty=true; _samplingEnabled=false;
    }
    function compute(info) {
        processActivity(info);
    }
    // Fixture entry shares the entire delivered-sample path without subclassing SDK Info.
    function processActivity(info) {
        var started=RuntimeMetrics.enabled?System.getTimer():0;
        var raw=ActivityReader.readWithBattery(info,_settings.usesBattery);
        _acquisition.read(info,raw);
        raw["temperature"]=Application.getApp().temperatureValue();
        if(info has :timerState) { _samplingEnabled=info.timerState==Activity.TIMER_STATE_ON; }
        raw["_sampling_enabled"]=_samplingEnabled;
        var complete=_engine.compute(raw,_settings);
        // Publish only after all transformations and formatting are complete.
        _snapshot=complete;
        _renderer.prepare(_snapshot);
        if(RuntimeMetrics.enabled) { RuntimeMetrics.sampleCompute(System.getTimer()-started); }
    }
    function onLayout(dc) { _renderer.layout(dc,_settings); _layoutDirty=false; }
    function onUpdate(dc) {
        // Settings can change without a Garmin onLayout callback; metrics only, no sensor transforms.
        if(_layoutDirty || _renderer.needsLayout()) { onLayout(dc); }
        _renderer.draw(dc,_snapshot,_settings);
    }
    function reloadSettings() {
        var next=new DisplaySettings(); next.load(); _settings=next;
        _renderer.configure(_settings);
        _engine.metadata(); refreshPresentation(); _layoutDirty=_renderer.needsLayout();
    }
    function refreshPresentation() {
        var raw=_snapshot[:raw]; raw["temperature"]=Application.getApp().temperatureValue();
        _snapshot=_engine.prepare(raw,_settings,_snapshot[:hasSample]); _renderer.prepare(_snapshot);
    }
    function resetSamples() {
        _engine.reset();
        _acquisition.grade.reset();
        var raw=_snapshot[:raw]; raw["power_3s"]=null; raw["heart_rate_3s"]=null; raw["grade"]=null;
        _snapshot=_engine.prepare(raw,_settings,_snapshot[:hasSample]);
        _renderer.prepare(_snapshot);
    }
    function onTimerStart() { _samplingEnabled=true; _acquisition.onStart(); resetSamples(); refreshLaps(); }
    function onTimerStop() { _samplingEnabled=false; _acquisition.currentLap.pause(); resetSamples(); }
    function onTimerPause() { _samplingEnabled=false; _acquisition.currentLap.pause(); resetSamples(); }
    function onTimerResume() { _samplingEnabled=true; _acquisition.currentLap.resume(); resetSamples(); }
    function onTimerReset() { _samplingEnabled=false; _engine.reset(); _acquisition.onReset(); _snapshot=_engine.initial(_settings); refreshPresentation(); }
    function onTimerLap() {
        var info=null;
        try { info=Activity.getActivityInfo(); } catch(e) {}
        _acquisition.boundary(info); refreshLaps(); WatchUi.requestUpdate();
    }
    function refreshLaps() {
        _snapshot[:raw]["completed_laps"]=_acquisition.laps.value();
        _acquisition.currentLap.publish(_snapshot[:raw]); refreshPresentation();
    }
    function onShow() { refreshPresentation(); }
    function onHide() {} // Keep activity samples coherent while a different page is visible.
}
