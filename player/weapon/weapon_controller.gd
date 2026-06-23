class_name WeaponController
extends Node

signal fired
signal hit(target: Node, damage: float)

@export var weapon: WeaponData
@export var camera: Camera3D
@export var muzzle: Marker3D

var cool_down: float = 0.0

func _physics_process(delta: float) -> void:
	cool_down = max(0.0, cool_down - delta)
