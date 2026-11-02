using Toybox.Graphics;

// DVS-6: transparent glyph contours, never rectangular text panels.
module MaskedText {
    // API 4+ profiles pass the role's build-time outline font (one-pixel dilated glyphs);
    // API 3 profiles and native Team text pass null and keep the eight shifted draws.
    function prepare(x,y,font,text,flags,foreground,radius,outlineFont) {
        var outline=radius<=0?null:(outlineFont!=null?[foreground==Graphics.COLOR_BLACK?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,outlineFont]:
            [x-1,x+1,y-1,y+1,foreground==Graphics.COLOR_BLACK?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK]);
        return [x,y,font,text,flags,foreground,outline];
    }
    // All positions, contrast and contour offsets were prepared before drawing.
    function drawPrepared(dc,p) {
        var o=p[6];
        if(o!=null && o.size()==2) { dc.setColor(o[0],Graphics.COLOR_TRANSPARENT);dc.drawText(p[0],p[1],o[1],p[3],p[4]); }
        else if(o!=null) {
            dc.setColor(o[4],Graphics.COLOR_TRANSPARENT);
            dc.drawText(o[0],o[2],p[2],p[3],p[4]);dc.drawText(p[0],o[2],p[2],p[3],p[4]);dc.drawText(o[1],o[2],p[2],p[3],p[4]);
            dc.drawText(o[0],p[1],p[2],p[3],p[4]);dc.drawText(o[1],p[1],p[2],p[3],p[4]);
            dc.drawText(o[0],o[3],p[2],p[3],p[4]);dc.drawText(p[0],o[3],p[2],p[3],p[4]);dc.drawText(o[1],o[3],p[2],p[3],p[4]);
        }
        dc.setColor(p[5],Graphics.COLOR_TRANSPARENT);dc.drawText(p[0],p[1],p[2],p[3],p[4]);
    }
}
