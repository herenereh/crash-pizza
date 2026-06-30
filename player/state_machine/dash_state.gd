extends State

@onready var walking: State = $"../Walking"
@onready var mid_air: State = $"../Air"

func enter_state() -> void:
	player.is_dashing = true
	player.DASH_TIMER = player.DASH_TIME
	player.dash_direction = player.direction.normalized()
	player.saved_movement_speed = Vector3(player.velocity.x, 0 , player.velocity.z).length()
	player.CURRENT_DASH += 1
	player.dashed.emit()
	

func _physics_update(delta: float) -> void:
		
	player.DASH_TIMER -= delta
	player.velocity.x = lerp(player.velocity.x, player.dash_direction.x * player.DASH_VELOCITY, 0.5)
	player.velocity.z = lerp(player.velocity.z, player.dash_direction.z * player.DASH_VELOCITY, 0.5)

	if player.DASH_TIMER <= 0.0:
		switch_state.emit(walking if player.is_on_floor() else mid_air)


func exit_state() -> void:
	player.is_dashing = false
	player.velocity.x = player.saved_movement_speed * player.dash_direction.x
	player.velocity.z = player.saved_movement_speed * player.dash_direction.z
