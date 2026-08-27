class_name DashOvercharge
extends PerkEffect

## Grants bonus dash meter charge every time the player dashes.
@export var bonus_charge: float = 5.0

func on_equipped(e: Entity) -> void:
	super.on_equipped(e)
	EventBus.player_dashed.connect(_on_dashed)

func _on_dashed() -> void:
	var player := entity as Player
	if player:
		player.add_dash_charge(bonus_charge)

func on_removed() -> void:
	EventBus.player_dashed.disconnect(_on_dashed)
	super.on_removed()
