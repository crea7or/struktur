using Toybox.Test;
using Toybox.Math;
using Toybox.WatchUi;

// Independent formatting oracles include values outside the narrower display
// guarantees. Formatting correctness never implies that a value fits every cell.
// Synthetic input does not qualify sensor acquisition.
(:testSupport)
module NormalDisplayFixtures {
    function cases() { return DATA; }
    const DATA = [["current_speed", [0, 36.5, 200], ["0.00", "36.5", "200"]], ["average_speed", [0, 36.5, 200], ["0.00", "36.5", "200"]], ["current_cadence", [0, 90, 250], ["0", "90", "250"]], ["average_cadence", [0, 90, 250], ["0", "90", "250"]], ["current_heart_rate", [30, 150, 250], ["30", "150", "250"]], ["average_heart_rate", [30, 150, 250], ["30", "150", "250"]], ["heart_rate_zone", [1, 3, 5], ["1", "3", "5"]], ["current_power", [0, 250, 3000], ["0", "250", "3000"]], ["power_3s", [0, 250, 3000], ["0", "250", "3000"]], ["average_power", [0, 250, 3000], ["0", "250", "3000"]], ["power_zone", [1, 4, 7], ["1", "4", "7"]], ["distance", [0, 42.12, 1000], ["0.00", "42.1", "1000"]], ["elevation", [-1000, 1785.6, 9999], ["-1000", "1786", "9999"]], ["total_ascent", [0, 1234, 99999], ["0", "1234", "99999"]], ["total_descent", [0, 1234, 99999], ["0", "1234", "99999"]], ["grade", [-99.9, 5.1, 99.9], ["-99.9", "5.1", "99.9"]], ["activity_timer", [0, 35999000, 359999000], ["00", "9:59", "99:59"]], ["elapsed_time", [0, 35999000, 359999000], ["00", "9:59", "99:59"]], ["time_of_day", [0, 485, 1439], ["00:00", "08:05", "23:59"]], ["calories", [0, 1234, 99999], ["0", "1234", "99999"]], ["temperature", [-40, 12.34, 60], ["-40.0", "12.3", "60.0"]], ["battery", [0, 50, 100], ["0", "50", "100"]], ["heading", [0, 180, 359], ["0", "180", "359"]], ["distance_next_waypoint", [0, 42.12, 1000], ["0.00", "42.1", "1000"]], ["completed_laps", [0, 123, 999], ["0", "123", "999"]], ["heart_rate_3s", [30, 150, 250], ["30", "150", "250"]], ["lap_distance", [0, 42.12, 1000], ["0.00", "42.1", "1000"]], ["lap_time", [0, 35999000, 359999000], ["00", "9:59", "99:59"]], ["lap_speed", [0, 36.5, 200], ["0.00", "36.5", "200"]], ["lap_heart_rate", [30, 150, 250], ["30", "150", "250"]], ["lap_power", [0, 250, 3000], ["0", "250", "3000"]], ["lap_cadence", [0, 90, 250], ["0", "90", "250"]]];
}


(:test)
function normalRangeFormatting(logger) {
    var cases=NormalDisplayFixtures.cases();
    Test.assertEqual(Catalog.IDS.size()-1,cases.size());
    var engine=new SnapshotEngine();var settings=new DisplaySettings();var clock=new PresentationClock();
    for(var i=0;i<cases.size();i+=1) {
        Test.assertEqual(Catalog.IDS[i],cases[i][0]);
        for(var statute=0;statute<2;statute+=1) {
            for(var sample=0;sample<3;sample+=1) {
                var displayed=cases[i][1][sample];var expected=cases[i][2][sample];
                if(i==20 && statute==1) { displayed=sample==0?-40:(sample==1?70.5:140);expected=sample==0?"-40.0":(sample==1?"70.5":"140.0"); }
                settings.apply({"a1"=>Catalog.IDS[i]});
                var raw={};raw[Catalog.IDS[i]]=normalDisplayRaw(i,displayed,statute==1);
                if("clock".equals(Catalog.FORMATS[i])) { clock.hour=displayed/60;clock.min=displayed%60; }
                var value=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(statute==1,true,false),clock)[:values][0];
                Test.assertEqual(expected,value[ValueRecord.TEXT]);
                if("clock".equals(Catalog.FORMATS[i])) {
                    var twelve=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(statute==1,false,false),clock)[:values][0];
                    Test.assertEqual(sample==0?"12:00":(sample==1?"8:05":"11:59"),twelve[ValueRecord.TEXT]);
                }
                if("duration".equals(Catalog.FORMATS[i])) { Test.assertEqual(sample==0?".00":(sample==1?".59":""),value[ValueRecord.UNIT]); }
            }
        }
    }
    return true;
}

