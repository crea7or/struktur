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
    var _labels=null;
    var _labelHeight=0;
    var _labelTop=3;
    var _labelMetrics=null;
    var _compactText="full grid needs larger area";
    var _compactLines=[];
    var _compactFont=null;
    var _compactHeight=0;
    var _compactTop=0;
    var layoutCount=0;
    var fontLoads=0;
    function initialize() {}
    function needsLayout() { return _needsLayout; }
    function painted(value) { return value[:band]!=null || value[:angle]!=null; }
    function numericSizes(enlarged) {
        return [enlarged?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE];
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
        var lm=metric(labelSize,true); var lh=FontSelection.height(labelSize,true);
        var labelInk=FontMetrics.bounds(value[:label],lm);
        var radius=painted(value)?1:0; var margin=4+radius;
        var labelBand=value[:band]!=null && value[:angle]==null?2*_labelTop+labelInk[0]+labelInk[1]:0;
        if(FontMetrics.width(value[:label],lm)>cell[:w]-2*margin) { return null; }
        var sizes=numericSizes(cell[:enlarged]);
        var maximum=cell[:enlarged]?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE;
        for(var i=0;i<sizes.size();i+=1) {
            var size=sizes[i]; if(size>maximum || size<=labelSize) { continue; }
            var metrics=metric(size,false); var ink=FontMetrics.bounds(text,metrics);
            var valueWidth=FontMetrics.width(text,metrics);
            var secondary=unit; var unitWidth=FontMetrics.width(secondary,lm);
            var expanded=value.hasKey(:expandedUnit)?value[:expandedUnit]:null;
            if(!PresentationPolicy.OVERFLOW.equals(text) && expanded!=null && valueWidth+FontMetrics.width(expanded,lm)+2<=cell[:w]-2*margin) {
                secondary=expanded;unitWidth=FontMetrics.width(secondary,lm);
            }
            var total=valueWidth+(unitWidth>0?unitWidth+2:0);
            var top=Numeric.rounded(lh+(cell[:h]-lh-(ink[1]-ink[0]))/2.0);
            var unitInk=FontMetrics.bounds(secondary,lm);
            var secondaryHeight=unitInk[1]-unitInk[0];
            if(total<=cell[:w]-2*margin && top>=labelBand && top-radius>=lh && top-radius>=4+labelInk[1]+radius+2 &&
                top+ink[1]-ink[0]+radius<=cell[:h] && top+secondaryHeight+radius<=cell[:h]) {
                return {:size=>size,:text=>text,:unit=>secondary,:width=>valueWidth,:unitWidth=>unitWidth,
                    :total=>total,:top=>top,:ink=>ink,:unitInk=>unitInk,:margin=>margin,:radius=>radius,:labelBand=>labelBand};
            }
        }
        return null;
    }
    function plan(rows) {
        var cells=Grid.plan(_width,_height,rows,_settings.enlarged);
        var labelSizes=[DeviceProfile.LABEL_SIZE];
        for(var overflow=0;overflow<2;overflow+=1) {
        var best=null;var bestScore=null;
        for(var l=0;l<labelSizes.size();l+=1) {
            var labelSize=labelSizes[l]; if(labelSize>DeviceProfile.LABEL_SIZE) { continue; }
            var runs=[]; var fits=true;var score=0;
            for(var i=0;i<cells.size();i+=1) {
                var value=_preparedValues[i]; var text=displayText(value);
                var unit=PresentationPolicy.OVERFLOW.equals(text)?"":value[:unit];
                var run=fitRun(cells[i],value,labelSize,text,unit);
                if(run==null && overflow==1) { run=fitRun(cells[i],value,labelSize,PresentationPolicy.OVERFLOW,""); }
                if(run==null) { fits=false; break; }
                score+=run[:size];
                if(PresentationPolicy.OVERFLOW.equals(run[:text]) && !PresentationPolicy.OVERFLOW.equals(text)) { score-=10000; }
                runs.add(run);
            }
            // Fonts remain fixed when the value or assigned bounds change.
            if(fits && (bestScore==null || score>bestScore)) { best=[cells,runs,labelSize];bestScore=score; }
        }
        if(best!=null) { return best; }
        }
        return null;
    }
    function layout(dc,settings) {
        _width=dc.getWidth();_height=dc.getHeight();_settings=settings;
        rebuild();
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
        _compactLines=[]; _compactFont=null;
        var sizes=[DeviceProfile.LABEL_SIZE];
        for(var i=0;i<sizes.size();i+=1) {
            var lines=wrapMessage(sizes[i]);
            if(lines!=null) {
                _compactLines=lines;_compactHeight=FontSelection.height(sizes[i],true);
                _compactFont=selectFont(sizes[i],true,nextFonts);
                _compactTop=(_height-lines.size()*_compactHeight)/2;
                return;
            }
        }
        // APP-34: the compact message is never replaced by a value-overflow marker.
        // If the complete message cannot fit, preserve the bounds with background only.
    }
    function rebuild() {
        layoutCount+=1;_cells=[];_runs=[];_separators=[];_polygons=[];
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
            cacheSeparators(_width,_height,_settings.alignment);
        }
        _fonts=nextFonts; // discard unused handles, bounded by visible selected variants
        _needsLayout=false;
        prepareGeometry();
    }
    function prepare(snapshot) {
        for(var i=0;i<snapshot[:values].size();i+=1) {
            var next=snapshot[:values][i];
            if(i>=_preparedValues.size()) { _needsLayout=true; }
            else {
                var old=_preparedValues[i];
                if(!old[:label].equals(next[:label]) || !displayText(old).equals(displayText(next)) ||
                    !old[:unit].equals(next[:unit]) || painted(old)!=painted(next) ||
                    (old[:expandedUnit]==null?next[:expandedUnit]!=null:(next[:expandedUnit]==null || !old[:expandedUnit].equals(next[:expandedUnit])))) { _needsLayout=true; }
            }
        }
        _preparedValues=snapshot[:values];_baseNight=snapshot[:night];_inverse=snapshot[:inverse];
        // compute/settings/background callbacks prepare fonts and metrics, never draw().
        if(_needsLayout && _settings!=null && _width>0 && _height>0) { rebuild(); }
        else { prepareGeometry(); }
    }
    function prepareGeometry() {
        _cellNights=[];_polygons=[];
        for(var i=0;i<_cells.size();i+=1) {
            _cellNights.add(FieldPresentation.effectiveNight(_baseNight,_cells[i][:enlarged],_inverse));
            var angle=_preparedValues[i][:angle];
            _polygons.add(angle==null?null:Geometry.ground(_cells[i],angle));
        }
    }
    function cacheSeparators(width,height,alignment) {
        _separators=[];
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];if(c[:enlarged]) { continue; }
            for(var step=0;step<16;step+=1) {
                var start=c[:x]+step*c[:w]/16;var end=c[:x]+(step+1)*c[:w]/16-1;
                var brightness="right".equals(alignment)?(step+1)/16.0:1.0-((start+end)/2.0-width/2.0).abs()/(width/2.0);
                var shade=Numeric.clamp((96*brightness).toNumber(),0,96);var rgb=shade*0x010101;
                if("right".equals(alignment) || c[:y]+c[:h]<height) { _separators.add([start,c[:y]+c[:h]-1,end,c[:y]+c[:h]-1,rgb]); }
                if("center".equals(alignment) && c[:x]>0) {
                    var y1=c[:y]+step*c[:h]/16;var y2=c[:y]+(step+1)*c[:h]/16-1;
                    var vertical=1.0-((y1+y2)/2.0-height/2.0).abs()/(height/2.0);
                    var vshade=Numeric.clamp((96*vertical).toNumber(),0,96);
                    _separators.add([c[:x],y1,c[:x],y2,vshade*0x010101]);
                }
            }
        }
    }
    function color(name) {
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
        dc.setColor(_baseNight?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,_baseNight?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE);dc.clear();
        if(_cells.size()==0) {
            for(var line=0;line<_compactLines.size();line+=1) {
                dc.drawText(_width/2,_compactTop+line*_compactHeight,_compactFont,_compactLines[line],Graphics.TEXT_JUSTIFY_CENTER);
            }
            return;
        }
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];var v=snapshot[:values][i];var run=_runs[i];var night=_cellNights[i];
            var background=night?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
            var labelEffect=v[:band]!=null && v[:angle]==null;
            var bandHeight=run[:labelBand];
            dc.setClip(c[:x],c[:y],c[:w],c[:h]);dc.setColor(background,Graphics.COLOR_BLACK);dc.fillRectangle(c[:x],c[:y],c[:w],c[:h]);
            if(labelEffect) {
                dc.setColor(color(v[:band]),Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(c[:x],c[:y],c[:w],bandHeight);
            }
            if(v[:angle]!=null && _polygons[i]!=null && _polygons[i].size()>=3) {
                dc.setColor(color(v[:band]),Graphics.COLOR_TRANSPARENT);dc.fillPolygon(_polygons[i]);
            }
            var darkText=!labelEffect?!night:
                ("white".equals(v[:band]) || "yellow".equals(v[:band]) || "cyan".equals(v[:band]) || "green".equals(v[:band]));
            var headerForeground=darkText?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;
            var valueForeground=night?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
            var valueRadius=v[:angle]!=null?run[:radius]:0;
            var right="right".equals(settings.alignment);
            var x=right?c[:x]+c[:w]-run[:margin]-run[:total]:c[:x]+(c[:w]-run[:total])/2;
            if(labelEffect) { dc.setClip(c[:x],c[:y],c[:w],bandHeight); }
            MaskedText.draw(dc,right?c[:x]+c[:w]-run[:margin]:c[:x]+c[:w]/2,c[:y]+_labelTop,_labels,v[:label],
                right?Graphics.TEXT_JUSTIFY_RIGHT:Graphics.TEXT_JUSTIFY_CENTER,headerForeground,run[:radius]);
            if(labelEffect) { dc.setClip(c[:x],c[:y],c[:w],c[:h]); }
            MaskedText.draw(dc,x,c[:y]+run[:top]-run[:ink][0],run[:font],run[:text],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,valueRadius);
            if(run[:unitWidth]>0) {
                MaskedText.draw(dc,x+run[:width]+2,c[:y]+run[:top]-run[:unitInk][0],_labels,run[:unit],Graphics.TEXT_JUSTIFY_LEFT,valueForeground,valueRadius);
            }
            dc.clearClip();
        }
        for(var j=0;j<_separators.size();j+=1) {
            var s=_separators[j];dc.setColor(_baseNight?s[4]:0xFFFFFF-s[4],Graphics.COLOR_TRANSPARENT);dc.drawLine(s[0],s[1],s[2],s[3]);
        }
    }
}
