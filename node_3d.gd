extends Node3D

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var bar := $Sprite3D/SubViewport/ProgressBar
		bar.value = max(bar.value - 2, bar.min_value)
