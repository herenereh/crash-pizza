extends State

@onready var walking: State = $"../Walking"
@onready var on_wall: State = $"../Wall"
@onready var dash : State = $"../Dash"

func _physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.apply_air_movement()
	player.try_wall_jump()
	player.try_jump()

	if player.is_on_wall() and not player.is_on_floor():
		switch_state.emit(on_wall)
	if player.try_dash():
		switch_state.emit(dash)
	elif player.is_on_floor():
		switch_state.emit(walking)
