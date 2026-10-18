using Toybox.System;
using Toybox.WatchUi;
using Toybox.Lang;

// Run separately from the 648-case matrix so unrelated test drivers do not
// occupy the app heap together. Both use the normal Data Field allocation.
(:memorySwitch)
class MemorySwitchingField extends StrukturField {
    var _switches=0;var _switchSettings=0;var _switchInfo;
    var _switchReference=null;var _settingsReference=null;var _settingsGrowth=0;
    var _started;var _nativeComputes=0;var _nativeDraws=0;var _done=false;var _maxFonts=0;
    function initialize() {
        _started=System.getTimer();RuntimeMetrics.enabled=true;StrukturField.initialize();
        MemoryObservation.sample("initialized");
    }
    function compute(info) { StrukturField.compute(info);_nativeComputes+=1;MemoryObservation.sample("native_compute"); }
    function onLayout(dc) {
        StrukturField.onLayout(dc);
        System.println("DF_MEMORY_BOUNDS product="+DeviceProfile.ID+" width="+dc.getWidth()+" height="+dc.getHeight());
        MemoryObservation.sample("native_layout");
    }
    // SPEC-231: explicit Memory-only fixture; never part of a Core run.
    function switchingSettings(mode,variant) {
        // Construct the already-validated fixture directly. A redundant 40-key
        // temporary dictionary would measure the test authoring adapter, not the app.
        // Native reloadSettings() is exercised separately in the retained matrix.
        var banks=new FieldSetsSettings();banks.trigger=mode;
        var first=banks.primary;var second=banks.secondary;
        first.enlarged=variant%3;second.enlarged=(variant+1)%3;
        first.alignment=variant%2==0?"center":"right";second.alignment=variant%2==0?"right":"center";
        first.theme="day";second.theme="night";
        var grids=["none","horizontal","full"];
        first.gridType=grids[variant%3];second.gridType=grids[(variant+1)%3];
        first.usesClock=false;second.usesClock=false;
        for(var slot=0;slot<10;slot+=1) {
            first.slots[slot]="current_power";second.slots[slot]="current_heart_rate";
            first.effects[slot]=true;second.effects[slot]=true;
        }
        return banks;
    }
    function secondaryFieldSetRuntime(dc) {
        if(_switchInfo==null) {
            _switchInfo=new MemoryHistoryInfo();applyFieldSets(switchingSettings(2,0));
        }
        if(_switches<1000) {
            // Every batch starts on default; native callbacks may have run between frames.
            _fieldSets.second=false;
            for(var batch=0;batch<50 && _switches<1000;batch+=1) {
                _switchInfo.currentHeartRate=_switches%2==0?180:100;
                _switchInfo.elapsedTime=(_switches+1)*1000;_switchInfo.timerTime=_switchInfo.elapsedTime;
                _switchInfo.elapsedDistance=_switches*10;_switchInfo.currentPower=250;
                StrukturField.processActivity(_switchInfo);StrukturField.onLayout(dc);StrukturField.onUpdate(dc);
                if(_fieldSets.second!=(_switches%2==0)) { throw new Lang.InvalidValueException("Threshold memory fixture did not switch"); }
                if(_engine._descriptors.size()!=10 || _renderer._fonts.size()>3) { throw new Lang.InvalidValueException("Switch cache bound exceeded"); }
                _switches+=1;MemoryObservation.sample("second_set_switch");
                if(_switches==500 || _switches==1000) {
                    var retained=System.getSystemStats().usedMemory;
                    if(_switches==500) {_switchReference=retained;}
                    if(_switches==1000 && retained>_switchReference) {throw new Lang.InvalidValueException("Retained switch growth");}
                    System.println("DF_SECOND_SET_CHECKPOINT transitions="+_switches+" used="+retained);
                }
            }
            return;
        }
        for(var change=0;change<10 && _switchSettings<200;change+=1) {
            var mode=1+(_switchSettings%4);applyFieldSets(switchingSettings(mode,_switchSettings));
            if(mode==3) { onLapNotification(true); }
            else if(mode==4) { onWorkoutStarted(); }
            else {
                for(var second=0;second<3;second+=1) {
                    _switchInfo.elapsedTime+=1000;_switchInfo.timerTime+=1000;
                    _switchInfo.currentHeartRate=180;_switchInfo.currentPower=300;
                    StrukturField.processActivity(_switchInfo);
                }
            }
            StrukturField.onLayout(dc);StrukturField.onUpdate(dc);_switchSettings+=1;
            if(_engine._descriptors.size()!=10 || _renderer._fonts.size()>3) { throw new Lang.InvalidValueException("Settings switch cache bound exceeded"); }
            MemoryObservation.sample("second_set_settings");
            if(_switchSettings%48==0) {
                var steady=System.getSystemStats().usedMemory;
                if(_settingsReference!=null && steady>_settingsReference) {_settingsGrowth+=1;} else {_settingsGrowth=0;}
                if(_settingsGrowth>=2) {throw new Lang.InvalidValueException("Retained settings growth");}
                _settingsReference=steady;System.println("DF_SECOND_SET_SETTINGS_RETURN count="+_switchSettings+" used="+steady);
            }
        }
        if(_switchSettings==200) {
            System.println("DF_SECOND_SET_DONE transitions="+_switches+" settings="+_switchSettings);
            _fieldSets.configuration.trigger=0;_fieldSets.second=false;
        }
    }

    function onUpdate(dc) {
        _nativeDraws+=1;
        if(_done) {StrukturField.onUpdate(dc);return;}
        if(_nativeDraws<=3) {StrukturField.onUpdate(dc);MemoryObservation.sample("startup_draw");return;}
        if(_switches<1000 || _switchSettings<200) {secondaryFieldSetRuntime(dc);}
        else {StrukturField.onUpdate(dc);}
        if(_renderer._fonts.size()>_maxFonts) {_maxFonts=_renderer._fonts.size();}
        if(_switches==1000 && _switchSettings==200 && _nativeComputes>=10 && System.getTimer()-_started>=30000) {
            _done=true;
            System.println("DF_SWITCH_MEMORY_DONE product="+DeviceProfile.ID+" transitions="+_switches+" settings="+_switchSettings+
                " samples="+MemoryObservation.samples+" max_used="+MemoryObservation.maximum+" min_free="+MemoryObservation.minimum+
                " total_low="+MemoryObservation.totalLow+" total_high="+MemoryObservation.totalHigh+
                " native_compute="+_nativeComputes+" native_draw="+_nativeDraws+" elapsed_ms="+(System.getTimer()-_started)+" max_fonts="+_maxFonts);
        }
        WatchUi.requestUpdate();
    }
}
