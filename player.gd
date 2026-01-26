extends RigidBody3D

@onready var raycast: RayCast3D = $RayCast3D
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(2)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(0)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	if input.x or input.z != 0:
		apply_central_force(input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("move_jump") and raycast.is_colliding():
		apply_central_impulse(Vector3.UP * 10)
		
	
