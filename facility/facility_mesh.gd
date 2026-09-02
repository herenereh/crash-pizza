@tool
extends Node3D

@export var grid_map_path: NodePath
@onready var grid_map: GridMap = get_node_or_null(grid_map_path)

@export var start: bool = false : set = set_start

const OPEN_ITEMS := [0, 1, 2]

@export var material: Material

func set_start(_val: bool) -> void:
	if Engine.is_editor_hint():
		build_mesh()

func _is_open(cell: Vector3i) -> bool:
	return OPEN_ITEMS.has(grid_map.get_cell_item(cell))

func build_mesh() -> void:
	if not grid_map:
		push_warning("FacilityMesh: grid_map_path is not set to a valid GridMap.")
		return

	for c in get_children():
		remove_child(c)
		c.queue_free()

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for cell in grid_map.get_used_cells():
		if not _is_open(cell):
			continue
		var base := Vector3(cell)

		if not _is_open(cell + Vector3i.DOWN):
			_add_floor(st, base)
		if not _is_open(cell + Vector3i.UP):
			_add_ceiling(st, base)
		if not _is_open(cell + Vector3i.FORWARD):
			_add_wall_neg_z(st, base)
		if not _is_open(cell + Vector3i.BACK):
			_add_wall_pos_z(st, base)
		if not _is_open(cell + Vector3i.LEFT):
			_add_wall_neg_x(st, base)
		if not _is_open(cell + Vector3i.RIGHT):
			_add_wall_pos_x(st, base)

	st.generate_normals()
	var mesh := st.commit()
	if mesh.get_surface_count() == 0:
		push_warning("FacilityMesh: no open cells found, nothing to build.")
		return

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "GeneratedMesh"
	mesh_instance.mesh = mesh
	if material:
		mesh_instance.material_override = material
	add_child(mesh_instance)

	var static_body := StaticBody3D.new()
	static_body.name = "GeneratedCollision"
	var collision_shape := CollisionShape3D.new()
	collision_shape.shape = mesh.create_trimesh_shape()
	static_body.add_child(collision_shape)
	add_child(static_body)

	if Engine.is_editor_hint():
		var scene_root := get_tree().edited_scene_root
		if scene_root:
			mesh_instance.owner = scene_root
			static_body.owner = scene_root
			collision_shape.owner = scene_root


func _add_quad(st: SurfaceTool, v0: Vector3, v1: Vector3, v2: Vector3, v3: Vector3) -> void:
	st.set_uv(Vector2(0, 0)); st.add_vertex(v0)
	st.set_uv(Vector2(0, 1)); st.add_vertex(v3)
	st.set_uv(Vector2(1, 1)); st.add_vertex(v2)
	st.set_uv(Vector2(0, 0)); st.add_vertex(v0)
	st.set_uv(Vector2(1, 1)); st.add_vertex(v2)
	st.set_uv(Vector2(1, 0)); st.add_vertex(v1)

## Bottom of the cell
func _add_floor(st: SurfaceTool, b: Vector3) -> void:
	_add_quad(st,
		b,
		b + Vector3(0, 0, 1),
		b + Vector3(1, 0, 1),
		b + Vector3(1, 0, 0))

## Top of the cell
func _add_ceiling(st: SurfaceTool, b: Vector3) -> void:
	var t := b + Vector3.UP
	_add_quad(st,
		t,
		t + Vector3(1, 0, 0),
		t + Vector3(1, 0, 1),
		t + Vector3(0, 0, 1))


func _add_wall_neg_z(st: SurfaceTool, b: Vector3) -> void:
	_add_quad(st,
		b,
		b + Vector3(1, 0, 0),
		b + Vector3(1, 1, 0),
		b + Vector3(0, 1, 0))


func _add_wall_pos_z(st: SurfaceTool, b: Vector3) -> void:
	var f := b + Vector3(0, 0, 1)
	_add_quad(st,
		f,
		f + Vector3(0, 1, 0),
		f + Vector3(1, 1, 0),
		f + Vector3(1, 0, 0))


func _add_wall_neg_x(st: SurfaceTool, b: Vector3) -> void:
	_add_quad(st,
		b,
		b + Vector3(0, 1, 0),
		b + Vector3(0, 1, 1),
		b + Vector3(0, 0, 1))


func _add_wall_pos_x(st: SurfaceTool, b: Vector3) -> void:
	var r := b + Vector3(1, 0, 0)
	_add_quad(st,
		r,
		r + Vector3(0, 0, 1),
		r + Vector3(0, 1, 1),
		r + Vector3(0, 1, 0))
