using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.WatchUi;
using Toybox.Activity;

// Bounded producer fixture for maximum retained acquisition state; not sensor evidence.
class MemoryHistoryInfo {
    var elapsedTime=0;
    var timerTime=0;
    var elapsedDistance=0;
    var timerState=Activity.TIMER_STATE_ON;
    var currentHeartRate=100;
    var currentPower=0;
    var currentCadence=0;
}

// Qualification only; this file is not in the production jungle source path.
// Reuse the native Dc with bounded drawing coordinates, never a bitmap buffer.
class MemoryAreaDc {
    var _dc;
    var _width;
    var _height;
    function initialize(dc,width,height) { _dc=dc; _width=width; _height=height; }
    function getWidth() { return _width; }
    function getHeight() { return _height; }
    function getTextWidthInPixels(text,font) { return _dc.getTextWidthInPixels(text,font); }
    function setColor(a,b) { _dc.setColor(a,b); }
    function clear() { _dc.clear(); }
    function drawText(x,y,font,text,flags) { _dc.drawText(x,y,font,text,flags); }
    function setClip(x,y,w,h) { _dc.setClip(x,y,w,h); }
    function clearClip() { _dc.clearClip(); }
    function fillRectangle(x,y,w,h) { _dc.fillRectangle(x,y,w,h); }
    function fillPolygon(points) { _dc.fillPolygon(points); }
    function drawLine(x1,y1,x2,y2) { _dc.drawLine(x1,y1,x2,y2); }
}

module MemoryObservation {
    var samples=0;
    var maximum=0;
    var minimum=null;
    var totalLow=null;
    var totalHigh=0;
    function sample(stage) {
        var stats=System.getSystemStats();
        samples+=1;
        var used=stats.usedMemory;
        var free=stats.freeMemory;
        var total=stats.totalMemory;
        if(used>maximum) { maximum=used; }
        if(minimum==null || free<minimum) { minimum=free; }
        if(totalLow==null || total<totalLow) { totalLow=total; }
        if(total>totalHigh) { totalHigh=total; }
        if(total<=0 || total>DeviceProfile.MEMORY_LIMIT || used>total || used>DeviceProfile.MEMORY_LIMIT || free<0) {
            System.println("DF_MEMORY_FAIL product="+DeviceProfile.ID+" stage="+stage+
                " used="+used.toString()+" free="+free.toString()+" total="+total.toString());
            throw new Lang.InvalidValueException("Data Field allocation/limit violation");
        }
        if(samples==1 || used==maximum) {
            System.println("DF_MEMORY_SAMPLE product="+DeviceProfile.ID+" stage="+stage+
                " used="+used.toString()+" free="+free.toString()+" total="+total.toString()+
                " max="+maximum.toString()+" min="+minimum.toString());
        }
        return used;
    }
}

