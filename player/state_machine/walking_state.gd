extends State

@onready var mid_air: State = $"../Air"
@onready var dash: State = $"../Dash"
@onready var on_wall: State = $"../Wall"

func _physics_update(delta: float) -> void:
	player.reset_ground_vars()
	player.crouching()
	player.apply_ground_movement(delta)
	

	if Input.is_action_just_pressed("Dash") and player.direction != Vector3.ZERO:
		switch_state.emit(dash)
		return
	if not player.is_on_floor():
		switch_state.emit(mid_air)
		return

	player.try_jump()
