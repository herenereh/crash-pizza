class_name PerkEffect
extends Node

var entity: Entity
var perk: PerkData

func on_equipped(e: Entity)->void:
	entity = e


func on_removed()->void:
	pass