class MemoryValidationField extends StrukturField {
    var _started;
    var _step=0;
    var _cycle=0;
    var _nativeComputes=0;
    var _nativeDraws=0;
    var _fullGrids=0;
    var _maximumFonts=0;
    var _reference;
    var _returnFrames=0;
    var _returnMinimum=null;
    var _lastReturn=null;
    var _growthReturns=0;
    var _done=false;
    var _coverage=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]b;
    var _fieldsSeen=0;
    var _unsupportedHeaders=0;
    var _eligibilityWidth=0;
    var _plainFits=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]b;
    var _unitFits=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]b;
    const CASES=216;
    const CYCLES=3;
    function boundedHistory() {
        var grade=_acquisition.grade;
        grade.reset();
        for(var p=0;p<5;p+=1) { grade.push(p*0.05,p*0.25,p*1000,true,1); }
        if(grade.sampleCount()!=5) { throw new Lang.InvalidValueException("Grade fixture did not reach capacity"); }
        var lap=_acquisition.currentLap;lap.fresh();
        var info=new MemoryHistoryInfo();var raw={};lap.read(info,raw,1);
        info.elapsedTime=1000;info.timerTime=1000;info.elapsedDistance=10;
        info.currentHeartRate=160;info.currentPower=300;info.currentCadence=100;lap.read(info,raw,1);
        _engine._power.reset();_engine._heart.reset();
        for(var second=1;second<=3;second+=1) { _engine._power.push(100,second);_engine._heart.push(120,second); }
        MemoryObservation.sample("bounded_acquisition_state");
    }
    function initialize() {
        _started=System.getTimer();
        RuntimeMetrics.enabled=true; // Explicit validation build only; production remains off.
        StrukturField.initialize();
        _reference=new DisplaySettings(); _reference.load();
        MemoryObservation.sample("initialized");
    }
    function compute(info) {
        StrukturField.compute(info);
        _nativeComputes+=1;
        MemoryObservation.sample("native_compute");
    }
    function onLayout(dc) {
        StrukturField.onLayout(dc);
        prepareEligibility(dc.getWidth());
        System.println("DF_MEMORY_BOUNDS product="+DeviceProfile.ID+
            " width="+dc.getWidth().toString()+" height="+dc.getHeight().toString());
        MemoryObservation.sample("native_layout");
    }
    function prepareEligibility(width) {
        if(_eligibilityWidth==width) { return; }
        _eligibilityWidth=width;
        for(var field=0;field<Catalog.IDS.size();field+=1) {
            var plain=FontMetrics.width(Catalog.LABELS[field],_renderer._labelMetrics);var maximum=plain;
            var units=FieldPresentation.headerUnits(Catalog.UNITS[field]);
            for(var u=0;u<units.size();u+=1) {
                var header=FieldPresentation.headerText(Catalog.LABELS[field],units[u],Catalog.HEADERS_WITH_UNITS[field],false);
                var measured=FontMetrics.width(header,_renderer._labelMetrics);if(measured>maximum) { maximum=measured; }
            }
            if("clock".equals(Catalog.FORMATS[field])) {
                var am=FontMetrics.width(Catalog.LABELS[field]+" | am",_renderer._labelMetrics);
                var pm=FontMetrics.width(Catalog.LABELS[field]+" | pm",_renderer._labelMetrics);
                if(am>plain) { plain=am; }if(pm>plain) { plain=pm; }if(plain>maximum) { maximum=plain; }
            }
            _plainFits[field]=plain<=width/2-10?1:0;_unitFits[field]=maximum<=width/2-10?1:0;
        }
    }
    function fixture(step) as Lang.Dictionary {
        var raw={} as Lang.Dictionary;
        for(var i=0;i<Catalog.IDS.size();i+=1) {
            raw[Catalog.IDS[i]]=step%4==0?null:(step%4==1?99999.99:(step%4==2?-1.25:72.0));
        }
        var durationCases=[65000,3661000,35999000,36000000,86400000,360000000];
        raw["activity_timer"]=durationCases[step%durationCases.size()];
        raw["elapsed_time"]=86400000;
        raw["current_power"]=step%4==0?null:250+step%100;
        raw["current_heart_rate"]=step%4==0?null:120+step%50;
        raw["grade"]=step%4==0?null:(step%2==0?10.0:-10.0);
        raw["temperature"]=step%4==0?null:step%40;
        raw["_sampling_enabled"]=true;
        return raw;
    }
    function caseSettings(index) {
        var theme=(index/3)%3;
        var alignment=(index/9)%2;
        var big=(index/18)%3;
        // Compatibility fixtures: obsolete counts must not create partial grids.
        var legacyCount=[1,4,8,10][(index/54)%4];
        var values={"field_count"=>legacyCount,"enlarged_field_count"=>big,
            "alignment"=>alignment,"theme_mode"=>theme,
            "use_units_as_labels"=>index%2==0,"hide_value_units"=>(index/2)%2==0,
            "inverse_enlarged_theme"=>(index/4)%2==0} as Lang.Dictionary;
        for(var slot=0;slot<10;slot+=1) {
            var field=(index+slot)%Catalog.IDS.size();var selected=Catalog.IDS[field];
            // Keep unsupported complete-header placements in Placement. Every
            // field remains exercised in fitting roles, checked by coverage.
            if(index%12>=2 && slot>=big && slot<Grid.capacity(DeviceProfile.DESIGN_ROWS,big) &&
                (values["hide_value_units"]?_plainFits[field]:_unitFits[field])==0) {
                selected="current_power";_unsupportedHeaders+=1;
            }
            values["slot_"+(slot+1).toString()+"_value"]=selected;
            values["slot_"+(slot+1).toString()+"_background_effects"]=slot%2==0 || index%2==0;
        }
        if(index%17==0) { values["slot_10_value"]="unknown-validation-value"; }
        if(index%19==0) { values["slot_1_value"]="current_power";values["slot_2_value"]="current_power"; }
        // Memory uses native bounds. Deliberately insufficient areas and compact
        // messages belong to the separately requested Placement suite.
        if(index%12<2) {
            var defaults=["current_speed","distance","activity_timer","time_of_day","current_heart_rate",
                "power_3s","elevation","grade","total_ascent","temperature"];
            for(var fixedSlot=0;fixedSlot<10;fixedSlot+=1) { values["slot_"+(fixedSlot+1).toString()+"_value"]=defaults[fixedSlot]; }
            values["hide_value_units"]=true;
        }
        var next=new DisplaySettings();next.apply(values);return next;
    }
    function runCase(dc,index) {
        _settings=caseSettings(index);_renderer.configure(_settings);
        _engine.metadata();
        var sample=fixture(index);sample["elapsed_time"]=(_cycle*CASES+index+1)*1000;
        _snapshot=_engine.compute(sample,_settings);
        if(index%12==0) { boundedHistory(); }
        paintFixtureBands(index);
        MemoryObservation.sample("fixture_compute");
        var width=dc.getWidth();var height=dc.getHeight();
        var bounded=new MemoryAreaDc(dc,width,height);
        _renderer.prepare(_snapshot);_renderer.layout(bounded,_settings);_renderer.prepare(_snapshot);_layoutDirty=false;
        if(_renderer._cells.size()==0) { failedPrecondition(index,width,height); }
        if(_renderer._fonts.size()>3 || _renderer._metrics.size()>3) { throw new Lang.InvalidValueException("More than three font roles retained"); }
        recordCoverage();
        if(_renderer._fonts.size()>_maximumFonts) { _maximumFonts=_renderer._fonts.size(); }
        if(index%12==0) {
            if(_renderer._cells.size()!=Grid.capacity(DeviceProfile.DESIGN_ROWS,_settings.enlarged)) { throw new Lang.InvalidValueException("Required full native grid did not fit"); }
            _fullGrids+=1;
        }
        MemoryObservation.sample("fixture_layout");
        _renderer.draw(bounded,_snapshot,_settings);
        MemoryObservation.sample("fixture_draw");
        if(index%37==0) { StrukturField.onTimerPause();StrukturField.onTimerResume(); }
        if(index%41==0) { StrukturField.onTimerReset();StrukturField.onTimerStart(); }
        if(index%43==0) { StrukturField.onHide();StrukturField.onShow(); }
        if(index%47==0) { StrukturField.reloadSettings(); }
        MemoryObservation.sample("lifecycle");
    }
    function paintFixtureBands(index) {
        // Controlled bands exercise allocation/drawing independently of metadata availability.
        var colors=["blue","green","yellow","orange","red","dark_red","white"];
        for(var n=0;n<_snapshot[:values].size();n+=1) {
            if(_settings.effects[n] && index%4!=0) { _snapshot[:values][n][:band]=colors[(n+index)%colors.size()]; }
        }
    }
    function failedPrecondition(index,width,height) {
            var expected=Grid.plan(width,height,DeviceProfile.DESIGN_ROWS,_settings.enlarged);
            for(var field=0;field<expected.size();field+=1) {
                var v=_snapshot[:values][field];var cell=expected[field];
                System.println("DF_MEMORY_PREFLIGHT case="+index.toString()+" slot="+field.toString()+" id="+_settings.slots[field]+" header="+v[:label]+" text="+_renderer.displayText(v)+" unit="+v[:unit]+" cell="+cell[:w].toString()+"x"+cell[:h].toString());
            }
            throw new Lang.InvalidValueException("Memory precondition: native grid must fit; compact-area checks belong to Placement");
    }
    function recordCoverage() {
        for(var visible=0;visible<_renderer._cells.size();visible+=1) {
            var fieldIndex=Catalog.index(_settings.slots[visible]);
            if(fieldIndex!=null && _coverage[fieldIndex]==0) { _coverage[fieldIndex]=1;_fieldsSeen+=1; }
        }
    }
    function reference(dc) {
        _settings=_reference;
        _engine.reset();_snapshot=_engine.initial(_settings);
        _renderer.configure(_settings);_renderer.prepare(_snapshot);
        StrukturField.onLayout(dc);StrukturField.onUpdate(dc);
        var used=MemoryObservation.sample("reference");
        if(_returnMinimum==null || used<_returnMinimum) { _returnMinimum=used; }
        _returnFrames+=1;
    }
    function onUpdate(dc) {
        _nativeDraws+=1;
        if(_done) { StrukturField.onUpdate(dc);return; }
        if(_nativeDraws<=3) { StrukturField.onUpdate(dc);MemoryObservation.sample("startup_draw");return; }
        if(_cycle<CYCLES && _step<CASES) {
            // Bounded batches retain native callbacks and real drawing resources.
            for(var batch=0;batch<12 && _step<CASES;batch+=1) { runCase(dc,_step);_step+=1; }
            if(_step%36==0) { System.println("DF_MEMORY_PROGRESS product="+DeviceProfile.ID+" cycle="+_cycle.toString()+" step="+_step.toString()); }
        } else {
            reference(dc);
            if(_returnFrames>=5 && _cycle<CYCLES) {
                System.println("DF_MEMORY_RETURN product="+DeviceProfile.ID+" cycle="+_cycle.toString()+" used="+_returnMinimum.toString());
                if(_lastReturn!=null && _returnMinimum>_lastReturn) { _growthReturns+=1; }
                else { _growthReturns=0; }
                _lastReturn=_returnMinimum;_cycle+=1;_step=0;_returnFrames=0;_returnMinimum=null;
            }
        }
        if(_cycle>=CYCLES && _nativeComputes>=10 && System.getTimer()-_started>=30000) {
            _done=true;
            System.println("DF_MEMORY_DONE product="+DeviceProfile.ID+" cycles="+_cycle.toString()+
                " cases="+(CASES*CYCLES).toString()+" samples="+MemoryObservation.samples.toString()+
                " max_used="+MemoryObservation.maximum.toString()+" min_free="+MemoryObservation.minimum.toString()+
                " total_low="+MemoryObservation.totalLow.toString()+" total_high="+MemoryObservation.totalHigh.toString()+
                " native_compute="+_nativeComputes.toString()+" native_draw="+_nativeDraws.toString()+
                " full_grids="+_fullGrids.toString()+" max_fonts="+_maximumFonts.toString()+
                " fields_seen="+_fieldsSeen.toString()+" unsupported_headers="+_unsupportedHeaders.toString()+
                " growth_returns="+_growthReturns.toString()+" elapsed_ms="+(System.getTimer()-_started).toString());
        }
        WatchUi.requestUpdate();
    }
}
