@tool
extends Node3D

@export var WEAPON_TYPE: Weapon:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint() and is_node_ready():
			load_weapon()

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh

var mouse_movement := Vector2.ZERO
var rest_position := Vector3.ZERO
var rest_rotation := Vector3.ZERO
var sway_offset_position := Vector3.ZERO
var sway_offset_rotation := Vector3.ZERO


func _ready() -> void:
	load_weapon()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative

func _process(_delta: float) -> void:
	if WEAPON_TYPE == null:
		return
	apply_sway()
	mouse_movement = Vector2.ZERO

func equip(new_weapon: Weapon) -> void:	
	WEAPON_TYPE = new_weapon
	load_weapon()

func load_weapon() -> void:
	if WEAPON_TYPE == null:
		return
	weapon_mesh.mesh = WEAPON_TYPE.weapon_mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	rest_position = WEAPON_TYPE.position
	rest_rotation = WEAPON_TYPE.rotation

func apply_sway() -> void:
	var target_position := Vector3(
		clamp(-mouse_movement.x * WEAPON_TYPE.sway_amount_position, -WEAPON_TYPE.sway_max.x, WEAPON_TYPE.sway_max.x),
		clamp(-mouse_movement.y * WEAPON_TYPE.sway_amount_position, -WEAPON_TYPE.sway_max.y, WEAPON_TYPE.sway_max.y),
		0.0
	)
	var target_rotation := Vector3(
		clamp(-mouse_movement.y * WEAPON_TYPE.sway_amount_rotation, -WEAPON_TYPE.sway_max.y, WEAPON_TYPE.sway_max.y),
		clamp(-mouse_movement.x * WEAPON_TYPE.sway_amount_rotation, -WEAPON_TYPE.sway_max.x, WEAPON_TYPE.sway_max.x),
		0.0
	)

	sway_offset_position = lerp(sway_offset_position, target_position, WEAPON_TYPE.sway_speed_position)
	sway_offset_rotation = lerp(sway_offset_rotation, target_rotation, WEAPON_TYPE.sway_speed_rotation)

	position = rest_position + sway_offset_position
	rotation = rest_rotation + sway_offset_rotation
