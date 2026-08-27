class_name MovementStrategy extends Node


func move(enemy: BaseEnemy, player: Player) -> void:
	var direction = (player.global_position - enemy.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	var speed: float = enemy.current_move_speed()
	enemy.velocity.x = direction.x * speed
	enemy.velocity.z = direction.z * speed
