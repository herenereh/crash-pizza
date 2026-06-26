extends Label

@export var player: Player
@export var show_debug_ui: bool = true

@onready var state_machine: StateMachine = player.get_node("StateMachine")

func _ready() -> void:
	visible = show_debug_ui
	state_machine.state_changed.connect(_on_state_change)
	_on_state_change(state_machine.active_state)
	
func _on_state_change(new_state: State)-> void:
	if new_state:
		text = "State: %s" % new_state.name
	else:
		text = "State: None"
	
