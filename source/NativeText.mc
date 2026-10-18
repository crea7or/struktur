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
// the supplied layout Dc; no text bitmap, extra atlas or retained width ladder. AUX faces remain
// unqualified in the pinned device libraries; retain logical saved selections.
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
    var _paddingX;var _paddingY;var _availableW;var _availableH;
    var _text;var _selected;var _size;var _measured;
    function select() {
        var chosen=null;
        for(var i=0;i<candidates.size();i+=1) {
            var candidate=candidates[i];
            if(candidate[1]+2<=_availableH && width(_text,candidate[0])+2<=_availableW &&
                (chosen==null || candidate[1]>chosen[1] || (candidate[1]==chosen[1] && candidate[0]<chosen[0]))) { chosen=candidate; }
        }
        return chosen;
    }
    function fit(cell,value) {
        _paddingX=Math.ceil(cell[:w]*0.05).toNumber();_paddingY=Math.ceil(cell[:h]*0.05).toNumber();
        _availableW=cell[:w]-2*_paddingX;_availableH=cell[:h]-2*_paddingY;
        if(_availableW<0) { _availableW=0; } if(_availableH<0) { _availableH=0; }
        _text=value[:text];_selected=select();
        if(_selected==null && _text.length()>0) { _text=PresentationPolicy.OVERFLOW;_selected=select(); }
        if(_selected==null) { _text="";_selected=candidates.size()>0?candidates[0]:[Graphics.FONT_XTINY,0]; }
        _size=_text.length()==0?0:_selected[1];_measured=_text.length()==0?0:width(_text,_selected[0]);
        var run=new FittedRun(_size,_text,"",_measured,0,_measured,_paddingY+(_availableH-_size)/2,[0,_size],[0,0]);
        run.isNative=true;run.font=_selected[0];run.radius=1;run.margin=_paddingX+1;run.labelBand=0;run.inner=[_paddingX,_paddingY,_availableW,_availableH];
        _text=null;return run;
    }
}
