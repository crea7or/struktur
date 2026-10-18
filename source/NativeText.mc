using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
module TeamOptions {
    const REPERTOIRE=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    function text(value) {
        if(!(value instanceof Lang.String) || value.length()>32) { return "TEAM"; }
        for(var i=0;i<value.length();i+=1) { if(REPERTOIRE.find(value.substring(i,i+1))==null) { return "TEAM"; } }
        return value;
    }
    function code(value,maximum) { return value instanceof Lang.Number && value>=0 && value<=maximum?value:0; }
}
// Standard system text fonts are the portable candidates. Measurements use
// the current layout Dc only; clear it before the callback returns. No text bitmap,
// extra atlas, retained width ladder or user font-selection property.
class NativeTextCache {
    var candidates=[];var measurements=0;var _dc;
    function initialize() {
        var fonts=[Graphics.FONT_XTINY,Graphics.FONT_TINY,Graphics.FONT_SMALL,Graphics.FONT_MEDIUM,Graphics.FONT_LARGE];
        for(var i=0;i<fonts.size();i+=1) {
            try { var height=Graphics.getFontHeight(fonts[i]);if(height>0) { candidates.add([fonts[i],height]); } } catch(e) {}
        }
    }
    function setContext(dc) { _dc=dc; }
    function width(text,font) { measurements+=1;return _dc.getTextWidthInPixels(text,font); }
    // Bounded scratch fields keep nested lap callbacks below legacy VM stack limits.
    // Clear the temporary string after fitting so replaced Team text is not retained.
    var headerHeight=0;var headerWidth=0;
    var _paddingX;var _paddingY;var _availableW;var _availableH;
    var _text;var _selected;var _size;var _measured;
    var _wrapped;var _widths;var _maxWidth;
    // Greedy wrapping at ASCII spaces only. Keep intra-line spacing; consume
    // the separator spaces at a line boundary without splitting a word.
    var _rest;var _lineWidth;var _end;var _next;var _scan;
    var _fits;
    function select() {
        var chosen=null;
        for(var i=0;i<candidates.size();i+=1) {
            var candidate=candidates[i];
            _wrapped=[];_widths=[];_maxWidth=0;_rest=_text;_fits=true;
            while(_rest.length()>0) {
                measurements+=1;_lineWidth=_dc.getTextWidthInPixels(_rest,candidate[0]);_end=_rest.length();_next=_end;
                if(_lineWidth+2>_availableW) {
                    _end=-1;
                    for(_scan=1;_scan<_rest.length();_scan+=1) {
                        if(_rest.substring(_scan,_scan+1).equals(" ") && !_rest.substring(_scan-1,_scan).equals(" ")) {
                            measurements+=1;
                            if(_dc.getTextWidthInPixels(_rest.substring(0,_scan),candidate[0])+2<=_availableW) { _end=_scan; }
                        }
                    }
                    if(_end<0) { _fits=false;break; }
                    _next=_end;while(_next<_rest.length() && _rest.substring(_next,_next+1).equals(" ")) { _next+=1; }
                    measurements+=1;_lineWidth=_dc.getTextWidthInPixels(_rest.substring(0,_end),candidate[0]);
                }
                _wrapped.add(_rest.substring(0,_end));_widths.add(_lineWidth);
                if(_lineWidth>_maxWidth) { _maxWidth=_lineWidth; }
                _rest=_next>=_rest.length()?"":_rest.substring(_next,_rest.length());
            }
            if(_fits && _wrapped.size()*candidate[1]+2<=_availableH &&
                (chosen==null || candidate[1]>chosen[1] || (candidate[1]==chosen[1] && candidate[0]<chosen[0]))) {
                chosen=[candidate[0],candidate[1],_wrapped,_widths,_maxWidth];
            }
        }
        return chosen;
    }
    function fit(cell,value) {
        if(headerWidth>0 && (cell[:w]<headerWidth+10 || cell[:h]<headerHeight)) { return null; }
        _paddingX=Math.ceil(cell[:w]*0.05).toNumber();_paddingY=Math.ceil(cell[:h]*0.05).toNumber();
        _availableW=cell[:w]-2*_paddingX;_availableH=cell[:h]-headerHeight-2*_paddingY;
        if(_availableW<0) { _availableW=0; } if(_availableH<0) { _availableH=0; }
        _text=value[:text];_selected=select();
        if(_selected==null && _text.length()>0) { _text=PresentationPolicy.OVERFLOW;_selected=select(); }
        if(_selected==null) { _text="";_selected=[Graphics.FONT_XTINY,0,[],[],0]; }
        _size=_text.length()==0?0:_selected[1];_measured=_selected[4];
        var run=new FittedRun(_size,_text,"",_measured,0,_measured,headerHeight+_paddingY+(_availableH-_size*_selected[2].size())/2,[0,_size],[0,0]);
        run.isNative=true;run.font=_selected[0];run.lines=[_selected[2],_selected[3]];run.radius=1;run.margin=_paddingX+1;
        run.inner=[_paddingX,headerHeight+_paddingY,_availableW,_availableH];
        _text=null;_rest=null;_selected=null;_wrapped=null;_widths=null;return run;
    }
}
