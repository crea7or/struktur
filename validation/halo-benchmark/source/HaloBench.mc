using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

// Halo drawing benchmark: separate app ID/name, never installed over Struktur.
// A = eight shifted runtime draws (current production), B = build-time outline
// font, C = no halo (baseline). Each update times all three on the same frame.
class HaloBenchApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() { return [new HaloBenchField()]; }
}

class HaloBenchField extends WatchUi.DataField {
    const FRAMES=3; // per method and update; keeps each update well inside the watchdog budget
    var _base;var _outline;var _texts=null;var _cells=null;
    var _totals=[0,0,0];var _frames=0;var _updates=0;var _baseBytes=null;var _outlineBytes=null;

    function initialize() {
        DataField.initialize();
        // Heap cost of each font set; pre-API-4 devices load fonts into the app heap.
        var before=System.getSystemStats().freeMemory;
        _base=[WatchUi.loadResource(Rez.Fonts.Big),WatchUi.loadResource(Rez.Fonts.Regular),WatchUi.loadResource(Rez.Fonts.Label)];
        var middle=System.getSystemStats().freeMemory;
        _outline=[WatchUi.loadResource(Rez.Fonts.BigOutline),WatchUi.loadResource(Rez.Fonts.RegularOutline),WatchUi.loadResource(Rez.Fonts.LabelOutline)];
        _baseBytes=before-middle;_outlineBytes=middle-System.getSystemStats().freeMemory;
    }

    function compute(info) {}

    // One enlarged + six regular cells, Whole-cell coverage on every cell.
    function onLayout(dc) {
        var w=dc.getWidth();var h=dc.getHeight();var row=h/5;
        var fills=[Graphics.COLOR_BLUE,Graphics.COLOR_GREEN,Graphics.COLOR_YELLOW,Graphics.COLOR_ORANGE,Graphics.COLOR_RED,0xFF00FF,0xAA00AA];
        var dark=[false,true,true,false,false,true,false]; // APP-36 contrast: black text on light fills
        var labels=["speed","watts","heart rate","cadence","slope","distance","timer"];
        var values=["35.2","287","162","91","-4.5","123.4","1:23"];var units=["","","","","","",".45"];
        _cells=[];_texts=[];
        for(var i=0;i<7;i+=1) {
            var x=i==0?0:((i-1)%2)*(w/2);var y=i==0?0:row*(2+(i-1)/2);
            var cw=i==0?w:w/2;var ch=i==0?2*row:row;
            _cells.add([x,y,cw,ch,fills[i]]);
            var fg=dark[i]?Graphics.COLOR_BLACK:Graphics.COLOR_WHITE;var halo=dark[i]?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK;
            var font=i==0?0:1;
            var labelWidth=dc.getTextWidthInPixels(labels[i],_base[2]);
            _texts.add([x+cw-5-labelWidth,y+3,2,labels[i],fg,halo]);
            var valueWidth=dc.getTextWidthInPixels(values[i],_base[font]);
            var unitWidth=units[i].length()>0?dc.getTextWidthInPixels(units[i],_base[2])+2:0;
            var fh=Graphics.getFontHeight(_base[font]);var lh=Graphics.getFontHeight(_base[2]);
            var vx=x+cw-5-valueWidth-unitWidth;var vy=y+lh+(ch-lh-fh)/2;
            _texts.add([vx,vy,font,values[i],fg,halo]);
            if(unitWidth>0) { _texts.add([vx+valueWidth+2,vy+(fh-lh)*4/5,2,units[i],fg,halo]); }
        }
    }

    function fillCells(dc) {
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_WHITE);dc.clear();
        for(var i=0;i<_cells.size();i+=1) {
            var c=_cells[i];dc.setColor(c[4],c[4]);dc.fillRectangle(c[0],c[1],c[2],c[3]);
        }
    }

    function drawFrame(dc,method) {
        fillCells(dc);
        for(var i=0;i<_texts.size();i+=1) {
            var t=_texts[i];var x=t[0];var y=t[1];var font=_base[t[2]];var text=t[3];
            if(method==0) {
                dc.setColor(t[5],Graphics.COLOR_TRANSPARENT);
                dc.drawText(x-1,y-1,font,text,Graphics.TEXT_JUSTIFY_LEFT);dc.drawText(x,y-1,font,text,Graphics.TEXT_JUSTIFY_LEFT);
                dc.drawText(x+1,y-1,font,text,Graphics.TEXT_JUSTIFY_LEFT);dc.drawText(x-1,y,font,text,Graphics.TEXT_JUSTIFY_LEFT);
                dc.drawText(x+1,y,font,text,Graphics.TEXT_JUSTIFY_LEFT);dc.drawText(x-1,y+1,font,text,Graphics.TEXT_JUSTIFY_LEFT);
                dc.drawText(x,y+1,font,text,Graphics.TEXT_JUSTIFY_LEFT);dc.drawText(x+1,y+1,font,text,Graphics.TEXT_JUSTIFY_LEFT);
            } else if(method==1) {
                dc.setColor(t[5],Graphics.COLOR_TRANSPARENT);dc.drawText(x,y,_outline[t[2]],text,Graphics.TEXT_JUSTIFY_LEFT);
            }
            dc.setColor(t[4],Graphics.COLOR_TRANSPARENT);dc.drawText(x,y,font,text,Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function onUpdate(dc) {
        if(_cells==null) { onLayout(dc); }
        // Rotate the starting method each update so caching/warm-up favors none of them.
        for(var k=0;k<3;k+=1) {
            var method=(k+_updates)%3;var started=System.getTimer();
            for(var n=0;n<FRAMES;n+=1) { drawFrame(dc,method); }
            _totals[method]+=System.getTimer()-started;
        }
        _frames+=FRAMES;_updates+=1;
        // Visible frame alternates A/B every five updates for an eyeball comparison.
        var shown=(_updates/5)%2;drawFrame(dc,shown);
        var a=_totals[0].toFloat()/_frames;var b=_totals[1].toFloat()/_frames;var c=_totals[2].toFloat()/_frames;
        var line1="A "+a.format("%.1f")+"  B "+b.format("%.1f")+"  C "+c.format("%.1f")+" ms";
        var line2="halo A "+(a-c).format("%.1f")+" B "+(b-c).format("%.1f")+"  n="+_frames+(shown==0?" [A]":" [B]");
        var h=dc.getHeight();
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);dc.fillRectangle(0,h-40,dc.getWidth(),40);
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.drawText(4,h-40,Graphics.FONT_XTINY,line1,Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(4,h-20,Graphics.FONT_XTINY,line2,Graphics.TEXT_JUSTIFY_LEFT);
        if(_updates%10==0) {
            System.println("HALO_BENCH frames="+_frames+" A_ms="+a.format("%.2f")+" B_ms="+b.format("%.2f")+" C_ms="+c.format("%.2f")+" base_heap_bytes="+_baseBytes+" outline_heap_bytes="+_outlineBytes+" free="+System.getSystemStats().freeMemory);
        }
    }
}
