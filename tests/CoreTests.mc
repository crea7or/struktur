using Toybox.Test;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.WatchUi;

(:test)
function floatingBoundaries(logger) {
    var cases=[[0,"0.00"],[0.0049,"0.00"],[-0.0049,"0.00"],[0.005,"0.01"],[-0.005,"-0.01"],
        [9.994,"9.99"],[9.995,"10.0"],[9.999,"10.0"],[10,"10.0"],[12.345,"12.3"],
        [99.94,"99.9"],[99.95,"100"],[99.999,"100"],[100,"100"],[100.5,"101"],
        [-9.99,"-9.99"],[-9.995,"-10.0"],[-99.94,"-99.9"],[-99.95,"-100"],[-100.5,"-101"],
        [999.999,"1000"],[100000.0,"100000"],[-99999.5,"-100000"],[2147483648.0d,"2147483648"]];
    for(var i=0;i<cases.size();i+=1) { Test.assertEqual(cases[i][1],Formatting.floating(cases[i][0])); }
    Test.assert(Formatting.floating(null)==null);
    Test.assert(Formatting.floating(Math.acos(2.0))==null);
    Test.assertEqual(false,Numeric.finite("0"));
    Test.assertEqual(false,Numeric.finite(true));
    Test.assertEqual(false,Numeric.finite(Math.acos(2.0)));
    Test.assertEqual(true,Numeric.finite(0.0));
    return true;
}

(:test)
function logicalGridCases(logger) {
    Test.assertEqual(10,Grid.capacity(5,0));Test.assertEqual(7,Grid.capacity(5,1));Test.assertEqual(4,Grid.capacity(5,2));
    Test.assertEqual(8,Grid.capacity(4,0));Test.assertEqual(5,Grid.capacity(4,1));Test.assertEqual(2,Grid.capacity(4,2));
    for(var rows=4;rows<=5;rows+=1) {
        for(var big=0;big<=2;big+=1) {
            var cells=Grid.plan(246,322,rows,big);
            Test.assertEqual(Grid.capacity(rows,big),cells.size());
            for(var i=0;i<cells.size();i+=1) {
                var c=cells[i];Test.assert(c[Cell.X]>=0 && c[Cell.Y]>=0 && c[Cell.X]+c[Cell.W]<=246 && c[Cell.Y]+c[Cell.H]<=322);
                for(var j=i+1;j<cells.size();j+=1) {
                    var d=cells[j];Test.assert(c[Cell.X]+c[Cell.W]<=d[Cell.X] || d[Cell.X]+d[Cell.W]<=c[Cell.X] || c[Cell.Y]+c[Cell.H]<=d[Cell.Y] || d[Cell.Y]+d[Cell.H]<=c[Cell.Y]);
                }
            }
        }
    }
    Test.assertEqual(2,Grid.plan(246,322,4,2).size());
    Test.assertEqual(0,Grid.plan(50,50,0,0).size());
    for(var angle=-45;angle<=45;angle+=15) {
        var polygon=Geometry.sky({Cell.X=>0,Cell.Y=>0,Cell.W=>480,Cell.H=>100},angle);
        Test.assert(polygon.size()>=3 && polygon.size()<=8);
        for(var p=0;p<polygon.size();p+=1) { Test.assert(polygon[p][0]>=0 && polygon[p][0]<=479 && polygon[p][1]>=0 && polygon[p][1]<=99); }
        var ground=Geometry.ground({Cell.X=>0,Cell.Y=>0,Cell.W=>480,Cell.H=>100},angle);
        Test.assert(ground.size()>=3 && ground.size()<=8);
        for(var q=0;q<ground.size();q+=1) {
            Test.assert(ground[q][0]>=0 && ground[q][0]<=479 && ground[q][1]>=0 && ground[q][1]<=99);
            if(angle==0) { Test.assert(ground[q][1]>=49); }
        }
    }
    return true;
}

