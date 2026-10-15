using Toybox.Graphics;

// DVS-6: transparent glyph contours, never rectangular text panels.
module MaskedText {
    function draw(dc,x,y,font,text,flags,foreground,radius) {
        if(radius>0) {
            dc.setColor(foreground==Graphics.COLOR_BLACK?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
            // Eight translations dilate the opaque glyph mask by one pixel.
            // Font transparency preserves every pixel outside that contour.
            for(var dy=-1;dy<=1;dy+=1) {
                for(var dx=-1;dx<=1;dx+=1) {
                    if(dx!=0 || dy!=0) { dc.drawText(x+dx,y+dy,font,text,flags); }
                }
            }
        }
        dc.setColor(foreground,Graphics.COLOR_TRANSPARENT);
        dc.drawText(x,y,font,text,flags);
    }
}
