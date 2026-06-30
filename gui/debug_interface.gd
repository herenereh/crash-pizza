extends Label

@export var player: Player
@export var show_debug_ui: bool = true

@onready var state_machine: StateMachine = player.get_node("StateMachine")

func _ready() -> void:
	visible = show_debug_ui
	state_machine.state_changed.connect(_on_state_change)
	set_process(show_debug_ui)

func _process(_delta: float) -> void:
	if show_debug_ui:
		refresh_debug_text()
func _on_state_change(_new_state: State) -> void:
	refresh_debug_text()

func refresh_debug_text() -> void:
	var state_name: String = state_machine.active_state.name if state_machine.active_state else "None"
	text = "State: %s\n" % state_name
	text += "Velocity: %s\n" % player.velocity.length()
	text += "Slowdown: %s\n" % player.is_slowdown
	text += "Is Dashing: %s\n" % player.is_dashing
	text += "Current Dash: %s\n" % player.CURRENT_DASH
	text += "Jump Count: %s\n" % player.JUMP_COUNT