(:test)
function threeConsecutiveSamples(logger) {
    var w=new RollingWindow();
    Test.assert(w.push(100,1)==null);Test.assert(w.push(200,2)==null);Test.assertEqual(200.0,w.push(300,3));
    Test.assertEqual(200.0,w.push(999,3)); // same timestamp does not count twice
    Test.assertEqual(300.0,w.push(400,4));
    Test.assert(w.push(500,6)==null); // sequence gap clears history
    Test.assert(w.push(null,7)==null);
    Test.assert(w.push(0,8)==null);Test.assert(w.push(0,9)==null);Test.assertEqual(0.0,w.push(0,10));
    w.reset();Test.assert(w.average()==null);
    return true;
}

(:test)
function exactEffectBands(logger) {
    var grades=[-5,0,0.01,2,2.01,5,5.01,8,8.01,15,15.01,20,20.01];
    var bands=["green","green","blue","blue","yellow","yellow","orange","orange","red","red","dark_red","dark_red","black"];
    for(var i=0;i<grades.size();i+=1) { Test.assertEqual(bands[i],Effects.gradeBand(grades[i])); }
    var temperatures=[-10.01,-10,-9.5,0,0.1,10,10.1,20,20.1,30,30.1];
    var tempBands=["blue","blue","cyan","cyan","white","white","green","green","yellow","yellow","red"];
    for(var j=0;j<temperatures.size();j+=1) { Test.assertEqual(tempBands[j],Effects.temperatureBand(temperatures[j])); }
    verifyColoringZones();
    Test.assert(Effects.temperatureBand(null)==null);Test.assert(Effects.gradeBand(null)==null);
    Test.assertEqual(45.0,Effects.horizonAngle(99));Test.assertEqual(-45.0,Effects.horizonAngle(-99));
    Test.assertEqual(10.0,Effects.horizonAngle(5));
    Test.assertEqual("magenta",Effects.zoneColor(7));Test.assert(Effects.zoneColor(null)==null);
    return true;
}

(:test)
function typedSettingsAndHiddenSlots(logger) {
    var s=new DisplaySettings();Test.assertEqual("right",s.alignment);s.apply({});
    Test.assertEqual("right",s.alignment);
    var invalidAlignments=[null,99,-1,true,"invalid",1.0];
    for(var invalid=0;invalid<invalidAlignments.size();invalid+=1) {
        s.apply({"a_align"=>invalidAlignments[invalid]});Test.assertEqual("right",s.alignment);
    }
    s.apply({"a_align"=>0});Test.assertEqual("center",s.alignment);
    s.apply({"a_align"=>"center"});Test.assertEqual("center",s.alignment);
    s.apply({"a_align"=>"right"});Test.assertEqual("right",s.alignment);
    s.apply({});
    Test.assertEqual(0,s.enlarged);
    var defaults=["current_speed","distance","activity_timer","time_of_day","current_heart_rate",
                  "power_3s","elevation","grade","total_ascent","temperature"];
    for(var i=0;i<10;i+=1) { Test.assertEqual(defaults[i],s.slots[i]);Test.assertEqual(false,s.effects[i]); }
    s.apply({"field_count"=>"10","a_big"=>9,"a1"=>"future_metric","a2"=>999,
             "a1_bg"=>0,"a2_bg"=>"false","a10"=>"current_power"});
    Test.assertEqual(0,s.enlarged);Test.assertEqual("future_metric",s.slots[0]);
    Test.assert(Catalog.index(s.slots[1])==null);Test.assertEqual(false,s.effects[0]);Test.assertEqual(false,s.effects[1]);
    var unknown=new SnapshotEngine().initial(s)[:values][1];
    Test.assertEqual("field",unknown[ValueRecord.LABEL]);Test.assert(unknown[ValueRecord.TEXT]==null);
    Test.assertEqual("current_power",s.slots[9]); // validation does not delete hidden assignments
    s.apply({"a_align"=>1,"a_theme"=>2,"a1"=>7,"a2"=>11,"a3"=>16,"a4"=>18});
    Test.assertEqual(0,Catalog.index("current_"+"speed"));
    Test.assertEqual("right",s.alignment);Test.assertEqual("night",s.theme);
    Test.assertEqual("current_power",s.slots[0]);Test.assertEqual("distance",s.slots[1]);
    Test.assertEqual("activity_timer",s.slots[2]);Test.assertEqual("time_of_day",s.slots[3]);
    // Old persisted count values cannot enable any partial-grid layout.
    var obsolete=[0,1,4,8,10,99,"4",null];
    for(var old=0;old<obsolete.size();old+=1) {
        for(var big=0;big<=2;big+=1) {
            s.apply({"field_count"=>obsolete[old],"a_big"=>big});
            for(var rows=4;rows<=5;rows+=1) {
                Test.assertEqual(Grid.capacity(rows,big),Grid.plan(246,322,rows,s.enlarged).size());
            }
        }
    }
    verifyEffectDefaultContract();
    verifyCompactProperties();
    return true;
}

