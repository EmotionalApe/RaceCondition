extends Area2D
class_name Car

enum CarState {DRIVING, BOUNCING, SLIPPING}

@export var maxSpeed := 380.0
@export var acceleration := 100.0
@export var friction := 150.0
@export var steerStrength := 6.0
@export var minSteerFactor := 0.5
@export var bounce_time := 0.8
@export var bounce_force := 30.0

@onready var crashEffect := $CrashEffect



var throttle : float
var velocity : float
var steer : float
var bounce_tween : Tween
var bounce_target := Vector2.ZERO
var state := CarState.DRIVING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	throttle = Input.get_action_strength("ui_up")
	steer = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta):
	if state != CarState.DRIVING:
		return 
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

#region State
func change_state(newState : CarState):
	if (newState == state) : return;
	state = newState
	match newState:
		CarState.BOUNCING:
			bounce()
		CarState.SLIPPING:
			pass
#endregion


#region Bounce
func bounce_done():
	bounce_tween = null
	change_state(CarState.DRIVING)
	
func bounce():
	velocity = 0.0
	if bounce_tween and bounce_tween.is_running():
		bounce_tween.kill()
	rotation_degrees = fmod(rotation_degrees, 360.0)
	bounce_tween = create_tween()
	bounce_tween.set_parallel()
	bounce_tween.set_ease(Tween.EASE_IN_OUT)
	bounce_tween.tween_property(self, "position", bounce_target, bounce_time)
	bounce_tween.tween_property(self, "rotation_degrees", rotation_degrees + 720.0, bounce_time)
	bounce_tween.set_parallel(false)
	bounce_tween.finished.connect(bounce_done)

func hit_boundary(dirToPath : Vector2):
	crashEffect.restart()
	bounce_target = position + (dirToPath * bounce_force)
	change_state(CarState.BOUNCING)
#endregion 
