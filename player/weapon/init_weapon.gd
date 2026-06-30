@tool
extends Node3D

@export var WEAPON_TYPE: Weapon:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint() and is_node_ready():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh

func _ready() -> void:
	load_weapon()

func equip(new_weapon: Weapon) -> void:
	WEAPON_TYPE = new_weapon
	load_weapon()

func load_weapon() -> void:
	if WEAPON_TYPE == null:
		return
	weapon_mesh.mesh = WEAPON_TYPE.weapon_mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
