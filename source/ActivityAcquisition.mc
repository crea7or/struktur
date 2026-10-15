using Toybox.Activity;
using Toybox.Time;
// Shared acquisition state; presentation and duplicate slots do not acquire separately.
class ActivityAcquisition {
    var grade;
    var laps;
    var currentLap;
    function initialize() { grade=new GradeEstimator(); laps=new LapTracker(); currentLap=new CurrentLap(); }
    function onStart() {
        var fresh=laps.ready();
        laps.onStart();
        if(fresh) { currentLap.fresh(); }
        currentLap.resume();
    }
    function onReset() { grade.reset(); laps.onReset(); currentLap.end(); }
    function boundary(info) {
        // Capture only the event's current counters, never a previous compute snapshot.
        currentLap.boundary(info);
        laps.onLap();
    }
    function read(info,raw) {
        var time=info has :elapsedTime?info.elapsedTime:null;
        var timer=info has :timerTime?info.timerTime:null;
        var distance=info has :elapsedDistance?info.elapsedDistance:null;
        var altitude=info has :altitude?info.altitude:null;
        var state=info has :timerState?info.timerState:null;
        var present=info has :startTime;
        var identity=null;
        if(present && info.startTime!=null) {
            if(info.startTime instanceof Time.Moment) { identity=info.startTime.value(); }
            else { present=false; }
        }
        raw["grade"]=grade.push(altitude,distance,time,state==Activity.TIMER_STATE_ON,identity);
        raw["completed_laps"]=laps.observe(present,identity,state==Activity.TIMER_STATE_OFF,timer,time,distance);
        raw["_activity_identity"]=identity;
        currentLap.read(info,raw,identity);
        return raw;
    }
}
