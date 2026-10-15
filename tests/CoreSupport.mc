using Toybox.Test;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.WatchUi;

// Executable tests call production modules. They require the actual Connect IQ simulator.


// Actual resource heights with controlled text measurements reproduce the
// narrow-column fit that previously paired Label21 with Value22.
(:testSupport)
class CaptionFitDc {
    var _height;
    function initialize(height) { _height=height; }
    function getWidth() { return 246; }
    function getHeight() { return _height; }
    function getTextWidthInPixels(text,font) {
        var height=Graphics.getFontHeight(font);
        if("km/h".equals(text)) {
            return height<=13?20:(height<=17?29:43);
        }
        if("99999".equals(text) || "-9.99".equals(text)) {
            return height<=27?55:(height<=42?90:140);
        }
        return text.length()*height/3;
    }
}

(:testSupport)
class DurationDrawDc {
    var mainCount=0;
    var secondaryCount=0;
    var overflowCount=0;
    var _measure;
    var _mainText;
    var _secondaryText;
    var _right;
    var _clip;
    var _mainX;
    var _mainY;
    var _mainWidth;
    var _mainHeight;
    var _mainVisibleTop;
    var _labelHeight;
    function initialize(mainText,secondaryText,right) {
        _measure=new PresentationDrawDc(246,322);
        _mainText=mainText; _secondaryText=secondaryText; _right=right;
    }
    function getWidth() { return profileDrawWidth(); }
    function getHeight() { return profileDrawHeight(); }
    function getTextWidthInPixels(text,font) { return _measure.getTextWidthInPixels(text,font); }
    function setClip(x,y,w,h) { _clip={:x=>x,:y=>y,:w=>w,:h=>h}; }
    function clearClip() {}
    function setColor(a,b) {}
    function clear() {}
    function fillRectangle(x,y,w,h) {}
    function fillPolygon(points) {}
    function drawLine(x1,y1,x2,y2) {}
    function drawText(x,y,font,text,flags) {
        if(PresentationPolicy.OVERFLOW.equals(text)) {
            overflowCount+=1;
            var width=getTextWidthInPixels(text,font);
            Test.assert(x>=_clip[:x]+4 && x+width<=_clip[:x]+_clip[:w]-4);
            return;
        }
        if(_mainText.equals(text)) {
            _mainX=x; _mainY=y; _mainWidth=getTextWidthInPixels(text,font); _mainHeight=Graphics.getFontHeight(font);
            var ink=FontMetrics.bounds(text,FontMetrics.numeric(_mainHeight));
            _mainVisibleTop=y+ink[0];
            var center=_clip[:y]+_labelHeight+(_clip[:h]-_labelHeight)/2.0;
            Test.assert((_mainVisibleTop+(ink[1]-ink[0])/2.0-center).abs()<=1);
            Test.assert(x>=_clip[:x]+4 && x+_mainWidth<=_clip[:x]+_clip[:w]-4);
            Test.assert(_mainVisibleTop>=_clip[:y]+_labelHeight && y+ink[1]<=_clip[:y]+_clip[:h]);
            mainCount+=1;
        } else if(_secondaryText.equals(text)) {
            var secondaryWidth=getTextWidthInPixels(text,font);
            Test.assert(Graphics.getFontHeight(font)<_mainHeight);
            Test.assertEqual(_mainX+_mainWidth+2,x);
            Test.assertEqual(_mainVisibleTop,y+FontMetrics.bounds(text,FontMetrics.label(Graphics.getFontHeight(font)))[0]);
            Test.assert(x+secondaryWidth<=_clip[:x]+_clip[:w]-4);
            var total=_mainWidth+secondaryWidth+2;
            Test.assertEqual(_right?_clip[:x]+_clip[:w]-4-total:_clip[:x]+(_clip[:w]-total)/2,_mainX);
            secondaryCount+=1;
        } else {
            _labelHeight=Graphics.getFontHeight(font);
        }
    }
}


