class_name Entity
extends CharacterBody3D


signal damaged(amount: float)

signal died

@export var max_health: float = 100.0

@onready var health: float = max_health

func take_damage(amount: float) -> void:
	if health <= 0.0:
		return
	health = clamp(health - amount, 0.0, max_health)
	damaged.emit(amount)
	if health <= 0.0:
		die()

func die() -> void:
	died.emit()
	queue_free()
