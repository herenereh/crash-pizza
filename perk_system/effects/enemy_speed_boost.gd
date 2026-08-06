class_name EnemySpeedBoost
extends PerkEffect

## Additive speed granted to the enemy while this perk is active.
@export var bonus_speed: float = 3.0

func on_equipped(e: Entity) -> void:
	super.on_equipped(e)
	var enemy := entity as BaseEnemy
	if enemy:
		enemy.bonus_move_speed += bonus_speed

func on_removed() -> void:
	var enemy := entity as BaseEnemy
	if enemy:
		enemy.bonus_move_speed -= bonus_speed
	super.on_removed()
