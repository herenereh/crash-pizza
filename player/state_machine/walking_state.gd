extends State

@onready var mid_air: State = $"../Air"
@onready var dash: State = $"../Dash"
@onready var on_wall: State = $"../Wall"
@onready var slide: State = $"../Slide"

func _physics_update(delta: float) -> void:
	player.reset_ground_vars()
	player.apply_movement(delta, player.GROUND_ACCELERATION, player.GROUND_FRICTION, player.SPEED)
	player.is_crouching = false
	

	if Input.is_action_just_pressed("Dash") and player.direction != Vector3.ZERO:
		switch_state.emit(dash)
		return
	if not player.is_on_floor():
		switch_state.emit(mid_air)
		return
	if Input.is_action_just_pressed("Crouch") and player.direction != Vector3.ZERO:
		switch_state.emit(slide)
		return

	player.try_jump()
