extends Node

var weapons = ["Club", "Rock", "Slingshot"]
var current_weapon := 0

func _ready() -> void:
	update_weapon_ui()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		switch_weapon()

func switch_weapon() -> void:
	current_weapon = (current_weapon + 1) % weapons.size()
	update_weapon_ui()

func update_weapon_ui() -> void:
	var ui = $WeaponUI  # Make sure this path is correct

	if ui == null:
		print("ERROR: WeaponUI node not found. Check the node path.")
		return

	for i in range(ui.get_child_count()):
		var label = ui.get_child(i)

		# Godot-style ternary:
		if i == current_weapon:
			label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			label.add_theme_color_override("font_color", Color.WHITE)
