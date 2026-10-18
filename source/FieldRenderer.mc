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
    var lines;var team=false;var inner;var coverage;var night;var band;var angle;var background;var labelEffect;var color;var label;var primary;var unit;
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
    var _gridPlans={};
    var _separatorPlans={};
    var _geometryDirty=true;
    var _configuredEnlarged=-1;
    var _configuredAlignment=null;
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
    var _lineColorIndex=3;
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
    function coverage(value) { return value.hasKey(:coverage)?value[:coverage]:(value[:angle]!=null?2:1); }
    function isTeam(value) { return "text".equals(value[:format]); }
    function painted(value) { return value[:band]!=null || value[:angle]!=null; }
    function numericSizes(enlarged) {
        return enlarged?_bigSizes:_regularSizes;
    }
    function metric(size,labelRole) {
        var key=(labelRole?"l":"v")+size.toString();
        if(!_metrics.hasKey(key)) {
            var height=FontSelection.height(size,labelRole);
            _metrics[key]=labelRole?FontData.label(height):FontData.numeric(height);
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
        var text=value[:text];
        return text==null?PresentationPolicy.UNAVAILABLE:("overflow".equals(text)?PresentationPolicy.OVERFLOW:text);
    }
    function fitRun(cell,value,labelSize,text,unit) {
        fitCount+=1;
        var labelFit=_headerFits.hasKey(value[:label])?_headerFits[value[:label]]:null;
        if(labelFit==null) {
            labelFit=[FontMetrics.width(value[:label],_labelMetrics),FontMetrics.bounds(value[:label],_labelMetrics)[1]];
            _headerFits[value[:label]]=labelFit;headerMeasures+=1;
        }
        // Keep fitting state in the result object: this path also runs inside
        // settings and typed-lap callbacks with a small VM operand stack.
        var run=new FittedRun(cell[:enlarged]?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE,text,unit,0,0,0,0,null,null);
        run.radius=painted(value)?1:0;run.margin=4+run.radius;
        run.labelBand=value[:band]!=null && value[:angle]==null && coverage(value)==1?_labelBandHeight:0;
        if(labelFit[0]>cell[:w]-2*run.margin || run.size<=labelSize) { return null; }
        var metrics=cell[:enlarged]?_bigMetrics:_regularMetrics;
        run.ink=FontMetrics.bounds(text,metrics);run.width=FontMetrics.width(text,metrics);
        run.unitWidth=FontMetrics.width(run.unit,_labelMetrics);
        var expanded=value.hasKey(:expandedUnit)?value[:expandedUnit]:null;
        if(!PresentationPolicy.OVERFLOW.equals(text) && expanded!=null && run.width+FontMetrics.width(expanded,_labelMetrics)+2<=cell[:w]-2*run.margin) {
            run.unit=expanded;run.unitWidth=FontMetrics.width(expanded,_labelMetrics);
        }
        run.total=run.width+(run.unitWidth>0?run.unitWidth+2:0);
        run.top=Numeric.rounded(_headerHeight+(cell[:h]-_headerHeight-(run.ink[1]-run.ink[0]))/2.0);
        run.unitInk=FontMetrics.bounds(run.unit,_labelMetrics);
        if(run.total<=cell[:w]-2*run.margin && run.top>=run.labelBand && run.top-run.radius>=_headerHeight && run.top-run.radius>=4+labelFit[1]+run.radius+2 &&
            run.top+run.ink[1]-run.ink[0]+run.radius<=cell[:h] && run.top+run.unitInk[1]-run.unitInk[0]+run.radius<=cell[:h]) { return run; }
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
                else { run=fitRun(cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[:unit]); }
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
        _configuredEnlarged=settings.enlarged;_configuredAlignment=settings.alignment;_settings=settings;
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
        _dirtyCount=0;var headersChanged=false;
        for(var i=0;i<snapshot[:values].size();i+=1) {
            var next=snapshot[:values][i];
            var changed=i>=_preparedValues.size();
            if(changed) { _needsLayout=true;headersChanged=true; }
            else {
                var old=_preparedValues[i];
                if(!old[:label].equals(next[:label])) { headersChanged=true; }
                if(!old[:label].equals(next[:label]) || !displayText(old).equals(displayText(next)) ||
                    !old[:unit].equals(next[:unit]) || isTeam(old)!=isTeam(next) ||
                    (isTeam(next) && old[:nativeFont]!=next[:nativeFont]) || (!isTeam(next) && painted(old)!=painted(next)) ||
                    (old[:expandedUnit]==null?next[:expandedUnit]!=null:(next[:expandedUnit]==null || !old[:expandedUnit].equals(next[:expandedUnit])))) { changed=true; }
            }
            // Hidden candidate cells can permit recovery from a smaller fallback.
            // Slots beyond the preferred capacity never affect the current layout.
            if(changed && i<_nativeCapacity) {
                if(_dirtyCount<_dirtyFields.size()) { _dirtyFields[_dirtyCount]=i; } else { _dirtyFields.add(i); }
                _dirtyCount+=1;
            }
        }
        if(headersChanged) {
            var retained={};
            for(var slot=0;slot<snapshot[:values].size();slot+=1) {
                var label=snapshot[:values][slot][:label];
                if(_headerFits.hasKey(label)) { retained[label]=_headerFits[label]; }
            }
            _headerFits=retained;
        }
        _preparedValues=snapshot[:values];_baseNight=snapshot[:night];_inverse=snapshot[:inverse];
        if(_settings==null || _width<=0 || _height<=0) { return; }
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
            else { run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[:unit]); }
            if(run==null) { run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,PresentationPolicy.OVERFLOW,""); }
            if(run==null) { _needsLayout=true;return; }
            if(!run.isNative) { run.font=_runs[i].isNative?selectFont(run.size,false,_fonts):_runs[i].font; } _runs[i]=run;_packets[i]=null;
        }
    }
    function prepareGeometry() {
        var paletteChanged=_paletteNight!=_baseNight || _paletteInverse!=_inverse;
        if(paletteChanged) {
            _clearForeground=_baseNight?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
            _clearBackground=_baseNight?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
            _lineColorIndex=_baseNight?2:3;_paletteNight=_baseNight;_paletteInverse=_inverse;
        }
        for(var i=0;i<_cells.size();i+=1) {
            var night=paletteChanged || i>=_cellNights.size()?FieldPresentation.effectiveNight(_baseNight,_cells[i][:enlarged],_inverse):_cellNights[i];
            var value=_preparedValues[i];var packet=i<_packets.size()?_packets[i]:null;
            if(i>=_cellNights.size()) { _cellNights.add(night);_polygons.add(null);_polygonAngles.add(null);_packets.add(null); }
            _cellNights[i]=night;
            if(packet==null || packet.night!=night ||
                (packet.band==null?value[:band]!=null:(value[:band]==null || !packet.band.equals(value[:band]))) || packet.angle!=value[:angle] || packet.coverage!=coverage(value)) {
                if(_polygonAngles[i]!=value[:angle]) {
                    _polygons[i]=value[:angle]==null?null:Geometry.ground(_cells[i],value[:angle]);
                    _polygonAngles[i]=value[:angle];
                    if(value[:angle]!=null) { polygonBuilds+=1; }
                }
                _packets[i]=_runs[i].isNative?prepareTeam(i,night):preparePacket(i,night);packetBuilds+=1;
            }
        }
    }
    function preparePacket(i,night) {
        var c=_cells[i];var v=_preparedValues[i];var run=_runs[i];
        var background=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var mode=coverage(v);
        var flat=v[:band]!=null && v[:angle]==null;
        var whole=flat && mode==2;
        var labelEffect=flat && mode==1;
        run.labelBand=labelEffect?_labelBandHeight:0;
        var darkText=!flat?!night:("white".equals(v[:band]) || "yellow".equals(v[:band]) || "cyan".equals(v[:band]) || "green".equals(v[:band]) || "light_gray".equals(v[:band]) || "magenta".equals(v[:band]));
        var headerForeground=darkText?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var valueForeground=whole?headerForeground:(night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK);
        var radius=v[:angle]!=null || whole?run.radius:0;
        if(whole) { background=color(v[:band]); }
        var right="right".equals(_settings.alignment);
        var x=right?c[:x]+c[:w]-run.margin-run.total:c[:x]+(c[:w]-run.total)/2;
        var label=MaskedText.prepare(right?c[:x]+c[:w]-run.margin:c[:x]+c[:w]/2,c[:y]+_labelTop,_labels,v[:label],right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,run.radius);
        var primary=MaskedText.prepare(x,c[:y]+run.top-run.ink[0],run.font,run.text,Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius);
        var unit=run.unitWidth>0?MaskedText.prepare(x+run.width+2,c[:y]+run.top-run.unitInk[0],_labels,run.unit,Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius):null;
        var prepared=new PreparedCell(night,v[:band],v[:angle],background,labelEffect,
            v[:band]==null?null:color(v[:band]),label,primary,unit);
        prepared.coverage=mode;return prepared;
    }
    function prepareTeam(i,night) {
        var cell=_cells[i];var value=_preparedValues[i];var run=_runs[i];var band=value[:band];
        var dark=band==null?!night:("white".equals(band) || "yellow".equals(band) || "cyan".equals(band) || "green".equals(band) || "light_gray".equals(band) || "magenta".equals(band));
        var ordinary=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;var mode=coverage(value);
        var headerForeground=dark?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var valueForeground=band!=null && mode==2?headerForeground:(night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK);
        var right="right".equals(_settings.alignment);
        run.labelBand=band!=null && mode==1?_labelBandHeight:0;
        var label=MaskedText.prepare(right?cell[:x]+cell[:w]-4-(band==null?0:1):cell[:x]+cell[:w]/2,cell[:y]+_labelTop,_labels,value[:label],right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,band==null?0:1);
        var packet=new PreparedCell(night,band,null,band!=null && mode==2?color(band):ordinary,band!=null && mode==1,band==null?null:color(band),label,null,null);
        packet.coverage=mode;packet.team=true;packet.lines=[];
        for(var line=0;line<run.lines[0].size();line+=1) {
            packet.lines.add(MaskedText.prepare(right?cell[:x]+cell[:w]-run.margin-run.lines[1][line]:cell[:x]+(cell[:w]-run.lines[1][line])/2,cell[:y]+run.top+line*run.size,run.font,run.lines[0][line],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,band!=null && mode==2?1:0));
        }
        if(packet.lines.size()>0) { packet.primary=packet.lines[0]; }
        packet.inner=[cell[:x]+run.inner[0],cell[:y]+run.inner[1],run.inner[2],run.inner[3]];
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
    // Drawing dispatches these values directly; no unpacking or geometry arithmetic.
    function cacheSeparators(width,height,gridType) {
        _separators=[];var horizontal="horizontal".equals(gridType);
        var columns={};var rows={};
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];if(c[:enlarged]) { continue; }
            if(horizontal || c[:y]+c[:h]<height) {
                var segments=columns.hasKey(c[:x])?columns[c[:x]]:null;
                if(segments==null) {
                    segments=[];
                    for(var step=0;step<16;step+=1) {
                        var start=c[:x]+step*c[:w]/16;var end=c[:x]+(step+1)*c[:w]/16-1;
                        var brightness=horizontal?(step+1)/16.0:1.0-((start+end)/2.0-width/2.0).abs()/(width/2.0);
                        var shade=Numeric.clamp((96*brightness).toNumber(),0,96);var rgb=shade*0x010101;
                        segments.addAll([start,end,rgb,0xFFFFFF-rgb]);
                    }
                    columns[c[:x]]=segments;
                }
                _separators.add([segments,c[:y]+c[:h]-1,false]);
            }
            if(!horizontal && c[:x]>0) {
                var vertical=rows.hasKey(c[:y])?rows[c[:y]]:null;
                if(vertical==null) {
                    vertical=[];
                    for(var line=0;line<16;line+=1) {
                        var y1=c[:y]+line*c[:h]/16;var y2=c[:y]+(line+1)*c[:h]/16-1;
                        var brightnessY=1.0-((y1+y2)/2.0-height/2.0).abs()/(height/2.0);
                        var shadeY=Numeric.clamp((96*brightnessY).toNumber(),0,96);var colorY=shadeY*0x010101;
                        vertical.addAll([y1,y2,colorY,0xFFFFFF-colorY]);
                    }
                    rows[c[:y]]=vertical;
                }
                _separators.add([vertical,c[:x],true]);
            }
        }
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
        var expanded=value.hasKey(:expandedUnit)?value[:expandedUnit]:null;
        var margin=4+(painted(value)?1:0);
        if(expanded!=null && valueWidth+FontMetrics.width(expanded,_labelMetrics)+2<=cell[:w]-2*margin) { return expanded; }
        return value[:unit];
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
            dc.setClip(c[:x],c[:y],c[:w],c[:h]);dc.setColor(p.background,Graphics.COLOR_BLACK);dc.fillRectangle(c[:x],c[:y],c[:w],c[:h]);
            if(p.labelEffect) {
                dc.setColor(p.color,Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(c[:x],c[:y],c[:w],bandHeight);
            }
            if(_polygons[i]!=null) {
                dc.setColor(p.color,Graphics.COLOR_TRANSPARENT);dc.fillPolygon(_polygons[i]);
            }
            if(p.labelEffect) { dc.setClip(c[:x],c[:y],c[:w],bandHeight); }
            if(p.label!=null) { MaskedText.drawPrepared(dc,p.label); }
            if(p.labelEffect) { dc.setClip(c[:x],c[:y],c[:w],c[:h]); }
            if(p.team) { for(var line=0;line<p.lines.size();line+=1) { MaskedText.drawPrepared(dc,p.lines[line]); } }
            else if(p.primary!=null) { MaskedText.drawPrepared(dc,p.primary); }
            if(p.unit!=null) { MaskedText.drawPrepared(dc,p.unit); }
            dc.clearClip();
        }
        // APP-22: grid type was prepared before drawing, independently of alignment.
        for(var group=0;group<_separators.size();group+=1) {
            var command=_separators[group];var segments=command[0];var coordinate=command[1];
            for(var j=0;j<segments.size();j+=4) {
                dc.setColor(segments[j+_lineColorIndex],Graphics.COLOR_TRANSPARENT);
                if(command[2]) { dc.drawLine(coordinate,segments[j],coordinate,segments[j+1]); }
                else { dc.drawLine(segments[j],coordinate,segments[j+1],coordinate); }
            }
        }
    }
}
