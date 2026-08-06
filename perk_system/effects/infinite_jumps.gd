class_name InfiniteJumps
extends PerkEffect

## While equipped, the player's jump count never depletes.
func on_equipped(e: Entity) -> void:
	super.on_equipped(e)
	set_process(true)

func _process(_delta: float) -> void:
	var player := entity as Player
	if player and player.JUMP_COUNT < 1:
		player.JUMP_COUNT = 1

func on_removed() -> void:
	set_process(false)
	super.on_removed()
