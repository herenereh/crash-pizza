extends State

@onready var dash: State = $"../Dash"
@onready var walking: State = $"../Walking"
@onready var mid_air: State = $"../Air"

const SLIDE_DURATION: float = 1.0

var slide_timer: float = 0.0

func enter_state() -> void:
	slide_timer = SLIDE_DURATION
	player.is_crouching = true

func _physics_update(delta: float) -> void:
	slide_timer -= delta
	player.apply_movement(delta, player.GROUND_ACCELERATION, player.GROUND_FRICTION, player.SLIDE_SPEED)

	if not player.is_on_floor():
		switch_state.emit(mid_air)
		return
	if(Input.is_action_just_pressed("Dash") and player.direction != Vector3.ZERO):
		switch_state.emit(dash)
		return
	if(Input.is_action_just_pressed("Crouch") and player.direction == Vector3.ZERO):
		switch_state.emit(walking)
		return
	if(slide_timer <= 0.0):
		switch_state.emit(walking)
		return

func exit_state() -> void:
	player.is_crouching = false
