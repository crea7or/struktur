using Toybox.Test;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Math;
using Toybox.WatchUi;

(:test)
function presentationSettingsAndUnits(logger) {
    var settings=new DisplaySettings();settings.apply({});
    Test.assert(settings.hideValueUnits && settings.inverseEnlargedTheme);
    Test.assertEqual(26,SettingsCatalogue.keys().size());
    var metric=["km/h","km/h","rpm","rpm","bpm","bpm","","w","w","w","","km","m","m","m","%","","","","kcal","°c","%","°","km","","bpm","km","","km/h","bpm","w","rpm"];
    var imperial=["mph","mph","rpm","rpm","bpm","bpm","","w","w","w","","mi","ft","ft","ft","%","","","","kcal","°f","%","°","mi","","bpm","mi","","mph","bpm","w","rpm"];
    var engine=new SnapshotEngine();var clock=new PresentationClock();
    for(var statute=0;statute<2;statute+=1) {
        var device=new PresentationDevice(statute==1,false,false);
        for(var retired=0;retired<2;retired+=1) {
            for(var hide=0;hide<2;hide+=1) {
                for(var index=0;index<Catalog.IDS.size();index+=1) {
                    settings.apply({"slot_1_value"=>Catalog.IDS[index],"use_units_as_labels"=>retired==1,"hide_value_units"=>hide==1});
                    var raw={};raw[Catalog.IDS[index]]=0;
                    var value=engine.prepareWithPreferences(raw,settings,true,device,clock)[:values][0];
                    var physical=statute==1?imperial[index]:metric[index];
                    var label=expectedUnitHeader(index,physical,hide==1);
                    if("clock".equals(Catalog.FORMATS[index])) {label+=" | pm";}
                    Test.assertEqual(label,value[:label]);
                    if("duration".equals(Catalog.FORMATS[index])) {
                        Test.assertEqual("00",value[:text]);Test.assertEqual(".00",value[:unit]);
                    } else if("clock".equals(Catalog.FORMATS[index])) {
                        Test.assertEqual("1:05",value[:text]);Test.assertEqual("",value[:unit]);
                    } else {Test.assertEqual("",value[:unit]);Test.assert(value[:text]!=null);}
                    var unavailable=engine.prepareWithPreferences({},settings,false,device,null)[:values][0];
                    Test.assertEqual(expectedUnitHeader(index,physical,hide==1),unavailable[:label]);
                    Test.assert(unavailable[:text]==null);Test.assertEqual("",unavailable[:unit]);
                }
            }
        }
    }
    settings.apply({"slot_1_value"=>"time_of_day"});
    var device12=new PresentationDevice(false,false,false);
    clock.hour=0;clock.min=0;
    var midnight=engine.prepareWithPreferences({},settings,true,device12,clock)[:values][0];
    Test.assertEqual("12:00",midnight[:text]);Test.assertEqual("time | am",midnight[:label]);
    clock.hour=12;
    var noon=engine.prepareWithPreferences({},settings,true,device12,clock)[:values][0];
    Test.assertEqual("time | pm",noon[:label]);
    device12.is24Hour=null;
    Test.assertEqual("time",engine.prepareWithPreferences({},settings,true,device12,clock)[:values][0][:label]);
    clock.hour=24;
    var invalid=engine.prepareWithPreferences({},settings,true,device12,clock)[:values][0];
    Test.assert(invalid[:text]==null);Test.assertEqual("time",invalid[:label]);
    settings.apply({"slot_1_value"=>"future-metric","hide_value_units"=>false});
    var unknown=engine.initial(settings)[:values][0];
    Test.assertEqual("field",unknown[:label]);Test.assertEqual("",unknown[:unit]);Test.assert(unknown[:text]==null);
    return true;
}

