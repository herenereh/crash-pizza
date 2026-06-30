class_name WeaponController
extends Node3D

signal fired

const LAYER_WORLD := 1
const LAYER_PLAYER := 2
const LAYER_ENEMY := 4
const LAYER_PICKUPS := 8

@onready var weapon_node: Node3D = $"../WeaponRig/Weapon"
@onready var marker: Marker3D = $"../WeaponRig/Marker3D"

@export var weapons: Array[Weapon] = []
@export var current_weapon_index: int = 0

var weapon: Weapon
var _cooldown := 0.0

func _ready() -> void:
	weapon = weapon_node.WEAPON_TYPE

func equip_weapon(index: int) -> void:
	if weapons.is_empty():
		return
	current_weapon_index = posmod(index, weapons.size())
	weapon = weapons[current_weapon_index]
	weapon_node.equip(weapon)

func next_weapon() -> void:
	equip_weapon(current_weapon_index + 1)
	print("Equipped weapon ", current_weapon_index)
	
func _physics_process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	if weapon == null or _cooldown > 0:
		return
	if Input.is_action_just_pressed("Left Fire") or Input.is_action_just_pressed("Right Fire"):
		_fire()
	if Input.is_action_just_pressed("Switch Weapon"):
		next_weapon()

func _fire() -> void:
	_cooldown = 1.0/weapon.fire_rate
	for i in weapon.pellet_count:
		_shoot_ray(_get_shot_direction())
	fired.emit()
	
func _get_shot_direction() -> Vector3:
	var dir := -marker.global_basis.z.normalized()
	if weapon.spread_degrees > 0.0:
		dir = dir.rotated(marker.global_basis.x, deg_to_rad(randf_range(-weapon.spread_degrees, weapon.spread_degrees)))
		dir = dir.rotated(marker.global_basis.y, deg_to_rad(randf_range(-weapon.spread_degrees, weapon.spread_degrees)))
	return dir.normalized()
	
func _shoot_ray(direction: Vector3) -> void:
	
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
