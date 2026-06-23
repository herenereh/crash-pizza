@tool 
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var start: bool = false : set  = set_start
func set_start(_val:bool)->void:
	generate()

@export_range(0,1) var survival_chance : float = 0.25
@export var room_number :int =4 
@export var room_margin : int =1
@export var room_recursion: int =15
@export var max_room_size: int = 4
@export var min_room_size: int = 2
@export var max_room_height: int = 4
@export var min_room_height: int = 2

var room_tiles: Array[PackedVector3Array] = []
var room_positions: PackedVector3Array = []

@export var border_size_x : int  = 20 : set = set_border_size_x
@export var border_size_z : int  = 20 : set = set_border_size_z
var border_size : int = 20

func set_border_size_x(_val: int)-> void:
	border_size_x = _val
	update_astar_bounds()
	if Engine.is_editor_hint():
		visualize_border()
		
func set_border_size_z(_val: int)-> void:
	border_size_z = _val
	update_astar_bounds()
	if Engine.is_editor_hint():
		visualize_border()

func visualize_border():
	grid_map.clear()
	for i in range(-1, border_size_x+1):
		grid_map.set_cell_item(Vector3i(i,0,-1),3)
		grid_map.set_cell_item(Vector3i(i,0,border_size_z),3)
	for j in range(-1, border_size_z+1):
		grid_map.set_cell_item(Vector3i(border_size_x,0,j),3)
		grid_map.set_cell_item(Vector3i(-1,0,j),3)

func generate():
	room_tiles.clear()
	room_positions.clear()
	visualize_border()
	for i in room_number:
		make_room(room_recursion)
	
	var rpv2 : PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()
	
	for p in room_positions:
		rpv2.append(Vector2(p.x,p.z))
		del_graph.add_point(del_graph.get_available_point_id(), Vector2(p.x,p.z))
		mst_graph.add_point(mst_graph.get_available_point_id(), Vector2(p.x,p.z))
		
	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(rpv2))
	
	for i in delaunay.size()/3:	
		var p1: int = delaunay.pop_front()
		var p2: int = delaunay.pop_front()
		var p3: int = delaunay.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)
	
	var visited_points : PackedInt32Array = []
	visited_points.append(randi() % room_positions.size())
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con: PackedInt32Array = [vp, c]
					possible_connections.append(con)
		if possible_connections.is_empty():
			break
			
		var connections : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) < rpv2[connections[0]].distance_squared_to(rpv2[connections[1]]):
				connections = pc
		visited_points.append(connections[1])
		mst_graph.connect_points(connections[0], connections[1])
		del_graph.disconnect_points(connections[0], connections[1])
	
	var hallway_graph : AStar2D = mst_graph
	
	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if p < c:
				var kill: float = randf()
				if survival_chance > kill:
					hallway_graph.connect_points(p,c)
	create_hallways(hallway_graph)

func create_hallways(hallway_graph: AStar2D):
	var hallways: Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var room_from : PackedVector3Array = room_tiles[p]
				var room_to : PackedVector3Array = room_tiles[c]
				var tile_from: Vector3 = room_from[0]
				var tile_to: Vector3 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c])< tile_from.distance_squared_to(room_positions[c]):
						tile_from = t
				for t in room_to:
					if t.distance_squared_to(room_positions[p])< tile_to.distance_squared_to(room_positions[p]):
						tile_to= t
				var hallway: PackedVector3Array = [tile_from,tile_to]
				hallways.append(hallway)
				grid_map.set_cell_item(tile_from,2)
				grid_map.set_cell_item(tile_to,2)
	var astar: AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * border_size
	print(border_size)
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	for t in grid_map.get_used_cells_by_item(0):
		if t.y == 0:
			astar.set_point_solid(Vector2i(t.x,t.z))
		
	for h in hallways:
		var pos_from: Vector2i = Vector2i(h[0].x,h[0].z)
		var pos_to: Vector2i = Vector2i(h[1].x,h[1].z)
		var hall: PackedVector2Array = astar.get_point_path(pos_from,pos_to)
		for t in hall:
			var pos : Vector3i = Vector3(t.x, 0, t.y)
			if grid_map.get_cell_item(pos) < 0:
				grid_map.set_cell_item(pos,1)

func make_room(rec:int):
	if !rec > 0:
		return
	var width : int = (randi_range(min_room_size, max_room_size))
	var height: int = (randi_range(min_room_size, max_room_size))
	var floor_height: int = (randi_range(min_room_height, max_room_height))

	var start_pos : Vector3i
	start_pos.x = randi() % (border_size_x - width + 1)
	start_pos.z = randi() % (border_size_z - height +1)
	
	for r in range(-room_margin, room_margin+height):
		for c in range(-room_margin, room_margin+width):
			for f in range(-room_margin, room_margin+floor_height):
				var pos: Vector3i = start_pos + Vector3i(c,f,r)
				if grid_map.get_cell_item(pos) == 0:
					make_room(rec-1)
					return
				
	var room: PackedVector3Array = [] 
	for r in height:
		for c in width:
			for f in floor_height:
				var pos: Vector3i = start_pos + Vector3i(c,f,r)
				grid_map.set_cell_item(pos,0)
				room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width/2))
	var avg_z : float = start_pos.z + (float(height/2))
	var pos : Vector3 = Vector3(avg_x, 0, avg_z)
	room_positions.append(pos)
	
	
func update_astar_bounds() -> void:
	border_size = max(border_size_x,border_size_z)
	
	
	
	
