class_name WeaponController
extends Node3D

signal fired

const LAYER_WORLD := 1
const LAYER_PLAYER := 2
const LAYER_ENEMY := 4
const LAYER_PICKUPS := 8

@onready var right_weapon_node: Node3D = $"../WeaponRig/Weapon"
@onready var right_marker: Marker3D = $"../WeaponRig/Marker3D"
@onready var left_weapon_node: Node3D = $"../WeaponRig2/Weapon"
@onready var left_marker: Marker3D = $"../WeaponRig2/Marker3D"

@export var right_weapons: Array[Weapon] = []
@export var left_weapons: Array[Weapon] = []

@export var current_right_weapon_index: int = 0
@export var current_left_weapon_index: int = 0

var right_weapon: Weapon
var left_weapon: Weapon
var _right_cooldown := 0.0
var _left_cooldown := 0.0

func _ready() -> void:
	right_weapon = right_weapon_node.WEAPON_TYPE
	left_weapon = left_weapon_node.WEAPON_TYPE

func equip_weapon(index: int) -> void:
	if right_weapons.is_empty() or left_weapons.is_empty():
		return
	current_right_weapon_index = posmod(index, right_weapons.size())
	current_left_weapon_index = posmod(index, left_weapons.size())
	right_weapon = right_weapons[current_right_weapon_index]
	left_weapon = left_weapons[current_left_weapon_index]
	right_weapon_node.equip(right_weapon)
	left_weapon_node.equip(left_weapon)

func next_weapon() -> void:
	equip_weapon(current_right_weapon_index + 1)
	equip_weapon(current_left_weapon_index + 1)
	print("Equipped weapon ", current_right_weapon_index)
	print("Equipped weapon ", current_left_weapon_index)
	
func _physics_process(delta: float) -> void:
	_right_cooldown = maxf(_right_cooldown - delta, 0.0)
	_left_cooldown  = maxf(_left_cooldown  - delta, 0.0)
	if Input.is_action_just_pressed("Left Fire") and left_weapon and _left_cooldown <= 0.0:
		_fire(left_weapon, left_marker)
		_left_cooldown = 1.0 / left_weapon.fire_rate
	if Input.is_action_just_pressed("Right Fire") and right_weapon and _right_cooldown <= 0.0:
		_fire(right_weapon, right_marker)
		_right_cooldown = 1.0 / right_weapon.fire_rate
	if Input.is_action_just_pressed("Switch Weapon"):
		next_weapon()

func _fire(weapon: Weapon, marker: Marker3D) -> void:
	for i in weapon.pellet_count:
		_shoot_ray(weapon, marker, _get_shot_direction(weapon, marker))
	fired.emit()
	
func _get_shot_direction(weapon: Weapon, marker: Marker3D) -> Vector3:
	var dir := -marker.global_basis.z.normalized()
	if weapon.spread_degrees > 0.0:
		dir = dir.rotated(marker.global_basis.x, deg_to_rad(randf_range(-weapon.spread_degrees, weapon.spread_degrees)))
		dir = dir.rotated(marker.global_basis.y, deg_to_rad(randf_range(-weapon.spread_degrees, weapon.spread_degrees)))
	return dir.normalized()
	
func _shoot_ray(weapon: Weapon, marker: Marker3D, direction: Vector3) -> void:
	var space_state := get_world_3d().direct_space_state
	var origin := marker.global_position
	var end := origin + direction * weapon.max_range
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		return
	var target : Object = hit.collider
	if target.collision_layer == LAYER_WORLD:
		print("hit world")
	elif target.collision_layer == LAYER_ENEMY:
		print("hit enemy")
	elif target.collision_layer == LAYER_PICKUPS:
		print("hit pickup")
	print("hit!")
