extends RigidBody3D

var mouse_sensitivity := 0.002
var twist_input := 0.0
var pitch_input := 0.0

var move_force := 25.0
var jump_force := 8.0

var coyote_time := 0.2
var coyote_timer := 0.0

var jumps_remaining := 0
var max_jumps := 2

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var ground_ray := $GroundRay

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# -------------------------
	# MOVEMENT
	# -------------------------
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	# Apply movement force (no delta)
	apply_central_force(twist_pivot.basis * input * move_force)

	# -------------------------
	# COYOTE TIME + JUMP RESET
	# -------------------------
	if ground_ray.is_colliding():
		coyote_timer = coyote_time
		jumps_remaining = max_jumps
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("move_jump"):
		if coyote_timer > 0.0:
			apply_central_impulse(Vector3.UP * jump_force)
			coyote_timer = 0.0
			jumps_remaining -= 1
		elif jumps_remaining > 1:
			apply_central_impulse(Vector3.UP * jump_force)
			jumps_remaining -= 1

	if Input.is_action_just_pressed("attack"):
		$TwistPivot/PitchPivot/Bat.swing()

	# -------------------------
	# THROWING
	# -------------------------
	if Input.is_action_just_pressed("throw"):
		var projectile := preload("res://Weapong_throw.tscn").instantiate()
		get_tree().current_scene.add_child(projectile)

		# Spawn at camera/bat position
		projectile.global_transform = $TwistPivot/PitchPivot.global_transform.translated(Vector3(0, 1, 0))

		# Throw forward
		var forward: Vector3 = -$TwistPivot/PitchPivot.global_transform.basis.z
		projectile.apply_central_impulse(forward * 20.0)

	# -------------------------
	# MOUSE RELEASE
	# -------------------------
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# -------------------------
	# CAMERA ROTATION
	# -------------------------
	twist_pivot.rotation.y += twist_input
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x + pitch_input,
		deg_to_rad(-30),
		deg_to_rad(30)
	)

	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
