extends Car


class_name PlayerCar
@export var maxSpeed := 380.0
@export var acceleration := 100.0
@export var friction := 150.0
@export var steerStrength := 6.0
@export var minSteerFactor := 0.5


var throttle : float
var steer : float

var verifications_passed = []
var verifications = []


func _ready():
		verifications = get_tree().get_nodes_in_group("verifications")
		super()
		
		
func _process(delta):
	throttle = Input.get_action_strength("ui_up")
	steer = Input.get_axis("ui_left", "ui_right")
	super(delta)


func _physics_process(delta):
	if state != CarState.DRIVING:
		return 
	apply_throttle(delta)
	apply_steer(delta)
	position += transform.x * delta * velocity

func apply_throttle(delta):
	if throttle > 0.0:
		velocity += acceleration * delta
	else:
		velocity -= friction * delta
	
	velocity = clampf(velocity, 0.0, maxSpeed)

func get_steer_factor():
	return clampf(
		1.0 - pow((velocity / maxSpeed), 2.0),
		minSteerFactor, 
		1.0
	) * steerStrength

func apply_steer(delta):
	rotate(steer * get_steer_factor() * delta)
	
	
	
func lap_completed():
	if verifications.size() == verifications_passed.size() :
		var lcd = LapCompleteData.new(self, lap_time)
		print(lcd)
		EventHub.emit_on_lap_completed(lcd)
	verifications_passed.clear()
	super()
	
func hit_verification(verification_id):
	if verification_id not in verifications_passed:
		verifications_passed.append(verification_id)
		pass
