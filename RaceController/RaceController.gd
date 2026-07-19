extends Node

class_name RaceController
@export var total_laps := 5
@export var raceOverWaitTime := 5.0
@onready var race_over_timer = $RaceOverTimer

var cars : Array[Car] = []
var trackCurve : Curve2D
var raceData : Dictionary[Car, CarRaceData] = {}
var started := false
var finished := false
var startTime : float

func _ready():
	race_over_timer.wait_time = raceOverWaitTime

func setup(carsp, track_curve):
	cars = carsp
	trackCurve = track_curve
	for c in cars:
		raceData[c] = CarRaceData.new(c.carName,c.carNumber,total_laps)

func get_elapsed_time()->float:
	return Time.get_ticks_msec()

func on_lap_completed(info : LapCompleteData):
	print("RaceController on_lap_completed:", info)
	if not started or finished : return
	var car : Car = info.car
	var rd : CarRaceData = raceData[car]
	rd.add_lap_time(info.lapTime)
	EventHub.emit_on_lap_update(
		car,
		rd.completedLaps,
		info.lapTime
	)
	
	if rd.raceCompleted:
		car.change_state(car.CarState.RACEOVER)
		rd.set_total_time(get_elapsed_time() - startTime)
		if race_over_timer.is_stopped(): race_over_timer.start()

func finish_race():
	if finished == true : return
	finished = true
	var totalLen := trackCurve.get_baked_length()
	var elapsedTime := get_elapsed_time() - startTime
	for c in cars: 
		var rd := raceData[c]
		if not rd.raceCompleted:
			var offset : = trackCurve.get_closest_offset(c.global_position)
			var progress := offset / totalLen
			rd.force_finish(elapsedTime, progress)
			c.change_state(c.CarState.RACEOVER)
	pass

func _enter_tree():
	EventHub.on_lap_completed.connect(on_lap_completed)
	EventHub.on_race_start.connect(on_race_start)

func on_race_start():
	if started : return 
	started = true 
	finished = false
	startTime = get_elapsed_time()

func _on_race_over_timer_timeout():
	finish_race()
