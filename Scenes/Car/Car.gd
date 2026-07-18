extends Area2D
class_name Car

enum CarState {WAITING, DRIVING, BOUNCING, SLIPPING}

@export var carTexture : Texture2D = preload("uid://b7wmt1hcagsow")
@export var carName := "Maruf"
@export var carNumber := 0
@export var bounce_time := 0.8
@export var bounce_force := 30.0
@export var slip_speed_range := Vector2(0.2, 0.5)

@onready var crashEffect := $CrashEffect
@onready var car_sprite = $CarSprite


var velocity : float
var bounce_tween : Tween
var bounce_target := Vector2.ZERO
var lap_time : float

var slip_tween : Tween


var state := CarState.WAITING


func _ready():
	#verifications = get_tree().get_nodes_in_group("verifications")'
	EventHub.on_race_start.connect(on_race_start)
	set_physics_process(false)
	car_sprite.texture = carTexture

func on_race_start():
	change_state(CarState.DRIVING)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lap_time += delta


#region State
func change_state(newState : CarState):
	if (newState == state) : return;
	state = newState
	match newState:
		CarState.BOUNCING:
			bounce()
		CarState.SLIPPING:
			slip_on_oil()
		CarState.DRIVING:
			set_physics_process(true)
#endregion


#region Bounce
func bounce_done():
	bounce_tween = null
	change_state(CarState.DRIVING)
	
func bounce():
	velocity = 0.0
	kill_slip_tween()
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

#region Slipping

func kill_slip_tween():
	if slip_tween and slip_tween.is_running():
		slip_tween.kill()

func slip_done():
	slip_tween = null
	change_state(CarState.DRIVING)

func slip_on_oil():
	velocity *= 0.5
	kill_slip_tween()
	rotation_degrees = fmod(rotation_degrees, 360.0)
	velocity *= randf_range(slip_speed_range.x, slip_speed_range.y)
	slip_tween = create_tween()
	slip_tween.set_parallel()
	slip_tween.set_ease(Tween.EASE_IN_OUT)
	slip_tween.tween_property(self, "position", position+(transform.x * velocity), bounce_time-0.3)
	slip_tween.tween_property(self, "rotation_degrees", rotation_degrees + 360.0, bounce_time-0.3)
	slip_tween.set_parallel(false)
	slip_tween.finished.connect(slip_done)

func hit_oil():
	if state == CarState.BOUNCING : return
	change_state(CarState.SLIPPING)
#endregion

func lap_completed():
	lap_time = 0.0
	