// Every declared interval is required. Documented contexts with no guarantee are
// counted explicitly and exercised by the separately requested Placement suite.
(:testSupport)
function smallestNormalCell(enlarged) {
    var selected=null;
    for(var big=0;big<=2;big+=1) {
        var cells=Grid.plan(profileDrawWidth(),profileDrawHeight(),DeviceProfile.DESIGN_ROWS,big);
        for(var i=0;i<cells.size();i+=1) {
            var cell=cells[i];
            if(cell[Cell.ENLARGED]!=enlarged) { continue; }
            if(selected==null || cell[Cell.H]<selected[Cell.H] || cell[Cell.W]<selected[Cell.W]) { selected=cell; }
        }
    }
    return selected;
}

(:testSupport)
function normalFixtureValue(row,point,engine,settings) {
    var index=row[0];var displayed=point[0];
    settings.apply({"a1"=>Catalog.IDS[index],"a_hideu"=>row[2],"a1_bg"=>1});
    var raw={};raw[Catalog.IDS[index]]=normalDisplayRaw(index,displayed,row[1]);
    var clock=new PresentationClock();
    if("clock".equals(Catalog.FORMATS[index])) { var minutes=displayed.toNumber();clock.hour=minutes/60;clock.min=minutes%60; }
    var value=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(row[1],row[3],false),clock)[:values][0];
    // Synthetic qualified-color fixtures test halo bounds, not sensor provenance.
    if(index==4 || index==5 || index==7 || index==8 || index==9 || index==25) { value[ValueRecord.BAND]="green"; }
    return value;
}

(:test)
function normalRangeCellBounds(logger) {
    var cases=NormalLimits.cases();var fieldsSeen=[];
    for(var field=0;field<Catalog.IDS.size()-1;field+=1) { fieldsSeen.add(false); }
    var renderer=new FieldRenderer();var settings=new DisplaySettings();var engine=new SnapshotEngine();
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    var cells=[smallestNormalCell(false),smallestNormalCell(true)];
    var labelFont=WatchUi.loadResource(FontSelection.info(DeviceProfile.LABEL_SIZE,true)[0]);
    var numericFonts=[WatchUi.loadResource(FontSelection.info(DeviceProfile.REGULAR_SIZE,false)[0]),
                      WatchUi.loadResource(FontSelection.info(DeviceProfile.BIG_SIZE,false)[0])];
    var checked=0;
    Test.assert(cases.size()>0);
    for(var c=0;c<cases.size();c+=1) {
        var row=cases[c];var role=row[4]?1:0;var cell=cells[role];
        fieldsSeen[row[0]]=true;
        for(var s=0;s<row[5].size();s+=1) {
            var point=row[5][s];var value=normalFixtureValue(row,point,engine,settings);
            Test.assertEqual(point[1],value[ValueRecord.TEXT]);Test.assertEqual(point[2],value[ValueRecord.UNIT]);
            var run=renderer.fitRun(cell,value,DeviceProfile.LABEL_SIZE,value[ValueRecord.TEXT],value[ValueRecord.UNIT]);
            if(run==null) { logger.debug("NORMAL_GUARANTEE_FAIL field="+Catalog.IDS[row[0]]+" case="+c+" point="+s); }
            Test.assert(run!=null);Test.assertEqual(point[1],run.text);
            if(value[ValueRecord.BAND]!=null && value[ValueRecord.ANGLE]==null) {
                Test.assertEqual(DeviceProfile.LABEL_SIZE==21?30:46,run.labelBand);
            }
            Test.assert(!PresentationPolicy.OVERFLOW.equals(run.text));
            Test.assertEqual(dc.getTextWidthInPixels(run.text,numericFonts[role]),run.width);
            Test.assertEqual(dc.getTextWidthInPixels(run.unit,labelFont),run.unitWidth);
            Test.assert(dc.getTextWidthInPixels(value[ValueRecord.LABEL],labelFont)+2*run.margin<=cell[Cell.W]);
            for(var align=0;align<2;align+=1) {
                var x=align==1?cell[Cell.W]-run.margin-run.total:(cell[Cell.W]-run.total)/2;
                Test.assert(x-run.radius>=4 && x+run.total+run.radius<=cell[Cell.W]-4);
            }
            Test.assertEqual(DeviceProfile.LABEL_SIZE==21?30:46,renderer._headerHeight);
            Test.assert(run.top-run.radius>=renderer._headerHeight);
            Test.assert(run.top+run.ink[1]-run.ink[0]+run.radius<=cell[Cell.H]);
            checked+=1;
        }
    }
    for(var f=0;f<fieldsSeen.size();f+=1) { Test.assert(fieldsSeen[f]); }
    logger.debug("NORMAL_GUARANTEES checked="+checked+" contexts="+cases.size()+" documented_without_guarantee="+NormalLimits.unsupportedCount());
    return true;
}