// Core width audit only: measure real SDK fonts without drawing a rejected grid.
// Physical-unit headers must fit; long unitless/hidden labels stay explicit.
(:test)
function composedHeaderWidthAudit(logger) {
    var metric=["km/h","km/h","rpm","rpm","bpm","bpm","","w","w","w","","km","m","m","m","%","","","","kcal","°c","%","°","km","","bpm","km","","km/h","bpm","w","rpm"];
    var imperial=["mph","mph","rpm","rpm","bpm","bpm","","w","w","w","","mi","ft","ft","ft","%","","","","kcal","°f","%","°","mi","","bpm","mi","","mph","bpm","w","rpm"];
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    var info=FontSelection.info(DeviceProfile.LABEL_SIZE,true);
    var font=WatchUi.loadResource(info[0]);var metrics=FontMetrics.label(info[1]);
    logger.debug("HEADER_FONT "+DeviceProfile.ID+" expected_height="+info[1]+" actual_height="+Graphics.getFontHeight(font));
    Test.assertEqual(info[1],Graphics.getFontHeight(font));
    var settings=new DisplaySettings();var engine=new SnapshotEngine();var clock=new PresentationClock();
    var checked=0;var oversized=0;var newlyOversized=0;
    for(var statute=0;statute<2;statute+=1) {
        var device=new PresentationDevice(statute==1,true,false);
        for(var index=0;index<Catalog.IDS.size();index+=1) {
            settings.apply({"slot_1_value"=>Catalog.IDS[index],"hide_value_units"=>true});
            var plain=engine.prepareWithPreferences({},settings,false,device,clock)[:values][0][:label];
            Test.assertEqual(Catalog.LABELS[index],plain);
            settings.apply({"slot_1_value"=>Catalog.IDS[index],"hide_value_units"=>false});
            var header=engine.prepareWithPreferences({},settings,false,device,clock)[:values][0][:label];
            var unit=statute==1?imperial[index]:metric[index];
            Test.assertEqual(expectedUnitHeader(index,unit,false),header);
            var plainWidth=dc.getTextWidthInPixels(plain,font);
            var headerWidth=dc.getTextWidthInPixels(header,font);
            if(plainWidth!=FontMetrics.width(plain,metrics)) {
                logger.debug("HEADER_METRICS_MISMATCH "+plain+" sdk="+plainWidth+" cached="+FontMetrics.width(plain,metrics));
            }
            Test.assertEqual(plainWidth,FontMetrics.width(plain,metrics));
            Test.assertEqual(headerWidth,FontMetrics.width(header,metrics));
            for(var big=0;big<=1;big+=1) {
                var available=(big==1?profileDrawWidth():profileDrawWidth()/2)-10;
                var fits=headerWidth<=available;
                checked+=1;
                if(unit.length()>0) { Test.assert(fits); }
                if(!fits) {
                    oversized+=1;if(plainWidth<=available) { newlyOversized+=1; }
                    logger.debug("HEADER_OVERFLOW "+DeviceProfile.ID+" "+header+" cell="+(big==1?"enlarged":"regular")+
                        " width="+headerWidth+" available="+available+" excess="+(headerWidth-available));
                }
            }
        }
    }
    // Exact shortened headers, using actual compiled Garmin font resources.
    var regular=profileDrawWidth()/2-8;
    Test.assert(dc.getTextWidthInPixels("lap dist | km",font)<=regular);
    Test.assertEqual(DeviceProfile.LABEL_SIZE==21?68:113,dc.getTextWidthInPixels("hr | bpm",font));
    Test.assertEqual(DeviceProfile.LABEL_SIZE==21?75:125,dc.getTextWidthInPixels("temp | °c",font));
    Test.assertEqual(DeviceProfile.LABEL_SIZE==21?80:136,dc.getTextWidthInPixels("avg watts",font));
    Test.assertEqual(128,checked);
    Test.assertEqual(0,newlyOversized);
    logger.debug("HEADER_AUDIT checked="+checked+" oversized="+oversized+" newly_oversized="+newlyOversized);
    return true;
}

(:test)
function presentationThemeAndActivity(logger) {
    Test.assertEqual(false,FieldPresentation.baseNight("auto",false,true));
    Test.assertEqual(false,FieldPresentation.baseNight("auto",true,false));
    Test.assertEqual(true,FieldPresentation.baseNight("auto",true,true));
    Test.assertEqual(false,FieldPresentation.baseNight("day",true,true));
    Test.assertEqual(true,FieldPresentation.baseNight("night",false,false));
    for(var night=0;night<2;night+=1) {
        for(var enlarged=0;enlarged<2;enlarged+=1) {
            for(var inverse=0;inverse<2;inverse+=1) {
                Test.assertEqual((night==1)!=(enlarged==1 && inverse==1),FieldPresentation.effectiveNight(night==1,enlarged==1,inverse==1));
            }
        }
    }
    var engine=new SnapshotEngine(); var settings=new DisplaySettings();
    settings.apply({"slot_1_value"=>"power_3s","slot_2_value"=>"activity_timer"});
    for(var second=1;second<=3;second+=1) { engine.compute({"current_power"=>second*100,"activity_timer"=>65000,"elapsed_time"=>second*1000,"_sampling_enabled"=>true},settings); }
    settings.apply({"slot_1_value"=>"power_3s","slot_2_value"=>"activity_timer", "use_units_as_labels"=>false,"hide_value_units"=>false,"inverse_enlarged_theme"=>false});
    // Reformatting existing readings after settings changes must preserve averages.
    engine.prepare({"power_3s"=>200,"activity_timer"=>65000},settings,true);
    var next=engine.compute({"current_power"=>400,"activity_timer"=>65000,"elapsed_time"=>4000,"_sampling_enabled"=>true},settings);
    Test.assertEqual("300",next[:values][0][:text]);
    Test.assertEqual("3s watts",next[:values][0][:label]);Test.assertEqual("",next[:values][0][:unit]);
    Test.assertEqual("01",next[:values][1][:text]); Test.assertEqual(".05",next[:values][1][:unit]);
    return true;
}

