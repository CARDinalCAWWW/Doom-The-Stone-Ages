extends Node3D

var swinging = false
var original_rot

func _ready():
	original_rot = rotation_degrees
	$Area3D.body_entered.connect(_on_hit)

func swing():
	if swinging:
		return
	swinging = true

	# Rotate 90 degrees (change axis if needed)
	rotation_degrees.x = original_rot.x + 90

	# Return after 0.2 seconds
	await get_tree().create_timer(0.2).timeout
	rotation_degrees = original_rot
	swinging = false

func _on_hit(body):
	if swinging and body.is_in_group("enemy"):
		body.queue_free()