(:test)
function unitsAndExplicitFormatPolicy(logger) {
    Test.assert((Formatting.speed(10,false)-36.0).abs()<0.001);
    Test.assert((Formatting.distance(1609.344,true)-1.0).abs()<0.001);
    Test.assertEqual(32.0,Formatting.temperature(0,true));
    Test.assertEqual("00.00",Formatting.duration(0,true));Test.assertEqual("01.05",Formatting.duration(65000,true));
    Test.assertEqual("1.05",Formatting.duration(65000,false));Test.assert(Formatting.duration(65000,null)==null);
    Test.assertEqual("1:00.00",Formatting.duration(3600000,true));
    // Exercise the actual settings-to-snapshot path: an unset production policy
    // previously turned valid timer/elapsed values below an hour into "pending".
    Test.assertEqual(true,PresentationPolicy.PAD_LEADING_MINUTES);
    var durationSettings=new DisplaySettings();
    durationSettings.apply({"a1"=>16,"a2"=>17});
    var durationEngine=new SnapshotEngine();
    var durationInputs=[0,999,1000,65000,3599999,3600000,3661000,35999999,36000000,86400000,360000000];
    var durationExpected=["00.00","00.00","00.01","01.05","59.59","1:00.00","1:01.01","9:59.59","10:00","24:00","100:00"];
    for(var durationIndex=0;durationIndex<durationInputs.size();durationIndex+=1) {
        var durationSnapshot=durationEngine.prepare({"activity_timer"=>durationInputs[durationIndex],
            "elapsed_time"=>durationInputs[durationIndex]},durationSettings,true);
        var expectedDuration=durationExpected[durationIndex];
        var shortSeconds=durationInputs[durationIndex]<36000000;
        var expectedPrimary=shortSeconds?expectedDuration.substring(0,expectedDuration.length()-3):expectedDuration;
        var expectedSecondary=shortSeconds?expectedDuration.substring(expectedDuration.length()-3,expectedDuration.length()):"";
        Test.assertEqual(expectedPrimary,durationSnapshot[:values][0][ValueRecord.TEXT]);
        Test.assertEqual(expectedSecondary,durationSnapshot[:values][0][ValueRecord.UNIT]);
        Test.assertEqual(expectedPrimary,durationSnapshot[:values][1][ValueRecord.TEXT]);
        Test.assertEqual(expectedSecondary,durationSnapshot[:values][1][ValueRecord.UNIT]);
    }
    var pausedDuration=durationEngine.prepare({"activity_timer"=>65000,"elapsed_time"=>73000},durationSettings,true);
    Test.assertEqual("01",pausedDuration[:values][0][ValueRecord.TEXT]);
    Test.assertEqual(".05",pausedDuration[:values][0][ValueRecord.UNIT]);
    Test.assertEqual("01",pausedDuration[:values][1][ValueRecord.TEXT]);
    Test.assertEqual(".13",pausedDuration[:values][1][ValueRecord.UNIT]);
    var unavailableDuration=durationEngine.prepare({"activity_timer"=>null,"elapsed_time"=>-1},durationSettings,true);
    Test.assert(unavailableDuration[:values][0][ValueRecord.TEXT]==null);
    Test.assert(unavailableDuration[:values][1][ValueRecord.TEXT]==null);
    Test.assertEqual("",unavailableDuration[:values][0][ValueRecord.UNIT]);
    Test.assertEqual("",unavailableDuration[:values][1][ValueRecord.UNIT]);
    Test.assertEqual("12:00",Formatting.clock(0,0,false));Test.assertEqual("12:00",Formatting.clock(12,0,false));
    Test.assertEqual("23:59",Formatting.clock(23,59,true));
    Test.assert(Effects.zone(120,[90,110,130,150,170,190],null)==null);
    // Two proposed boundary policies tested explicitly; neither is silently selected in production.
    Test.assertEqual(1,Effects.zone(110,[90,110,130,150,170,190],true));
    Test.assertEqual(2,Effects.zone(110,[90,110,130,150,170,190],false));
    return true;
}

