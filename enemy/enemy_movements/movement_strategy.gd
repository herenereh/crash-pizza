class_name MovementStrategy extends Node


const SPEED = 5.0
func move(enemy: BaseEnemy, player: Player) -> void:
	var direction = (player.global_position - enemy.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	enemy.velocity.x = direction.x * SPEED
	enemy.velocity.z = direction.z * SPEED