(:test)
function literalAndTemplateHeaderSelection(logger) {
    Test.assertEqual("avg watts",Catalog.LABELS[9]);
    Test.assertEqual("temperature",FieldPresentation.headerText("temperature","°c","temp | {unit}",true));
    Test.assertEqual("temp | °f",FieldPresentation.headerText("temperature","°f","temp | {unit}",false));
    Test.assertEqual("watts",FieldPresentation.headerText("watts","w","watts",false));
    Test.assertEqual("kcal",FieldPresentation.headerText("calories","kcal","kcal",false));
    Test.assertEqual("calories",FieldPresentation.headerText("calories","kcal","kcal",true));
    Test.assertEqual("timer",FieldPresentation.headerText("timer","","ignored",false));
    Test.assertEqual("speed | mph",FieldPresentation.headerText("speed","mph",null,false));
    Test.assertEqual("speed | mph",FieldPresentation.headerText("speed","mph","",false));
    Test.assertEqual("speed | km/h",FieldPresentation.headerText("speed","km/h",null,false));
    var settings=new DisplaySettings();settings.apply({"slot_1_value"=>0,"slot_2_value"=>12,"slot_3_value"=>20,"slot_4_value"=>19,"slot_5_value"=>7,"hide_value_units"=>false});
    var device=new PresentationDevice(true,true,false);device.elevationUnits=System.UNIT_METRIC;
    var result=new SnapshotEngine().prepareWithPreferences({},settings,false,device,null)[:values];
    var expected=["speed | mph","elevation | m","temp | °f","kcal","watts"];
    for(var i=0;i<expected.size();i+=1) { Test.assertEqual(expected[i],result[i][:label]);Test.assertEqual("",result[i][:unit]); }
    return true;
}

// Sample ride through production formatting, layout and drawing at native size.
(:test)
function sampleDefaultUnitHeaderGrid(logger) {
    for(var hideUnits=0;hideUnits<2;hideUnits+=1) {
        for(var night=0;night<2;night+=1) {
            for(var align=0;align<2;align+=1) {
                var settings=new DisplaySettings();settings.apply({"hide_value_units"=>hideUnits==1,"theme_mode"=>night==1?2:1,"alignment"=>align});
                var engine=new SnapshotEngine();engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
                var raw={"current_speed"=>27.3/3.6,"distance"=>12340,"activity_timer"=>5025000,"current_heart_rate"=>154,
                    "power_3s"=>245,"elevation"=>1456,"grade"=>6.8,"total_ascent"=>456,"temperature"=>24.5};
                var snapshot=engine.prepareWithPreferences(raw,settings,true,new PresentationDevice(false,true,night==1),new PresentationClock());
                for(var fresh=0;fresh<snapshot[:values].size();fresh+=1) {
                    Test.assert(snapshot[:values][fresh][:band]==null && snapshot[:values][fresh][:angle]==null);
                }
                var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
                for(var p=0;p<snapshot[:values].size();p+=1) { dc.paintEffects.add(snapshot[:values][p][:band]!=null || snapshot[:values][p][:angle]!=null); }
                var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.draw(dc,snapshot,settings);
                var cells=Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,0);
                Test.assertEqual(cells.size(),renderer._runs.size());
                Test.assertEqual(0,renderer._compactLines.size());
                for(var field=0;field<cells.size();field+=1) {
                    Test.assertEqual(snapshot[:values][field][:text],renderer._runs[field][:text]);
                    Test.assert(!PresentationPolicy.OVERFLOW.equals(renderer._runs[field][:text]));
                }
                verifyDrawRecords(dc,renderer,snapshot,cells,night,1,align);
            }
        }
    }
    return true;
}

