class_name StateMachine extends Node

@export var initial_state: State

var active_state : State

func _ready() -> void:
	var player = get_parent() as Player
	for child_state: State in get_children():
		child_state.switch_state.connect(change_state)
		child_state.initialize(player)
	if initial_state:
		change_state(initial_state)
		
func _physics_process(delta: float) -> void:
	if active_state:
		active_state._physics_update(delta)
		
signal state_changed(new_state: State)

func change_state(new_state: State)-> void:
	if new_state == active_state:
		return
	if active_state:
		active_state.exit_state()
	active_state = new_state
	if active_state:
		active_state.enter_state()
		state_changed.emit(active_state)
