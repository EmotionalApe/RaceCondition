extends PathFollow2D

class_name OilDropper

const OIL = preload("res://Scenes/Oil/Oil.tscn")

@export var debug := true
@export var speed := 100.0
@export var oilContainer : Node
@export var dropTimeVariance := Vector2(3.0, 8.0)
@export var dropMargin := 25.0 
@export var oilEnabled := false

@onready var debug_dot = $DebugDot
@onready var drop_timer = $DropTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	debug_dot.visible = debug
	if (oilEnabled):
		start_timer()
	progress_ratio = randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += delta * speed

func start_timer():
	drop_timer.wait_time = randf_range(dropTimeVariance.x, dropTimeVariance.y)
	drop_timer.start()
	

func drop_oil():
	if !oilContainer:
		push_error("drop oil container not assigned")
	var oilHazard := OIL.instantiate()
	oilContainer.add_child(oilHazard)
	oilHazard.global_position = Vector2(
		global_position.x + randf_range(-dropMargin, dropMargin),
		global_position.y + randf_range(-dropMargin, dropMargin)
	)
	start_timer()
	


func _on_drop_timer_timeout():
	drop_oil()
