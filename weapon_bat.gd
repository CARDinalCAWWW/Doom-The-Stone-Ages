extends Node3D

var swinging: bool = false

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
	if swinging:
		return
	swinging = true

	rotation_degrees.x = original_rot.x + 90
	await get_tree().create_timer(0.2).timeout
	rotation_degrees = original_rot

	swinging = false
# -------------------------
# HIT DETECTION
# -------------------------
func _on_hit(body):
	if swinging and body.is_in_group("enemy"):
		body.queue_free()
		return
