extends State

@onready var walking: State = $"../Walking"
@onready var on_wall: State = $"../Wall"
@onready var dash : State = $"../Dash"

func _physics_update(delta: float) -> void:
	player.JUMP_COUNT = 0
	player.apply_gravity(delta)
	player.try_wall_jump()
	player.try_jump()
	player.apply_movement(delta, player.AIR_ACCELERATION, player.AIR_FRICTION, player.AIR_SPEED)

	if player.is_on_wall() and not player.is_on_floor():
		switch_state.emit(on_wall)
	if player.try_dash():
		switch_state.emit(dash)
	elif player.is_on_floor():
		switch_state.emit(walking)
