class_name State
extends Node

signal switch_state(state: State)

var player: Player

func initialize(p: Player) -> void:
	player = p

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass
