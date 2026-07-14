class_name PerkComponent
extends Node

var active_effects: Array[PerkEffect] = []

func apply_perk(perk: PerkData)->void:
	var effect = perk.effect_scene.instantiate()
	add_child(effect)
	effect.perk = perk
	active_effects.append(effect)
	effect.on_equipped(get_parent() as Entity)
	
func remove_perk(perk: PerkData)->void:
	for effect in active_effects:
		if effect.perk == perk:
			effect.on_removed()
			effect.queue_free()
			active_effects.erase(effect)
			break
