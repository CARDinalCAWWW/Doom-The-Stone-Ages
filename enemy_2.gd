extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const MAX_SPEED = 4.0
const ACCELERATION = 6.0
const FLOAT_AMPLITUDE = 0.5
const FLOAT_SPEED = 1.5
const DRIFT_AMOUNT = 0.6
const DRIFT_SPEED = 0.7

var time := 0.0
var base_height : float
var current_velocity : Vector3 = Vector3.ZERO

func _ready():
	add_to_group("enemy")
	base_height = global_position.y

func _physics_process(delta: float) -> void:
	time += delta
	
	# --- Navigation Direction ---
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	
	var direction = (next_location - current_location)
	direction.y = 0
	
	var desired_velocity = direction.normalized() * MAX_SPEED
	
	# --- Smooth Acceleration ---
	current_velocity = current_velocity.lerp(desired_velocity, ACCELERATION * delta)
	
	# --- Ghost Drift (sideways wobble) ---
	var drift = transform.basis.x * sin(time * DRIFT_SPEED) * DRIFT_AMOUNT
	
	# --- Floating (vertical hover) ---
	var hover_offset = sin(time * FLOAT_SPEED) * FLOAT_AMPLITUDE
	var target_height = base_height + hover_offset
	var vertical_velocity = (target_height - global_position.y) * 4.0
	
	# --- Combine Everything ---
	velocity.x = current_velocity.x + drift.x
	velocity.z = current_velocity.z + drift.z
	velocity.y = vertical_velocity
	
	move_and_slide()
	
	# --- Smooth Rotation Toward Movement ---
	if current_velocity.length() > 0.1:
		var target_rotation = atan2(-current_velocity.x, -current_velocity.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)

func update_target_location(target_location) -> void:
	nav_agent.target_position = target_location
