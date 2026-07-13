class_name Weapon
extends Resource

@export_category("Identity")
@export var weapon_name: String = "Pistol"
@export_category("Stats")
@export var damage: float = 10.0
@export var fire_rate: float = 5.0
@export var max_range: float = 100.0
@export var spread_degrees: float = 0.0
@export var pellet_count: int = 1
@export_category("Behaviour")
@export var automatic: bool = false
@export var is_melee_weapon: bool = false
@export var can_pierce: bool = false
@export_category("Visual")
@export var weapon_mesh: Mesh
@export var position: Vector3
@export var rotation: Vector3
@export var tracer_color: Color = Color.YELLOW
@export_category("Sway")
@export var sway_min: Vector2 = Vector2(0.05, 0.05)
@export var sway_max: Vector2 = Vector2(0.1, 0.1)
@export_range(0.0, 0.25, 0.01) var sway_speed_position: float = 0.7
@export_range(0.0, 0.25, 0.01) var sway_speed_rotation: float = 0.7
@export_range(0.0, 0.25, 0.01) var sway_amount_position: float = 0.7
@export_range(0.0, 50.0, 0.1) var sway_amount_rotation: float = 20.0