(:test)
function reviewedFormattingAndCatalogue(logger) {
    Test.assertEqual(32,Catalog.IDS.size());
    var ids=["lap_distance","lap_time","lap_speed","lap_heart_rate","lap_power","lap_cadence"];
    var labels=["lap distance","lap time","lap speed","lap heart rate","lap watts","lap cadence"];
    for(var i=0;i<6;i+=1) {
        Test.assertEqual(ids[i],SettingsCatalogue.decode("slot_1_value",26+i));
        Test.assertEqual(labels[i],Catalog.LABELS[26+i]);
    }
    Test.assertEqual("1000000000",Formatting.integral(1000000000));
    Test.assertEqual("2147483648",Formatting.integral(2147483648l));
    Test.assertEqual("10.00",Formatting.floating(10));
    Test.assertEqual("0",Formatting.heading(Formatting.degrees(359.6*Math.PI/180.0)));
    Test.assertEqual("315",Formatting.heading(Formatting.degrees(-Math.PI/4.0)));
    Test.assertEqual("N",Formatting.cardinal(359.6));Test.assertEqual("NE",Formatting.cardinal(22.5));
    var settings=new DisplaySettings();settings.apply({"slot_1_value"=>22});
    var value=new SnapshotEngine().prepareWithPreferences({"heading"=>Math.PI/4.0},settings,true,new PresentationDevice(false,true,false),new PresentationClock());
    Test.assertEqual("45",value[:values][0][:text]);Test.assertEqual("NE",value[:values][0][:expandedUnit]);
    return true;
}

(:test)
function fixedThreeRoleFonts(logger) {
    var settings=new DisplaySettings();settings.apply({"slot_1_value"=>0,"slot_2_value"=>16,"slot_3_value"=>17,"slot_4_value"=>21});
    var engine=new SnapshotEngine();var renderer=new FieldRenderer();
    var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    for(var big=0;big<=2;big+=1) {
        settings.enlarged=big;
        for(var pass=0;pass<2;pass+=1) {
            var snapshot=engine.prepare({"current_speed"=>pass==0?1:99,"activity_timer"=>pass==0?0:360000000,
                "elapsed_time"=>pass==0?65000:360000000,"battery"=>pass==0?1:100},settings,true);
            renderer.prepare(snapshot);renderer.layout(dc,settings);
            Test.assertEqual(Grid.capacity(DeviceProfile.DESIGN_ROWS,big),renderer._runs.size());
            for(var i=0;i<renderer._runs.size();i+=1) {
                Test.assertEqual(renderer._cells[i][:enlarged]?DeviceProfile.BIG_SIZE:DeviceProfile.REGULAR_SIZE,renderer._runs[i][:size]);
            }
            Test.assertEqual(FontSelection.height(DeviceProfile.LABEL_SIZE,true),renderer._labelHeight);
            Test.assert(renderer._fonts.size()<=3 && renderer._metrics.size()<=3);
        }
    }
    return true;
}

(:test)
function approvedForegroundAndMetricWidths(logger) {
    var e=new SnapshotEngine();var clock=new PresentationClock();
    for(var night=0;night<2;night+=1) {
        var s=new DisplaySettings();s.apply({"slot_1_value"=>15,"slot_1_background_effects"=>true,"theme_mode"=>night==1?2:1});
        var snapshot=e.prepareWithPreferences({"grade"=>1},s,true,new PresentationDevice(false,true,night==1),clock);
        var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
        for(var f=0;f<snapshot[:values].size();f+=1) { dc.paintEffects.add(snapshot[:values][f][:band]!=null || snapshot[:values][f][:angle]!=null); }
        var r=new FieldRenderer();r.prepare(snapshot);r.layout(dc,s);r.draw(dc,snapshot,s);
        Test.assertEqual(night==1?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK,dc.records[0][:texts][0][:color]);
    }
    var settings=new DisplaySettings();settings.apply({"slot_1_value"=>4,"slot_1_background_effects"=>true});
    var engine=new SnapshotEngine();engine._hrZones=ZoneMetadata.heart([90,110,130,150,170,190]);
    var orange=engine.compute({"current_heart_rate"=>160},settings);
    var out=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
    for(var g=0;g<orange[:values].size();g+=1) { out.paintEffects.add(orange[:values][g][:band]!=null || orange[:values][g][:angle]!=null); }
    var renderer=new FieldRenderer();
    renderer.prepare(orange);renderer.layout(out,settings);renderer.draw(out,orange,settings);
    Test.assertEqual(Graphics.COLOR_ORANGE,out.records[0][:fills][1]);
    Test.assertEqual(Graphics.COLOR_WHITE,out.records[0][:background]);
    Test.assertEqual(Graphics.COLOR_WHITE,out.records[0][:texts][0][:color]);
    Test.assertEqual(Graphics.COLOR_BLACK,out.records[0][:texts][1][:color]);
    // Verify cached widths against Garmin's actual font measurement, not a duplicate algorithm.
    var sizes=renderer.numericSizes(false);
    for(var n=0;n<sizes.size();n+=1) {
        if(sizes[n]>DeviceProfile.REGULAR_SIZE) { continue; }
        var info=FontSelection.info(sizes[n],false);var font=WatchUi.loadResource(info[0]);
        Test.assertEqual(out.getTextWidthInPixels("-123:45.67",font),FontMetrics.width("-123:45.67",FontMetrics.numeric(info[1])));
    }
    return true;
}

