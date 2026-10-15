using Toybox.Test;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.WatchUi;

(:testSupport)
function verifyEffectDefaultContract() {
    var settings=new DisplaySettings();
    for(var initial=0;initial<10;initial+=1) { Test.assertEqual(false,settings.effects[initial]); }
    Test.assertEqual(true,settings.hideValueUnits);Test.assertEqual(true,settings.inverseEnlargedTheme);
    var invalid=[null,0,1,"true","false",1.0];
    var properties={"enlarged_field_count"=>2};
    for(var candidate=0;candidate<invalid.size();candidate+=1) {
        for(var slot=1;slot<=10;slot+=1) { properties["slot_"+slot.toString()+"_background_effects"]=invalid[candidate]; }
        settings.apply(properties);
        for(var index=0;index<10;index+=1) { Test.assertEqual(false,settings.effects[index]); }
    }
    for(var saved=1;saved<=10;saved+=1) {
        properties["slot_"+saved.toString()+"_value"]="power_3s";
        properties["slot_"+saved.toString()+"_background_effects"]=saved%2==0;
    }
    settings.apply(properties);
    var restarted=new DisplaySettings();restarted.apply(properties);
    for(var retained=0;retained<10;retained+=1) {
        Test.assertEqual(retained%2==1,settings.effects[retained]);
        Test.assertEqual(settings.effects[retained],restarted.effects[retained]);
    }
    properties["enlarged_field_count"]=0;properties["slot_10_value"]="grade";
    restarted.apply(properties);
    Test.assertEqual(true,restarted.effects[9]);Test.assertEqual(false,restarted.effects[0]);
    Test.assertEqual("grade",restarted.slots[9]);
}

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


