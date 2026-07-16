class_name PerkManager extends Node

@export var perk_pool: Array[PerkData] = []

var perk_ui: CanvasLayer
var player_component: PerkComponent



func _ready()->void:
	perk_ui = get_tree().get_first_node_in_group("PerkUI")
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player_component = player.get_node_or_null("PerkComponent")
	#EventBus.room_cleared.connect(start_draft)
	#await get_tree().create_timer(2.0).timeout
	#start_draft()


func start_draft()->void:
	var offered: Array[PerkData] = _pick_random_perk(3)
	perk_ui.show_perks(offered)


func _pick_random_perk(count: int)->Array[PerkData]:
	var pool = perk_pool.duplicate()
	pool.shuffle()
	return pool.slice(0, count)


func _distrubute_perks(perks: Array[PerkData])->void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for i in perks.size():
		if i >= enemies.size():
			break
		var comp = enemies[i].get_node("PerkComponent")
		if comp:
			comp.apply_perk(perks[i])


func _on_perk_card_picked(perk: PerkData)->void:
	player_component.apply_perk(perk)
	var rejected = perk_pool.filter(func(p: PerkData): return p != perk)
	_distrubute_perks(rejected)
	EventBus.perk_picked.emit(perk)


func _on_perk_card_removed(perk: PerkData)->void:
	perk_pool.erase(perk)
	EventBus.perk_removed.emit(perk)
