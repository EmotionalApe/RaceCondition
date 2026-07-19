extends Node


signal on_lap_completed(info : LapCompleteData)
signal on_race_start
signal on_lap_update(car : Car, lap_count : int, lap_time : float)

func emit_on_lap_completed(info):
	on_lap_completed.emit(info)
	

func emit_on_race_start():
	on_race_start.emit()
	
func emit_on_lap_update(car : Car, lap_count: int, lap_time : float):
	on_lap_update.emit(car, lap_count, lap_time)
