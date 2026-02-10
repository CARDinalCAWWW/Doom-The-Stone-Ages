extends Node

var max_ammo := 20
var ammo := max_ammo

func _ready() -> void:
	update_ammo_ui()

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		shoot()

func shoot() -> void:
	if ammo > 0:
		ammo -= 1
		update_ammo_ui()
	else:
		print("No ammo left!")

func update_ammo_ui() -> void:
	var label := $CanvasLayer/AmmoLabel
	label.text = "Ammo: %d / %d" % [ammo, max_ammo]
