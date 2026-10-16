using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Math;
// APP-24/28: exactly three fixed profile fonts; measured bounds prevent clipping.
class FieldRenderer {
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
    var _lineColorIndex=5;
    function initialize() {
        _labelBandHeight=FieldPresentation.headerBandHeight(metric(DeviceProfile.LABEL_SIZE,true),_labelTop);
        var line=FontSelection.height(DeviceProfile.LABEL_SIZE,true);
        _headerHeight=line>_labelBandHeight?line:_labelBandHeight;
        _labelMetrics=metric(DeviceProfile.LABEL_SIZE,true);
        _regularMetrics=metric(DeviceProfile.REGULAR_SIZE,false);_bigMetrics=metric(DeviceProfile.BIG_SIZE,false);
    }
    function needsLayout() { return _needsLayout; }
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
        var lm=_labelMetrics;
        var labelFit=_headerFits.hasKey(value[:label])?_headerFits[value[:label]]:null;
        if(labelFit==null) {
            labelFit=[FontMetrics.width(value[:label],lm),FontMetrics.bounds(value[:label],lm)[1]];
            _headerFits[value[:label]]=labelFit;headerMeasures+=1;
        }
        var radius=painted(value)?1:0; var margin=4+radius;
        var labelBand=value[:band]!=null && value[:angle]==null?_labelBandHeight:0;
        if(labelFit[0]>cell[:w]-2*margin) { return null; }
        var size=cell[:enlarged]?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE;
        if(size<=labelSize) { return null; }
            var metrics=cell[:enlarged]?_bigMetrics:_regularMetrics; var ink=FontMetrics.bounds(text,metrics);
            var valueWidth=FontMetrics.width(text,metrics);
            var secondary=unit; var unitWidth=FontMetrics.width(secondary,lm);
            var expanded=value.hasKey(:expandedUnit)?value[:expandedUnit]:null;
            if(!PresentationPolicy.OVERFLOW.equals(text) && expanded!=null && valueWidth+FontMetrics.width(expanded,lm)+2<=cell[:w]-2*margin) {
                secondary=expanded;unitWidth=FontMetrics.width(secondary,lm);
            }
            var total=valueWidth+(unitWidth>0?unitWidth+2:0);
            var top=Numeric.rounded(_headerHeight+(cell[:h]-_headerHeight-(ink[1]-ink[0]))/2.0);
            var unitInk=FontMetrics.bounds(secondary,lm);
            var secondaryHeight=unitInk[1]-unitInk[0];
            if(total<=cell[:w]-2*margin && top>=labelBand && top-radius>=_headerHeight && top-radius>=4+labelFit[1]+radius+2 &&
                top+ink[1]-ink[0]+radius<=cell[:h] && top+secondaryHeight+radius<=cell[:h]) {
                return {:size=>size,:text=>text,:unit=>secondary,:width=>valueWidth,:unitWidth=>unitWidth,
                    :total=>total,:top=>top,:ink=>ink,:unitInk=>unitInk,:margin=>margin,:radius=>radius,:labelBand=>labelBand};
            }
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
                var run=fitRun(cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[:unit]);
                if(run==null && overflow==1) { run=fitRun(cells[i],value,DeviceProfile.LABEL_SIZE,PresentationPolicy.OVERFLOW,""); }
                if(run==null) { break; }
                runs.add(run);
            }
            if(runs.size()==cells.size()) { return [cells,runs,DeviceProfile.LABEL_SIZE]; }
        }
        return null;
    }
    function layout(dc,settings) {
        var width=dc.getWidth();var height=dc.getHeight();
        if(_width!=width || _height!=height) { _geometryDirty=true;_needsLayout=true; }
        _width=width;_height=height;configure(settings);
        if(_needsLayout) { rebuild(); }
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
            for(var i=0;i<_runs.size();i+=1) { _runs[i][:font]=selectFont(_runs[i][:size],false,nextFonts); }
            prepareSeparators();
        }
        _fonts=nextFonts; // discard unused handles, bounded by visible selected variants
        _needsLayout=false;
        prepareGeometry();
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
                    !old[:unit].equals(next[:unit]) || painted(old)!=painted(next) ||
                    (old[:angle]==null)!=(next[:angle]==null) ||
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
            else { refreshRuns(); }
        }
        if(_needsLayout) { rebuild(); } else { prepareGeometry(); }
    }
    function refreshRuns() {
        for(var n=0;n<_dirtyCount;n+=1) {
            var i=_dirtyFields[n];var value=_preparedValues[i];var text=displayText(value);
            var run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,text,PresentationPolicy.OVERFLOW.equals(text)?"":value[:unit]);
            if(run==null) { run=fitRun(_cells[i],value,DeviceProfile.LABEL_SIZE,PresentationPolicy.OVERFLOW,""); }
            if(run==null) { _needsLayout=true;return; }
            run[:font]=_runs[i][:font];_runs[i]=run;_packets[i]=null;
        }
    }
    function prepareGeometry() {
        var paletteChanged=_paletteNight!=_baseNight || _paletteInverse!=_inverse;
        if(paletteChanged) {
            _clearForeground=_baseNight?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
            _clearBackground=_baseNight?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
            _lineColorIndex=_baseNight?4:5;_paletteNight=_baseNight;_paletteInverse=_inverse;
        }
        for(var i=0;i<_cells.size();i+=1) {
            var night=paletteChanged || i>=_cellNights.size()?FieldPresentation.effectiveNight(_baseNight,_cells[i][:enlarged],_inverse):_cellNights[i];
            var value=_preparedValues[i];var packet=i<_packets.size()?_packets[i]:null;
            if(i>=_cellNights.size()) { _cellNights.add(night);_polygons.add(null);_polygonAngles.add(null);_packets.add(null); }
            _cellNights[i]=night;
            if(packet==null || packet[:night]!=night ||
                (packet[:band]==null?value[:band]!=null:(value[:band]==null || !packet[:band].equals(value[:band]))) || packet[:angle]!=value[:angle]) {
                if(_polygonAngles[i]!=value[:angle]) {
                    _polygons[i]=value[:angle]==null?null:Geometry.ground(_cells[i],value[:angle]);
                    _polygonAngles[i]=value[:angle];
                    if(value[:angle]!=null) { polygonBuilds+=1; }
                }
                _packets[i]=preparePacket(i,night);packetBuilds+=1;
            }
        }
    }
    function preparePacket(i,night) {
        var c=_cells[i];var v=_preparedValues[i];var run=_runs[i];
        var background=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var labelEffect=v[:band]!=null && v[:angle]==null;
        var darkText=!labelEffect?!night:("white".equals(v[:band]) || "yellow".equals(v[:band]) || "cyan".equals(v[:band]) || "green".equals(v[:band]) || "light_gray".equals(v[:band]));
        var headerForeground=darkText?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
        var valueForeground=night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
        var radius=v[:angle]!=null?run[:radius]:0;
        var right="right".equals(_settings.alignment);
        var x=right?c[:x]+c[:w]-run[:margin]-run[:total]:c[:x]+(c[:w]-run[:total])/2;
        var label=MaskedText.prepare(right?c[:x]+c[:w]-run[:margin]:c[:x]+c[:w]/2,c[:y]+_labelTop,_labels,v[:label],right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,run[:radius]);
        var primary=MaskedText.prepare(x,c[:y]+run[:top]-run[:ink][0],run[:font],run[:text],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius);
        var unit=run[:unitWidth]>0?MaskedText.prepare(x+run[:width]+2,c[:y]+run[:top]-run[:unitInk][0],_labels,run[:unit],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,radius):null;
        return {:night=>night,:band=>v[:band],:angle=>v[:angle],:background=>background,:labelEffect=>labelEffect,
            :color=>v[:band]==null?null:color(v[:band]),:label=>label,:primary=>primary,:unit=>unit};
    }
    function prepareSeparators() {
        if("none".equals(_settings.gridType)) { _separators=[];return; }
        var key=_cells.size();
        if(!_separatorPlans.hasKey(key)) {
            cacheSeparators(_width,_height,_settings.gridType);_separatorPlans[key]=_separators;
        } else { _separators=_separatorPlans[key]; }
    }
    // Six consecutive scalars per line; retain only the current grid style.
    function cacheSeparators(width,height,gridType) {
        _separators=[];
        var horizontal="horizontal".equals(gridType);
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];if(c[:enlarged]) { continue; }
            for(var step=0;step<16;step+=1) {
                var start=c[:x]+step*c[:w]/16;var end=c[:x]+(step+1)*c[:w]/16-1;
                var brightness=horizontal?(step+1)/16.0:1.0-((start+end)/2.0-width/2.0).abs()/(width/2.0);
                var shade=Numeric.clamp((96*brightness).toNumber(),0,96);var rgb=shade*0x010101;
                if(horizontal || c[:y]+c[:h]<height) { _separators.addAll([start,c[:y]+c[:h]-1,end,c[:y]+c[:h]-1,rgb,0xFFFFFF-rgb]); }
                if(!horizontal && c[:x]>0) {
                    var y1=c[:y]+step*c[:h]/16;var y2=c[:y]+(step+1)*c[:h]/16-1;
                    var vertical=1.0-((y1+y2)/2.0-height/2.0).abs()/(height/2.0);
                    var vshade=Numeric.clamp((96*vertical).toNumber(),0,96);
                    var vrgb=vshade*0x010101;_separators.addAll([c[:x],y1,c[:x],y2,vrgb,0xFFFFFF-vrgb]);
                }
            }
        }
    }
    function color(name) {
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
            var bandHeight=run[:labelBand];
            dc.setClip(c[:x],c[:y],c[:w],c[:h]);dc.setColor(p[:background],Graphics.COLOR_BLACK);dc.fillRectangle(c[:x],c[:y],c[:w],c[:h]);
            if(p[:labelEffect]) {
                dc.setColor(p[:color],Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(c[:x],c[:y],c[:w],bandHeight);
            }
            if(_polygons[i]!=null) {
                dc.setColor(p[:color],Graphics.COLOR_TRANSPARENT);dc.fillPolygon(_polygons[i]);
            }
            if(p[:labelEffect]) { dc.setClip(c[:x],c[:y],c[:w],bandHeight); }
            MaskedText.drawPrepared(dc,p[:label]);
            if(p[:labelEffect]) { dc.setClip(c[:x],c[:y],c[:w],c[:h]); }
            MaskedText.drawPrepared(dc,p[:primary]);
            if(p[:unit]!=null) { MaskedText.drawPrepared(dc,p[:unit]); }
            dc.clearClip();
        }
        // APP-22: grid type was prepared before drawing, independently of alignment.
        for(var j=0;j<_separators.size();j+=6) {
            dc.setColor(_separators[j+_lineColorIndex],Graphics.COLOR_TRANSPARENT);
            dc.drawLine(_separators[j],_separators[j+1],_separators[j+2],_separators[j+3]);
        }
    }
}
