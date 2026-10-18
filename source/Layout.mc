using Toybox.Math;
// APP-20: pure logical geometry. Row eligibility is supplied by font-fit measurements.
module Grid {
    function capacity(rows, big) { return rows * 2 - big * 3; }
    function plan(width, height, rows, requestedBig) {
        if (rows != 4 && rows != 5) { return []; }
        var big = Numeric.clamp(requestedBig, 0, 2);
        // APP-20: only full-capacity combinations; there is no partial count.
        var count = capacity(rows,big);
        var cells = [];
        for (var i = 0; i < count; i += 1) {
            var row; var col; var rowSpan; var colSpan;
            if (i < big) { row = i * 2; col = 0; rowSpan = 2; colSpan = 2; }
            else { var regular = i - big; row = big * 2 + regular / 2; col = regular % 2; rowSpan = 1; colSpan = 1; }
            var left = (col * width / 2).toNumber(); var top = (row * height / rows).toNumber();
            var right = ((col + colSpan) * width / 2).toNumber(); var bottom = ((row + rowSpan) * height / rows).toNumber();
            cells.add({:x=>left,:y=>top,:w=>right-left,:h=>bottom-top,:enlarged=>i<big});
        }
        return cells;
    }
}
