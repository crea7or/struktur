using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Math;
// Fixed-shape fitting state avoids a separate symbol hash table for every cell.
class FittedRun {
    var size;var text;var unit;var width;var unitWidth;var total;var top;
    var lines;var isNative=false;var inner;var ink;var unitInk;var margin;var radius;var labelBand;var font=null;
    function initialize(s,t,u,w,uw,all,y,bounds,ubounds) {
        size=s;text=t;unit=u;width=w;unitWidth=uw;total=all;top=y;
        ink=bounds;unitInk=ubounds;
    }
}
// A prepared cell stores a fixed set of commands, without a per-cell hash table.
class PreparedCell {
    var lines;var team=false;var fillBase=false;var inner;var coverage;var night;var band;var angle;var background;var labelEffect;var color;var label;var primary;var unit;var run;
    function initialize(n,b,a,bg,e,c,l,p,u) {
        night=n;band=b;angle=a;background=bg;labelEffect=e;color=c;label=l;primary=p;unit=u;
    }
}
// APP-24/28: exactly three fixed profile fonts; measured bounds prevent clipping.
class FieldRenderer {
    var _nativeFonts;
    var _cells=[];
    var _runs=[];
    var _polygons=[];
    var _separators=[];
    var _preparedValues=[];
    var _cellNights=[];
    var _baseNight=false;
    var _inverse=true;
    var _needsLayout=true;
    var _width=0;
    var _height=0;
    var _settings=null;
    var _fonts={};
    var _metrics={};
    var _headerFits={};var headerMeasures=0;
    var _regularMetrics;var _bigMetrics;
    var _labels=null;
    var _labelHeight=0;
    var _labelTop=3;
    var _labelBandHeight=0;
    var _headerHeight=0;
    var _labelMetrics=null;
    var _compactText="full grid needs larger area";
    var _compactLines=[];
    var _compactFont=null;
    var _compactHeight=0;
    var _compactTop=0;
    var layoutCount=0;
    var fontLoads=0;
    var fitCount=0;
    var geometryBuilds=0;
    var polygonBuilds=0;
    var packetBuilds=0;
    var recordChecks=0;var geometryPasses=0;
    var _gridPlans={};
    var _separatorPlans={};
    var _geometryDirty=true;
    var _configuredEnlarged=-1;
    var _configuredAlignment=null;var _right=true;
    var _configuredGrid=null;
    var _nativeCapacity=2*DeviceProfile.DESIGN_ROWS;
    var _packets=[];
    var _polygonAngles=[];
    var _compactPackets=[];
    var _dirtyFields=[];
    var _dirtyCount=0;
    var _paletteNight=null;
    var _paletteInverse=null;
    var _regularSizes=[DeviceProfile.REGULAR_SIZE];
    var _bigSizes=[DeviceProfile.BIG_SIZE];
    var _labelSizes=[DeviceProfile.LABEL_SIZE];
    var _clearForeground=Graphics.COLOR_BLACK;
    var _clearBackground=Graphics.COLOR_WHITE;
    var _lineColorIndex=5;
    function initialize() {
        _nativeFonts=new NativeTextCache();
        _labelBandHeight=FieldPresentation.headerBandHeight(metric(DeviceProfile.LABEL_SIZE,true),_labelTop);
        var line=FontSelection.height(DeviceProfile.LABEL_SIZE,true);
        _headerHeight=line>_labelBandHeight?line:_labelBandHeight;
        _nativeFonts.headerHeight=_headerHeight;
        _labelMetrics=metric(DeviceProfile.LABEL_SIZE,true);
        _nativeFonts.headerWidth=FontMetrics.width("team",_labelMetrics);
        _regularMetrics=metric(DeviceProfile.REGULAR_SIZE,false);_bigMetrics=metric(DeviceProfile.BIG_SIZE,false);
    }
    // Bank changes replace the visible presentation atomically. Release the old
    // fitting/drawing state before preparing its replacement on the shared heap.
    function discardPresentation() {
        _preparedValues=[];_runs=[];_packets=[];_headerFits={};
        _polygons=[];_polygonAngles=[];_cellNights=[];_needsLayout=true;
    }
    function needsLayout() { return _needsLayout; }
    function coverage(value) { return value.size()>ValueRecord.COVERAGE?value[ValueRecord.COVERAGE]:(value[ValueRecord.ANGLE]!=null?2:1); }
    function isTeam(value) { return "text".equals(value[ValueRecord.FORMAT]); }
    function painted(value) { return value[ValueRecord.BAND]!=null || value[ValueRecord.ANGLE]!=null; }
    function numericSizes(enlarged) {
        return enlarged?_bigSizes:_regularSizes;
    }
    function metric(size,labelRole) {
        var key=(labelRole?"l":"v")+size.toString();
        if(!_metrics.hasKey(key)) {
            var height=FontSelection.height(size,labelRole);
            _metrics[key]=labelRole?FontMetrics.label(height):FontMetrics.numeric(height);
        }
        return _metrics[key];
    }
    function selectFont(size,labelRole,nextFonts) {
        var key=(labelRole?"l":"v")+size.toString();
        if(!nextFonts.hasKey(key)) {
            if(_fonts.hasKey(key)) { nextFonts[key]=_fonts[key]; }
            else { nextFonts[key]=WatchUi.loadResource(FontSelection.info(size,labelRole)[0]); fontLoads+=1; }
        }
        return nextFonts[key];
    }
    function displayText(value) {
        var text=value[ValueRecord.TEXT];
        return text==null?PresentationPolicy.UNAVAILABLE:("overflow".equals(text)?PresentationPolicy.OVERFLOW:text);
    }
    function fitRun(cell,value,labelSize,text,unit) {
        fitCount+=1;
        var labelFit=_headerFits.hasKey(value[ValueRecord.LABEL])?_headerFits[value[ValueRecord.LABEL]]:null;
        if(labelFit==null) {
            labelFit=[FontMetrics.width(value[ValueRecord.LABEL],_labelMetrics),FontMetrics.bounds(value[ValueRecord.LABEL],_labelMetrics)[1]];
            _headerFits[value[ValueRecord.LABEL]]=labelFit;headerMeasures+=1;
        }
        // Keep fitting state in the result object: this path also runs inside
        // settings and typed-lap callbacks with a small VM operand stack.
        var run=new FittedRun(cell[Cell.ENLARGED]?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE,text,unit,0,0,0,0,null,null);
        run.radius=painted(value)?1:0;run.margin=4+run.radius;
        run.labelBand=value[ValueRecord.BAND]!=null && value[ValueRecord.ANGLE]==null && coverage(value)==1?_labelBandHeight:0;
        if(labelFit[0]>cell[Cell.W]-2*run.margin || run.size<=labelSize) { return null; }
        var metrics=cell[Cell.ENLARGED]?_bigMetrics:_regularMetrics;
        run.ink=FontMetrics.bounds(text,metrics);run.width=FontMetrics.width(text,metrics);
        run.unitWidth=FontMetrics.width(run.unit,_labelMetrics);
        var expanded=value.size()>ValueRecord.EXPANDEDUNIT?value[ValueRecord.EXPANDEDUNIT]:null;
        if(!PresentationPolicy.OVERFLOW.equals(text) && expanded!=null) {
            // run.total is scratch here (assigned below): no extra local in this deep callback frame.
            run.total=FontMetrics.width(expanded,_labelMetrics);
            if(run.width+run.total+2<=cell[Cell.W]-2*run.margin) { run.unit=expanded;run.unitWidth=run.total; }
        }
        run.total=run.width+(run.unitWidth>0?run.unitWidth+2:0);
        run.top=Numeric.rounded(_headerHeight+(cell[Cell.H]-_headerHeight-(run.ink[1]-run.ink[0]))/2.0);
        run.unitInk=FontMetrics.bounds(run.unit,_labelMetrics);
        if(run.total<=cell[Cell.W]-2*run.margin && run.top>=run.labelBand && run.top-run.radius>=_headerHeight && run.top-run.radius>=4+labelFit[1]+run.radius+2 &&
            run.top+run.ink[1]-run.ink[0]+run.radius<=cell[Cell.H] && run.top+run.unitInk[1]-run.unitInk[0]+run.radius<=cell[Cell.H]) { return run; }
        return null;
    }
    function plan(rows) {
        if(!_gridPlans.hasKey(rows)) { _gridPlans[rows]=Grid.plan(_width,_height,rows,_settings.enlarged);geometryBuilds+=1; }
        var cells=_gridPlans[rows];
        // APP-24/28 assigns exactly one font per role: no variant search/scoring.
        for(var overflow=0;overflow<2;overflow+=1) {
            var runs=[];
            for(var i=0;i<cells.size();i+=1) {
                var value=_preparedValues[i];var text=displayText(value);
                var run=null;
                if(isTeam(value)) { fitCount+=1;run=_nativeFonts.fit(cells[i],value); }
                else { run=fitRun(cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[ValueRecord.UNIT]); }
                if(run==null && overflow==1) { run=fitRun(cells[i],value,DeviceProfile.LABEL_SIZE,PresentationPolicy.OVERFLOW,""); }
                if(run==null) { break; }
                runs.add(run);
            }
            if(runs.size()==cells.size()) { return [cells,runs,DeviceProfile.LABEL_SIZE]; }
        }
        return null;
    }
    function layout(dc,settings) {
        // Native Dc handles belong to this callback, never a later compute/settings/lap call.
        _nativeFonts.setContext(dc);
        try {
            var width=dc.getWidth();var height=dc.getHeight();
            if(_width!=width || _height!=height) { _geometryDirty=true;_needsLayout=true; }
            _width=width;_height=height;configure(settings);
            if(_needsLayout) { rebuild();prepareGeometry(); }
        } finally { _nativeFonts.setContext(null); }
    }
    function configure(settings) {
        if(_configuredEnlarged!=settings.enlarged) {
            _geometryDirty=true;_needsLayout=true;
        }
        if(_configuredAlignment==null || !_configuredAlignment.equals(settings.alignment)) { _needsLayout=true; }
        var gridChanged=_configuredGrid==null || !_configuredGrid.equals(settings.gridType);
        if(gridChanged) { _separatorPlans={};_separators=[]; }
        if(_configuredEnlarged!=settings.enlarged) { _nativeCapacity=Grid.capacity(DeviceProfile.DESIGN_ROWS,settings.enlarged); }
        _configuredEnlarged=settings.enlarged;_configuredAlignment=settings.alignment;_right="right".equals(settings.alignment);_settings=settings;
        _configuredGrid=settings.gridType;
        if(gridChanged && !_needsLayout && _cells.size()>0) { prepareSeparators(); }
    }
    function wrapMessage(size) {
        var metrics=metric(size,true); var words=["full","grid","needs","larger","area"];
        var lines=[];var line="";
        for(var i=0;i<words.size();i+=1) {
            if(FontMetrics.width(words[i],metrics)>_width) { return null; }
            var next=line.length()==0?words[i]:line+" "+words[i];
            if(FontMetrics.width(next,metrics)>_width) { lines.add(line);line=words[i]; }
            else { line=next; }
        }
        lines.add(line);
        var height=FontSelection.height(size,true);
        return lines.size()*height<=_height?lines:null;
    }
    function compact(nextFonts) {
        _compactLines=[]; _compactFont=null;_compactPackets=[];
        var sizes=_labelSizes;
        for(var i=0;i<sizes.size();i+=1) {
            var lines=wrapMessage(sizes[i]);
            if(lines!=null) {
                _compactLines=lines;_compactHeight=FontSelection.height(sizes[i],true);
                _compactFont=selectFont(sizes[i],true,nextFonts);
                _compactTop=(_height-lines.size()*_compactHeight)/2;
                for(var line=0;line<lines.size();line+=1) { _compactPackets.add([_width/2,_compactTop+line*_compactHeight,lines[line]]); }
                return;
            }
        }
        // APP-34: the compact message is never replaced by a value-overflow marker.
        // If the complete message cannot fit, preserve the bounds with background only.
    }
    function rebuild() {
        layoutCount+=1;_cells=[];_runs=[];_separators=[];_polygons=[];_polygonAngles=[];_cellNights=[];_packets=[];
        if(_geometryDirty) { _gridPlans={};_separatorPlans={};_geometryDirty=false; }
        _labelMetrics=metric(DeviceProfile.LABEL_SIZE,true);
        _labelHeight=FontSelection.height(DeviceProfile.LABEL_SIZE,true);
        var nextFonts={}; var selected=null;
        if(_preparedValues.size()>=10) {
            selected=plan(DeviceProfile.DESIGN_ROWS);
            if(selected==null && DeviceProfile.DESIGN_ROWS==5) { selected=plan(4); }
        }
        if(selected==null) { compact(nextFonts); }
        else {
            _compactLines=[];_compactFont=null;
            _cells=selected[0];_runs=selected[1];var labelSize=selected[2];
            _labels=selectFont(labelSize,true,nextFonts);_labelHeight=FontSelection.height(labelSize,true);
            _labelMetrics=metric(labelSize,true);
            for(var i=0;i<_runs.size();i+=1) { if(!_runs[i].isNative) { _runs[i].font=selectFont(_runs[i].size,false,nextFonts); } }
            prepareSeparators();
        }
        _fonts=nextFonts; // discard unused handles, bounded by visible selected variants
        _needsLayout=false;
    }
    function prepare(snapshot) {
        _dirtyCount=0;var headersChanged=false;var visibleChanged=false;var values=snapshot[:values];
        for(var i=0;i<values.size();i+=1) {
            var next=values[i];
            var changed=i>=_preparedValues.size();
            if(changed) { _needsLayout=true;headersChanged=true; }
            else {
                // Published records are immutable: identical records need no field/string comparisons.
                var old=_preparedValues[i];
                if(old==next) { continue; }
                recordChecks+=1;
                if(!old[ValueRecord.LABEL].equals(next[ValueRecord.LABEL])) { headersChanged=true; }
                if(!old[ValueRecord.LABEL].equals(next[ValueRecord.LABEL]) || !displayText(old).equals(displayText(next)) ||
                    !old[ValueRecord.UNIT].equals(next[ValueRecord.UNIT]) || isTeam(old)!=isTeam(next) ||
                    (!isTeam(next) && painted(old)!=painted(next)) ||
                    (old[ValueRecord.EXPANDEDUNIT]==null?next[ValueRecord.EXPANDEDUNIT]!=null:(next[ValueRecord.EXPANDEDUNIT]==null || !old[ValueRecord.EXPANDEDUNIT].equals(next[ValueRecord.EXPANDEDUNIT])))) { changed=true; }
            }
            if(i<_nativeCapacity) { visibleChanged=true; }
            // Hidden candidate cells can permit recovery from a smaller fallback.
            // Slots beyond the preferred capacity never affect the current layout.
            if(changed && i<_nativeCapacity) {
                if(_dirtyCount<_dirtyFields.size()) { _dirtyFields[_dirtyCount]=i; } else { _dirtyFields.add(i); }
                _dirtyCount+=1;
            }
        }
        if(headersChanged) {
            var retained={};
            for(var slot=0;slot<values.size();slot+=1) {
                var label=values[slot][ValueRecord.LABEL];
                if(_headerFits.hasKey(label)) { retained[label]=_headerFits[label]; }
            }
            _headerFits=retained;
        }
        _preparedValues=values;_baseNight=snapshot[:night];_inverse=snapshot[:inverse];
        if(_settings==null || _width<=0 || _height<=0) { return; }
        if(!visibleChanged && !_needsLayout && _paletteNight==_baseNight && _paletteInverse==_inverse) { return; }
        if(!_needsLayout && _dirtyCount>0) {
            // Reconsider the preferred capacity after a fallback; never pin a smaller grid.
            if(_cells.size()!=_nativeCapacity) { _needsLayout=true; }
            // Team fitting needs a current native Dc. Defer changed native text until layout;
            // numeric-only updates continue using cached sprite metrics here.
            for(var dirty=0;dirty<_dirtyCount && !_needsLayout;dirty+=1) {
                if(isTeam(_preparedValues[_dirtyFields[dirty]])) { _needsLayout=true; }
            }
            if(!_needsLayout) { refreshRuns(); }
        }
        if(_needsLayout) {
            for(var slot=0;slot<_preparedValues.size() && slot<_nativeCapacity;slot+=1) {
                if(isTeam(_preparedValues[slot])) { return; }
            }
            rebuild();
        }
        prepareGeometry();
    }
    function refreshRuns() {
        for(var n=0;n<_dirtyCount;n+=1) {
            var i=_dirtyFields[n];var value=_preparedValues[i];var text=displayText(value);
            var run=null;
            if(isTeam(value)) { fitCount+=1;run=_nativeFonts.fit(_cells[i],value); }
            else { run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[ValueRecord.UNIT]); }
            if(run==null) { run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,PresentationPolicy.OVERFLOW,""); }
            if(run==null) { _needsLayout=true;return; }
            if(!run.isNative) { run.font=_runs[i].isNative?selectFont(run.size,false,_fonts):_runs[i].font; } _runs[i]=run;
        }
    }
    function prepareGeometry() {
        geometryPasses+=1;
        var paletteChanged=_paletteNight!=_baseNight || _paletteInverse!=_inverse;
        if(paletteChanged) {
            _clearForeground=_baseNight?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
            _clearBackground=_baseNight?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
            _lineColorIndex=_baseNight?4:5;_paletteNight=_baseNight;_paletteInverse=_inverse;
        }
        for(var i=0;i<_cells.size();i+=1) {
            var night=paletteChanged || i>=_cellNights.size()?FieldPresentation.effectiveNight(_baseNight,_cells[i][Cell.ENLARGED],_inverse):_cellNights[i];
            var value=_preparedValues[i];var packet=i<_packets.size()?_packets[i]:null;
            if(i>=_cellNights.size()) { _cellNights.add(night);_polygons.add(null);_polygonAngles.add(null);_packets.add(null); }
            _cellNights[i]=night;
            if(packet==null || packet.run!=_runs[i] || packet.night!=night ||
                (packet.band==null?value[ValueRecord.BAND]!=null:(value[ValueRecord.BAND]==null || !packet.band.equals(value[ValueRecord.BAND]))) || packet.angle!=value[ValueRecord.ANGLE] || packet.coverage!=coverage(value)) {
                if(_polygonAngles[i]!=value[ValueRecord.ANGLE]) {
                    _polygons[i]=value[ValueRecord.ANGLE]==null?null:Geometry.ground(_cells[i],value[ValueRecord.ANGLE]);
                    _polygonAngles[i]=value[ValueRecord.ANGLE];
                    if(value[ValueRecord.ANGLE]!=null) { polygonBuilds+=1; }
                }
                _packets[i]=_runs[i].isNative?prepareTeam(i,night):preparePacket(i,night,packet);_packets[i].run=_runs[i];packetBuilds+=1;
            }
        }
    }
    function preparePacket(i,night,old) {
        var c=_cells[i];var v=_preparedValues[i];var run=_runs[i];var band=v[ValueRecord.BAND];var bandColor=band==null?null:color(band);
        var background=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var mode=coverage(v);
        var flat=band!=null && v[ValueRecord.ANGLE]==null;
        var whole=flat && mode==2;
        var labelEffect=flat && mode==1;
        run.labelBand=labelEffect?_labelBandHeight:0;
        var darkText=!flat?!night:darkBand(band);
        var headerForeground=darkText?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var valueForeground=whole?headerForeground:(night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK);
        var radius=v[ValueRecord.ANGLE]!=null || whole?run.radius:0;
        if(whole) { background=bandColor; }
        var x=_right?c[Cell.X]+c[Cell.W]-run.margin-run.total:c[Cell.X]+(c[Cell.W]-run.total)/2;
        // A value-only refresh keeps the header command: its position, font and contrast depend only on these inputs.
        var label=old!=null && !old.team && old.night==night && old.coverage==mode && old.angle==v[ValueRecord.ANGLE] &&
            (old.band==null?band==null:(band!=null && old.band.equals(band))) && old.label[3].equals(v[ValueRecord.LABEL])?old.label:
            MaskedText.prepare(_right?c[Cell.X]+c[Cell.W]-run.margin:c[Cell.X]+c[Cell.W]/2,c[Cell.Y]+_labelTop,_labels,v[ValueRecord.LABEL],_right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,run.radius);
        var primary=MaskedText.prepare(x,c[Cell.Y]+run.top-run.ink[0],run.font,run.text,Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius);
        var unit=run.unitWidth>0?MaskedText.prepare(x+run.width+2,c[Cell.Y]+run.top-run.unitInk[0],_labels,run.unit,Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius):null;
        var prepared=new PreparedCell(night,band,v[ValueRecord.ANGLE],background,labelEffect,bandColor,label,primary,unit);
        prepared.fillBase=background!=_clearBackground;prepared.coverage=mode;return prepared;
    }
    function prepareTeam(i,night) {
        var cell=_cells[i];var value=_preparedValues[i];var run=_runs[i];var band=value[ValueRecord.BAND];
        var dark=band==null?!night:darkBand(band);var bandColor=band==null?null:color(band);
        var ordinary=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;var mode=coverage(value);
        var headerForeground=dark?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var valueForeground=band!=null && mode==2?headerForeground:(night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK);
        run.labelBand=band!=null && mode==1?_labelBandHeight:0;
        var label=MaskedText.prepare(_right?cell[Cell.X]+cell[Cell.W]-4-(band==null?0:1):cell[Cell.X]+cell[Cell.W]/2,cell[Cell.Y]+_labelTop,_labels,value[ValueRecord.LABEL],_right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,band==null?0:1);
        var packet=new PreparedCell(night,band,null,band!=null && mode==2?bandColor:ordinary,band!=null && mode==1,bandColor,label,null,null);
        packet.fillBase=packet.background!=_clearBackground;packet.coverage=mode;packet.team=true;packet.lines=[];
        for(var line=0;line<run.lines[0].size();line+=1) {
            packet.lines.add(MaskedText.prepare(_right?cell[Cell.X]+cell[Cell.W]-run.margin-run.lines[1][line]:cell[Cell.X]+(cell[Cell.W]-run.lines[1][line])/2,cell[Cell.Y]+run.top+line*run.size,run.font,run.lines[0][line],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,band!=null && mode==2?1:0));
        }
        if(packet.lines.size()>0) { packet.primary=packet.lines[0]; }
        packet.inner=[cell[Cell.X]+run.inner[0],cell[Cell.Y]+run.inner[1],run.inner[2],run.inner[3]];
        return packet;
    }
    function prepareSeparators() {
        if("none".equals(_settings.gridType)) { _separators=[];return; }
        var key=_cells.size();
        if(!_separatorPlans.hasKey(key)) {
            cacheSeparators(_width,_height,_settings.gridType);_separatorPlans[key]=_separators;
        } else { _separators=_separatorPlans[key]; }
    }
    // Cached groups share their 16 coordinate/color segments across equal spans.
    // Six bytes per segment: prepared uint16 coordinates and two gray intensities.
    // Drawing only decodes these commands; it does not recompute geometry or gradients.
    function cacheSeparators(width,height,gridType) {
        _separators=[];var horizontal="horizontal".equals(gridType);
        var columns={};var rows={};
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];if(c[Cell.ENLARGED]) { continue; }
            if(horizontal || c[Cell.Y]+c[Cell.H]<height) {
                var segments=columns.hasKey(c[Cell.X])?columns[c[Cell.X]]:null;
                if(segments==null) {
                    segments=[]b;
                    for(var step=0;step<16;step+=1) {
                        var start=c[Cell.X]+step*c[Cell.W]/16;var end=c[Cell.X]+(step+1)*c[Cell.W]/16-1;
                        var brightness=horizontal?(step+1)/16.0:1.0-((start+end)/2.0-width/2.0).abs()/(width/2.0);
                        var shade=Numeric.clamp((96*brightness).toNumber(),0,96);
                        segments.addAll([start&255,(start>>8)&255,end&255,(end>>8)&255,shade,255-shade]b);
                    }
                    columns[c[Cell.X]]=segments;
                }
                _separators.add([segments,c[Cell.Y]+c[Cell.H]-1,false]);
            }
            if(!horizontal && c[Cell.X]>0) {
                var vertical=rows.hasKey(c[Cell.Y])?rows[c[Cell.Y]]:null;
                if(vertical==null) {
                    vertical=[]b;
                    for(var line=0;line<16;line+=1) {
                        var y1=c[Cell.Y]+line*c[Cell.H]/16;var y2=c[Cell.Y]+(line+1)*c[Cell.H]/16-1;
                        var brightnessY=1.0-((y1+y2)/2.0-height/2.0).abs()/(height/2.0);
                        var shadeY=Numeric.clamp((96*brightnessY).toNumber(),0,96);
                        vertical.addAll([y1&255,(y1>>8)&255,y2&255,(y2>>8)&255,shadeY,255-shadeY]b);
                    }
                    rows[c[Cell.Y]]=vertical;
                }
                _separators.add([vertical,c[Cell.X],true]);
            }
        }
    }
    function darkBand(name) {
        return "white".equals(name) || "yellow".equals(name) || "cyan".equals(name) || "green".equals(name) || "light_gray".equals(name) || "magenta".equals(name);
    }
    function color(name) {
        if("magenta".equals(name)) { return 0xFF00FF; }
        if("light_gray".equals(name)) { return 0xCCCCCC; } if("dark_gray".equals(name)) { return 0x333333; }
        if("blue".equals(name)) { return Graphics.COLOR_BLUE; } if("green".equals(name)) { return Graphics.COLOR_GREEN; }
        if("yellow".equals(name)) { return Graphics.COLOR_YELLOW; } if("orange".equals(name)) { return Graphics.COLOR_ORANGE; }
        if("red".equals(name)) { return Graphics.COLOR_RED; } if("dark_red".equals(name)) { return Graphics.COLOR_DK_RED; }
        if("cyan".equals(name)) { return 0x00FFFF; } if("white".equals(name)) { return Graphics.COLOR_WHITE; }
        return Graphics.COLOR_BLACK;
    }
    function visibleUnit(dc,cell,value,valueWidth) {
        var expanded=value.size()>ValueRecord.EXPANDEDUNIT?value[ValueRecord.EXPANDEDUNIT]:null;
        var margin=4+(painted(value)?1:0);
        if(expanded!=null && valueWidth+FontMetrics.width(expanded,_labelMetrics)+2<=cell[Cell.W]-2*margin) { return expanded; }
        return value[ValueRecord.UNIT];
    }
    function draw(dc,snapshot,settings) {
        dc.setColor(_clearForeground,_clearBackground);dc.clear();
        if(_cells.size()==0) {
            for(var line=0;line<_compactPackets.size();line+=1) {
                var caption=_compactPackets[line];dc.drawText(caption[0],caption[1],_compactFont,caption[2],Graphics.TEXT_JUSTIFY_CENTER);
            }
            return;
        }
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];var p=_packets[i];var run=_runs[i];
            var bandHeight=run.labelBand;
            dc.setClip(c[Cell.X],c[Cell.Y],c[Cell.W],c[Cell.H]);
            // The screen clear already supplies ordinary cells; paint only differing bases.
            if(p.fillBase) { dc.setColor(p.background,Graphics.COLOR_BLACK);dc.fillRectangle(c[Cell.X],c[Cell.Y],c[Cell.W],c[Cell.H]); }
            if(p.labelEffect) {
                dc.setColor(p.color,Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(c[Cell.X],c[Cell.Y],c[Cell.W],bandHeight);
            }
            if(_polygons[i]!=null) {
                dc.setColor(p.color,Graphics.COLOR_TRANSPARENT);dc.fillPolygon(_polygons[i]);
            }
            if(p.labelEffect) { dc.setClip(c[Cell.X],c[Cell.Y],c[Cell.W],bandHeight); }
            if(p.label!=null) { MaskedText.drawPrepared(dc,p.label); }
            if(p.labelEffect) { dc.setClip(c[Cell.X],c[Cell.Y],c[Cell.W],c[Cell.H]); }
            if(p.team) { for(var line=0;line<p.lines.size();line+=1) { MaskedText.drawPrepared(dc,p.lines[line]); } }
            else if(p.primary!=null) { MaskedText.drawPrepared(dc,p.primary); }
            if(p.unit!=null) { MaskedText.drawPrepared(dc,p.unit); }
            dc.clearClip();
        }
        // APP-22: grid type was prepared before drawing, independently of alignment.
        for(var group=0;group<_separators.size();group+=1) {
            var command=_separators[group];var segments=command[0];var coordinate=command[1];
            for(var j=0;j<segments.size();j+=6) {
                dc.setColor(segments[j+_lineColorIndex]*0x010101,Graphics.COLOR_TRANSPARENT);
                if(command[2]) { dc.drawLine(coordinate,segments[j]+(segments[j+1]<<8),coordinate,segments[j+2]+(segments[j+3]<<8)); }
                else { dc.drawLine(segments[j]+(segments[j+1]<<8),coordinate,segments[j+2]+(segments[j+3]<<8),coordinate); }
            }
        }
    }
}
