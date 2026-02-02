extends Node3D

var swinging: bool = false
var throwing: bool = false

var original_rot: Vector3
var original_parent: Node = null
var original_transform: Transform3D

var throw_speed: float = 20.0
var spin_speed: float = 720.0 # degrees per second

func _ready():
	original_rot = rotation_degrees
	$Area3D.body_entered.connect(_on_hit)
	set_physics_process(false)

# -------------------------
# SWING ATTACK
# -------------------------
func swing():
	if swinging or throwing:
		return
	swinging = true

	rotation_degrees.x = original_rot.x + 90
	await get_tree().create_timer(0.2).timeout
	rotation_degrees = original_rot

	swinging = false

# -------------------------
# THROW ATTACK
# -------------------------
func throw():
	if throwing or swinging:
		return
	throwing = true

	# Save original parent + transform
	original_parent = get_parent()
	original_transform = global_transform

	# Reparent to world so it no longer follows the camera
	get_tree().current_scene.add_child(self)
	global_transform = original_transform

	# Disable hitbox briefly so it doesn't hit the player
	$Area3D.monitoring = false
	await get_tree().create_timer(0.1).timeout
	$Area3D.monitoring = true

	set_physics_process(true)

func _physics_process(delta):
	if throwing:
		# Move forward
		global_position += -global_transform.basis.y * throw_speed * delta
		rotation_degrees.x = original_rot.x + 90

# -------------------------
# HIT DETECTION
# -------------------------
func _on_hit(body):
	if swinging and body.is_in_group("enemy"):
		body.queue_free()
		return

	if throwing:
		if body.is_in_group("enemy"):
			body.queue_free()

		_stop_throw()

# -------------------------
# STOP THROW (NO RETURN)
# -------------------------
func _stop_throw():
	throwing = false
	set_physics_process(false)

	# Weapon stays where it landed
	# No reparenting, no snapping back
