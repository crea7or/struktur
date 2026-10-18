using Toybox.WatchUi;
using Toybox.Time;
using Toybox.System;
using Toybox.Activity;
using Toybox.Application;

class StrukturField extends LapAwareDataField {
    var _settings;var _fieldSets;
    var _engine;
    var _snapshot;
    var _renderer;
    var _layoutDirty;
    var _samplingEnabled;
    var _acquisition;
    function initialize() {
        LapAwareDataField.initialize();
        var banks=new FieldSetsSettings();banks.load();
        _fieldSets=new FieldSetController(banks);_settings=_fieldSets.active();
        _acquisition=new ActivityAcquisition();
        _engine=new SnapshotEngine();_engine.metadata();
        _snapshot=_engine.initial(_settings);_renderer=new FieldRenderer();_renderer.prepare(_snapshot);_layoutDirty=true;_samplingEnabled=false;
    }
    function compute(info) { processActivity(info); }
    // Shared by SDK callbacks and fixtures: acquire once, decide, then format only the active set.
    function processActivity(info) {
        var started=RuntimeMetrics.enabled?System.getTimer():0;
        var raw=ActivityReader.readWithBattery(info,false);
        _acquisition.read(info,raw);
        raw["temperature"]=temperatureReading();
        if(info has :timerState) { _samplingEnabled=info.timerState==Activity.TIMER_STATE_ON; }
        raw["_sampling_enabled"]=_samplingEnabled;
        _engine.advance(raw);
        _fieldSets.evaluate(raw,_samplingEnabled);
        selectSettings();
        raw["battery"]=_settings.usesBattery?batteryReading():null;
        _snapshot=_engine.prepare(raw,_settings,true);
        _renderer.prepare(_snapshot);_layoutDirty=_renderer.needsLayout();
        if(RuntimeMetrics.enabled) { RuntimeMetrics.sampleCompute(System.getTimer()-started); }
    }
    function temperatureReading() { return Application.getApp().temperatureValue(); }
    function batteryReading() { return ActivityReader.batteryValue(); }
    function selectSettings() {
        var next=_fieldSets.active();
        if(_settings==next) { return false; }
        _renderer.discardPresentation();_settings=next;_renderer.configure(_settings);return true;
    }
    function onLayout(dc) { _renderer.layout(dc,_settings);_layoutDirty=false; }
    function onUpdate(dc) {
        if(_layoutDirty || _renderer.needsLayout()) { onLayout(dc); }
        _renderer.draw(dc,_snapshot,_settings);
    }
    function reloadSettings() { _renderer.discardPresentation();var next=new FieldSetsSettings();next.load();applyFieldSets(next); }
    function applyFieldSets(next) {
        _fieldSets.configure(next);_engine.metadata();refreshPresentation();
    }
    function refreshPresentation() {
        var changed=selectSettings();var raw=_snapshot[:raw];raw["temperature"]=temperatureReading();
        if(changed && _settings.usesBattery) { raw["battery"]=batteryReading(); }
        _snapshot=_engine.prepare(raw,_settings,_snapshot[:hasSample]);_renderer.prepare(_snapshot);_layoutDirty=_renderer.needsLayout();
    }
    function resetSamples() {
        _engine.reset();_acquisition.grade.reset();
        var raw=_snapshot[:raw];raw["power_3s"]=null;raw["heart_rate_3s"]=null;raw["grade"]=null;
        _snapshot=_engine.prepare(raw,_settings,_snapshot[:hasSample]);_renderer.prepare(_snapshot);
    }
    function onTimerStart() { _samplingEnabled=true;_fieldSets.start();_acquisition.onStart();resetSamples();refreshLaps(); }
    function onTimerStop() { _samplingEnabled=false;_acquisition.currentLap.pause();resetSamples(); }
    function onTimerPause() { _samplingEnabled=false;_acquisition.currentLap.pause();resetSamples(); }
    function onTimerResume() { _samplingEnabled=true;_fieldSets.start();_acquisition.currentLap.resume();resetSamples(); }
    function onTimerReset() {
        _samplingEnabled=false;_fieldSets.reset();selectSettings();_engine.reset();_acquisition.onReset();
        _snapshot=_engine.initial(_settings);refreshPresentation();WatchUi.requestUpdate();
    }
    function onWorkoutStarted() { _fieldSets.workout();refreshPresentation();WatchUi.requestUpdate(); }
    function onTimerLap() { onLapNotification(!typedLapSupported()); }
    function onLapNotification(manual) {
        var info=null;try { info=Activity.getActivityInfo(); } catch(e) {}
        handleLap(info,manual);
    }
    function handleLap(info,manual) {
        _acquisition.boundary(info);_fieldSets.lap(manual);refreshLaps();WatchUi.requestUpdate();
    }
    function refreshLaps() {
        _snapshot[:raw]["completed_laps"]=_acquisition.laps.value();
        _acquisition.currentLap.publish(_snapshot[:raw]);refreshPresentation();
    }
    function onShow() { refreshPresentation(); }
    function onHide() {} // Keep acquisition and switching coherent on other pages.
}
