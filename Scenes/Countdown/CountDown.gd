extends Control

class_name Countdown

@onready var label = $Label
@onready var timer = $Timer
@onready var beep = $Beep

@export var wait_time := 1.0

var started := false 
var count := 3  

func _unhandled_input(event):
	if !started and event.is_action_pressed("start"):
		start_race()

func _ready():
	hide()
	update_label()
	timer.wait_time = wait_time

func update_label():
	label.text = str(count)

func start_race():
	beep.play()
	show()
	timer.start()


func _on_timer_timeout():
	count-=1
	if count == 0:
		EventHub.emit_on_race_start()
		queue_free()
	else :
		beep.play()
		update_label()
