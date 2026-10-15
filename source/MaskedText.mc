using Toybox.Graphics;

// DVS-6: transparent glyph contours, never rectangular text panels.
module MaskedText {
    function prepare(x,y,font,text,flags,foreground,radius) {
        var outline=radius>0?[x-1,x+1,y-1,y+1,foreground==Graphics.COLOR_BLACK?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK]:null;
        return [x,y,font,text,flags,foreground,outline];
    }
    // All positions, contrast and contour offsets were prepared before drawing.
    function drawPrepared(dc,p) {
        var o=p[6];
        if(o!=null) {
            dc.setColor(o[4],Graphics.COLOR_TRANSPARENT);
            dc.drawText(o[0],o[2],p[2],p[3],p[4]);dc.drawText(p[0],o[2],p[2],p[3],p[4]);dc.drawText(o[1],o[2],p[2],p[3],p[4]);
            dc.drawText(o[0],p[1],p[2],p[3],p[4]);dc.drawText(o[1],p[1],p[2],p[3],p[4]);
            dc.drawText(o[0],o[3],p[2],p[3],p[4]);dc.drawText(p[0],o[3],p[2],p[3],p[4]);dc.drawText(o[1],o[3],p[2],p[3],p[4]);
        }
        dc.setColor(p[5],Graphics.COLOR_TRANSPARENT);dc.drawText(p[0],p[1],p[2],p[3],p[4]);
    }
}
