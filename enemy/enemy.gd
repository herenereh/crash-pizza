class_name Enemy
extends Entity

const SPEED = 6.0
const GRAVITY = 20.0

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if player:
		var direction = (player.global_position - global_position)
		direction.y = 0.0
		direction = direction.normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	move_and_slide()
