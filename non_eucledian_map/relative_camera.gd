class_name PortalWindow
extends Node3D

@export var linked_portal: PortalWindow

@onready var preview_camera: Camera3D = $Window/Previewport/Camera3D

var player:	Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player


func _process(delta: float) -> void:
	var relative = global_transform.affine_inverse() * player.camera.global_transform
	var flip:= Transform3D(Basis(Vector3(0,1,0), deg_to_rad(180)), Vector3.ZERO)
	preview_camera.global_transform = linked_portal.global_transform * flip * relative