// Fast normal native-area drawing cases; fallback belongs to PlacementTests.
(:test)
function normalPresentationDrawAndAlignment(logger) {
    for(var night=0;night<2;night+=1) {
        for(var big=0;big<=2;big+=1) {
            for(var align=0;align<2;align+=1) {
                verifyGuaranteedNormalDraw(night,big,align);
            }
        }
    }
    verifyWhiteTemperatureContrast();
    verifyNeutralLabelBands();
    for(var customCase=0;customCase<32;customCase+=1) { new CustomBackgroundScenario(customCase%8,customCase/8).run(); }
    for(var neutralCase=0;neutralCase<12;neutralCase+=1) { new NeutralBandScenario(neutralCase).run(); }
    for(var caseIndex=0;caseIndex<384;caseIndex+=1) { new ColoredFieldScenario(caseIndex).run(); }
    return true;
}

// APP-22/SPEC-155: visibility toggles remove only separator drawing calls.
(:test)
function gridVisibilityAndRepaint(logger) {
    var settings=new DisplaySettings();Test.assert(settings.showGrid);
    var invalid=[null,0,1,"true","false",1.0,[],{}];
    for(var i=0;i<invalid.size();i+=1) {
        settings.apply({"show_grid"=>invalid[i]});Test.assert(settings.showGrid);
    }
    settings.apply({"show_grid"=>false});Test.assert(!settings.showGrid);
    settings.apply({"show_grid"=>true});Test.assert(settings.showGrid);
    settings.apply({});Test.assert(settings.showGrid);
    for(var scenario=0;scenario<24;scenario+=1) { new GridVisibilityScenario(scenario).run(); }
    return true;
}

// APP-24: full clock and hour-plus-seconds timer groups fit every native cell.
(:test)
function clockAndDurationFitEveryLayout(logger) {
    for(var kind=0;kind<3;kind+=1) {
        for(var big=0;big<=2;big+=1) {
            for(var align=0;align<2;align+=1) {
                var settings=new DisplaySettings();var props={"enlarged_field_count"=>big,"alignment"=>align};
                var id=kind==2?"activity_timer":"time_of_day";
                for(var slot=1;slot<=10;slot+=1) { props["slot_"+slot.toString()+"_value"]=id; }
                settings.apply(props);var clock=new PresentationClock();clock.hour=kind==0?0:13;clock.min=kind==0?0:5;
                var snapshot=new SnapshotEngine().prepareWithPreferences({"activity_timer"=>3600000},settings,true,new PresentationDevice(false,true,false),clock);
                var dc=new PresentationDrawDc(profileDrawWidth(),profileDrawHeight());
                for(var n=0;n<snapshot[:values].size();n+=1) {
                    // Capability fixture reserves the largest one-pixel contour.
                    snapshot[:values][n][:band]="green";dc.paintEffects.add(true);
                }
                var renderer=new FieldRenderer();renderer.prepare(snapshot);renderer.layout(dc,settings);renderer.draw(dc,snapshot,settings);
                var cells=Grid.plan(dc.getWidth(),dc.getHeight(),DeviceProfile.DESIGN_ROWS,big);
                Test.assertEqual(cells.size(),renderer._runs.size());
                for(var f=0;f<cells.size();f+=1) {
                    Test.assertEqual(kind==0?"00:00":(kind==1?"13:05":"1:00"),renderer._runs[f][:text]);
                    Test.assertEqual(kind==2?".00":"",renderer._runs[f][:unit]);
                }
                verifyDrawRecords(dc,renderer,snapshot,cells,0,1,align);
            }
        }
    }
    return true;
}
