using Toybox.Math;
// APP-26/DVS-29: clipped polygon points are prepared outside onUpdate; at most eight vertices.
module Geometry {
    function clip(points,axis,limit,less) {
        var out=[];
        if(points.size()==0) { return out; }
        var previous=points[points.size()-1];
        var previousInside=less?previous[axis]<=limit:previous[axis]>=limit;
        for(var i=0;i<points.size();i+=1) {
            var current=points[i];var currentInside=less?current[axis]<=limit:current[axis]>=limit;
            if(currentInside!=previousInside) {
                var t=(limit-previous[axis]).toFloat()/(current[axis]-previous[axis]);
                var intersection=[previous[0]+t*(current[0]-previous[0]),previous[1]+t*(current[1]-previous[1])];
                intersection[axis]=limit;out.add(intersection);
            }
            if(currentInside) { out.add(current); }
            previous=current;previousInside=currentInside;
        }
        return out;
    }
    function sky(cell,angle) { return horizonRegion(cell,angle,true); }
    function ground(cell,angle) { return horizonRegion(cell,angle,false); }
    function horizonRegion(cell,angle,above) {
        var left=cell[:x];var right=left+cell[:w]-1;
        var top=cell[:y];var bottom=top+cell[:h]-1;
        var center=(top+bottom)/2.0;var delta=Math.tan(angle*Math.PI/180.0)*(right-left)/2.0;
        var points=above?[[left,top],[right,top],[right,center-delta],[left,center+delta]]:
            [[left,center+delta],[right,center-delta],[right,bottom],[left,bottom]];
        points=clip(points,0,left,false);points=clip(points,0,right,true);
        points=clip(points,1,top,false);points=clip(points,1,bottom,true);
        for(var i=0;i<points.size();i+=1) { points[i][0]=points[i][0].toNumber();points[i][1]=points[i][1].toNumber(); }
        return points;
    }
}
