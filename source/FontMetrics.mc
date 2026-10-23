// Generated from exact masks; data is profile-specific and byte-packed.
// A per-set char-code table, built once, replaces a substring allocation and glyph search per character.
module FontMetrics {
function numeric(height) { return index(FontData.numeric(height)); }
function label(height) { return index(FontData.label(height)); }
// Appends [table,lowCode]; table[code-low] is glyph index+1, zero when absent.
// Loaders index once; width/bounds require indexed metrics and add no call frame.
function index(metrics) {
if(metrics==null || metrics.size()>4) { return metrics; }
var chars=metrics[0].toCharArray(); var low=chars[0].toNumber(); var high=low;
for(var i=1;i<chars.size();i+=1) { var code=chars[i].toNumber(); if(code<low) { low=code; } if(code>high) { high=code; } }
var table=new [high-low+1]b;
for(var i=0;i<chars.size();i+=1) { table[chars[i].toNumber()-low]=i+1; }
metrics.add(table); metrics.add(low);
return metrics;
}
function width(text,metrics) {
var chars=text.toCharArray(); var table=metrics[4]; var low=metrics[5]; var count=table.size(); var width=0;
for(var i=0;i<chars.size();i+=1) { var g=chars[i].toNumber()-low; g=g>=0 && g<count?table[g]:0;
if(g==0) { return 2147483647; } width+=metrics[3][g-1]; } return width;
}
function bounds(text,metrics) {
var chars=text.toCharArray(); var table=metrics[4]; var low=metrics[5]; var count=table.size();
var top=null; var bottom=0;
for(var i=0;i<chars.size();i+=1) { var g=chars[i].toNumber()-low; g=g>=0 && g<count?table[g]-1:-1;
if(g>=0 && metrics[2][g]>metrics[1][g]) {
if(top==null || metrics[1][g]<top) { top=metrics[1][g]; }
if(metrics[2][g]>bottom) { bottom=metrics[2][g]; }
}}
return [top==null?0:top,bottom];
}
}
