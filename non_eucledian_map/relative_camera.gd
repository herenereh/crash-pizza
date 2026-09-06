@tool
extends MeshInstance3D


@export var linked_portal_path: NodePath

var up = Vector3.UP

@onready var linked_portal = get_node_or_null(linked_portal_path)
@onready var viewport: SubViewport = $Viewport
@onready var camera: Camera3D = $Viewport/Camera
@onready var base: Node3D = $Base

var player: Player
var _shader_material: ShaderMaterial

@onready var _viewport_size := get_viewport().get_visible_rect().size

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player

	viewport.size = Vector2i(_viewport_size)

	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	var assigned := material_override as ShaderMaterial
	if not assigned:
		assigned = get_surface_override_material(0) as ShaderMaterial
	if not assigned and mesh and mesh.get_surface_count() > 0:
		assigned = mesh.surface_get_material(0) as ShaderMaterial

	if assigned:
		_shader_material = assigned.duplicate() as ShaderMaterial
		material_override = _shader_material
		_shader_material.set_shader_parameter("portal_texture", viewport.get_texture())

	up = global_transform.basis.y


func _process(_delta: float) -> void:
	if linked_portal == null or player == null:
		return

	camera.fov = player.camera.fov

	var d = (linked_portal.global_transform.origin - camera.global_transform.origin).length()
	camera.near = clamp(d, 0.05, camera.far)

	var relative = global_transform.affine_inverse() * player.camera.global_transform
	relative = relative.rotated(up, PI)
	base.global_transform = linked_portal.global_transform * relative
	camera.global_transform = linked_portal.global_transform * relative