(:test)
function requestedFieldPrecision(logger) {
    Test.assertEqual("1.3",Formatting.fixed(1.25,1));
    Test.assertEqual("-1.3",Formatting.fixed(-1.25,1));
    Test.assertEqual("0.0",Formatting.fixed(-0.04,1));
    Test.assertEqual("199.9",Formatting.fixed(199.9,1));
    Test.assert(Formatting.fixed(null,1)==null);
    var ids=["current_speed","average_speed","lap_speed"];
    var settings=new DisplaySettings();var engine=new SnapshotEngine();
    for(var i=0;i<ids.size();i+=1) {
        settings.apply({"a1"=>ids[i]});
        var raw={};raw[ids[i]]=10;
        var metric=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,false),new PresentationClock());
        var statute=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(true,true,false),new PresentationClock());
        Test.assertEqual("36.0",metric[:values][0][ValueRecord.TEXT]);
        Test.assertEqual("22.4",statute[:values][0][ValueRecord.TEXT]);
    }
    settings.apply({"a1"=>"grade","a1_bg"=>2,"a2"=>"elevation","a3"=>"total_ascent","a4"=>"total_descent"});
    var value=engine.prepareWithPreferences({"grade"=>2.01,"elevation"=>1785.6,"total_ascent"=>100.6,"total_descent"=>42.4},settings,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assertEqual("2.0",value[:values][0][ValueRecord.TEXT]);
    Test.assertEqual("yellow",value[:values][0][ValueRecord.BAND]); // canonical effect input remains 2.01
    Test.assertEqual("1786",value[:values][1][ValueRecord.TEXT]);
    Test.assertEqual("101",value[:values][2][ValueRecord.TEXT]);Test.assertEqual("42",value[:values][3][ValueRecord.TEXT]);
    var imperial=engine.prepareWithPreferences({"elevation"=>1000},settings,true,new PresentationDevice(true,true,false),new PresentationClock());
    Test.assertEqual("3281",imperial[:values][1][ValueRecord.TEXT]);
    var negative=engine.prepareWithPreferences({"elevation"=>-12.5,"grade"=>-0.04},settings,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assertEqual("-13",negative[:values][1][ValueRecord.TEXT]);Test.assertEqual("0.0",negative[:values][0][ValueRecord.TEXT]);
    // Conversion precedes magnitude selection; all speed assignments share the cached style.
    var speedCases=[[0,"0.00"],[9.994,"9.99"],[9.996,"10.0"],[10,"10.0"],
        [99.94,"99.9"],[99.96,"100"],[100,"100"],[200,"200"]];
    for(var id=0;id<ids.size();id+=1) {
        settings.apply({"a1"=>ids[id]});
        for(var mode=0;mode<2;mode+=1) {
            for(var point=0;point<speedCases.size();point+=1) {
                var raw={};raw[ids[id]]=speedCases[point][0]/(mode==1?2.2369362921:3.6);
                var result=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(mode==1,true,false),new PresentationClock());
                Test.assertEqual(speedCases[point][1],result[:values][0][ValueRecord.TEXT]);
            }
        }
    }

    return true;
}
