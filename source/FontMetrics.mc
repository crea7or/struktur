// Generated from exact masks; data is profile-specific and byte-packed.
module FontMetrics {
function numeric(height) { return FontData.numeric(height); }
function label(height) { return FontData.label(height); }
function width(text,metrics) {
var width=0; for(var i=0;i<text.length();i+=1) { var index=metrics[0].find(text.substring(i,i+1));
if(index==null) { return 2147483647; } width+=metrics[3][index]; } return width;
}
function bounds(text,metrics) {
var top=null; var bottom=0;
for(var i=0;i<text.length();i+=1) { var index=metrics[0].find(text.substring(i,i+1));
if(index!=null && metrics[2][index]>metrics[1][index]) {
if(top==null || metrics[1][index]<top) { top=metrics[1][index]; }
if(metrics[2][index]>bottom) { bottom=metrics[2][index]; }
}}
return [top==null?0:top,bottom];
}
}
