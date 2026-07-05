extends Area2D

@export var maxSpeed := 380.0
@export var acceleration := 100.0
@export var friction := 150.0
@export var steerStrength := 6.0
@export var minSteerFactor := 0.5

var throttle : float
var velocity : float
var steer : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	throttle = Input.get_action_strength("ui_up")
	steer = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta):
	apply_throttle(delta)
	apply_steer(delta)
	position += transform.x * delta * velocity

func get_steer_factor():
	return clampf(
		1.0 - pow((velocity / maxSpeed), 2.0),
		minSteerFactor, 
		1.0
	) * steerStrength

func apply_throttle(delta):
	if throttle > 0.0:
		velocity += acceleration * delta
	else:
		velocity -= friction * delta
	
	velocity = clampf(velocity, 0.0, maxSpeed)

func apply_steer(delta):
	rotate(steer * get_steer_factor() * delta)
