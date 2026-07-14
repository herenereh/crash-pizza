class_name DashResetsJump
extends PerkEffect


func on_equipped(e:Entity)->void:
	super.on_equipped(e)
	EventBus.player_dashed.connect(_on_dashed)

func _on_dashed()->void:
	(entity as Player).JUMP_COUNT = 2

func on_removed()->void:
	EventBus.player_dashed.disconnect(_on_dashed)
	super.on_removed()
