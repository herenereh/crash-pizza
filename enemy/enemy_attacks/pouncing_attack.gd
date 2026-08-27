class_name PouncingAttack extends AttackStrategy

@export var pounce_force: float = 120.0


func attack(enemy: BaseEnemy, player:Player)->void:
	if not player:
		return
	var direction = (player.global_position - enemy.global_position).normalized()
	var velocity = direction * pounce_force
	enemy.velocity = velocity
	print("Pounce Attack with force: ", pounce_force)
