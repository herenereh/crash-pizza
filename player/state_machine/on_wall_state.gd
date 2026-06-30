extends State

@onready var mid_air: State = $"../Air"
@onready var walking: State = $"../Walking"
@onready var dash: State = $"../Dash"

func enter_state() -> void:
	player.wall_detection()

func _physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.wall_detection()

	if player.try_wall_jump():
		switch_state.emit(mid_air)
		return
	if player.try_dash():
		switch_state.emit(dash)
	if player.is_on_floor():
		switch_state.emit(walking)
	elif not player.is_on_wall():
		switch_state.emit(mid_air)
