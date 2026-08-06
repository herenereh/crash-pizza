class_name DashResetsJump
extends PerkEffect


func on_equipped(e:Entity)->void:
	super.on_equipped(e)
	(entity as Player).bonus_jumps += 2
	EventBus.player_dashed.connect(_on_dashed)

func _on_dashed()->void:
	(entity as Player).refill_jumps()

func on_removed()->void:
	EventBus.player_dashed.disconnect(_on_dashed)
	(entity as Player).bonus_jumps -= 2
	super.on_removed()
