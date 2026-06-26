class_name Weapon
extends Resource

@export var weapon_name: String = "Pistol"
@export var damage: float = 10.0
@export var fire_rate: float = 5.0
@export var max_range: float = 100.0
@export var spread_degrees: float = 0.0
@export var pellet_count: int = 1
@export var automatic: bool = false
@export var is_melee_weapon: bool = false
@export var position: Vector3
@export var rotation: Vector3
@export var weapon_mesh: Mesh
# optional later
@export var tracer_color: Color = Color.YELLOW
@export var can_pierce: bool = false
