extends Car

class_name CpuCar

const STEER_REACTION_MAX := 9.0

@export var waypoint_distance := 20.0
@export var debug := true
@export var min_top_speed_limit := 200.0
@export var max_top_speed_limit := 300.0

@onready var target_sprite = $TargetSprite

var adjusted_waypoint_target := Vector2.ZERO
var steer_reaction := STEER_REACTION_MAX
var target_speed := 250.0 

var next_waypoint : Waypoint

func _ready():
	target_sprite.visible = debug
	target_speed = randf_range(min_top_speed_limit, max_top_speed_limit)
	super()
	
func update_waypoint():
	if global_position.distance_to(adjusted_waypoint_target) < waypoint_distance:
		set_next_waypoint(next_waypoint.next_waypoint)

func set_next_waypoint(wp : Waypoint):
	next_waypoint = wp
	adjusted_waypoint_target = wp.global_position
	target_sprite.global_position = adjusted_waypoint_target

func _physics_process(delta):
	if !next_waypoint: return
	if state == CarState.SLIPPING: update_waypoint()
	if state != CarState.DRIVING: return
	
	var targetAngle = (adjusted_waypoint_target - global_position).angle()
	rotation = lerp_angle(rotation, targetAngle, steer_reaction * delta)
	velocity = lerp(velocity, target_speed, delta)
	position += transform.x * velocity * delta
	update_waypoint()
	
	
