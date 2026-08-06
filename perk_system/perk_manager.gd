class_name PerkManager extends Node

@export var perk_pool: Array[PerkData] = []
@export var enemy_perk_pool: Array[PerkData] = []
## Dash meter drained from the player for every card they destroy instead of picking.
@export var destroy_dash_cost: float = 25.0

var perk_ui: CanvasLayer
var player: Player
var player_component: PerkComponent

var current_offer: Array[PerkData] = []
var current_enemy_rolls: Array[PerkData] = []
var is_drafting: bool = false


func _ready()->void:
	perk_ui = get_tree().get_first_node_in_group("PerkUI")
	player = get_tree().get_first_node_in_group("Player") as Player
	if player:
		player_component = player.get_node_or_null("PerkComponent")
	perk_ui.perk_selected.connect(_on_perk_card_picked)
	perk_ui.perk_card_destroyed.connect(_on_perk_card_removed)
	#EventBus.room_cleared.connect(start_draft)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Perk Debug"):
		start_draft()


func start_draft()->void:
	if is_drafting or perk_pool.is_empty():
		return
	is_drafting = true
	current_offer = _pick_random(perk_pool, 3)
	current_enemy_rolls = _pick_random(enemy_perk_pool, current_offer.size())
	perk_ui.show_perks(current_offer)


func _pick_random(pool: Array[PerkData], count: int)->Array[PerkData]:
	var shuffled = pool.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)


func _end_draft()->void:
	is_drafting = false
	current_offer.clear()
	current_enemy_rolls.clear()
	perk_ui.hide_ui()


func _on_perk_card_picked(perk: PerkData)->void:
	var picked_index := current_offer.find(perk)
	player_component.apply_perk(perk)
	_give_enemies_perks(picked_index)
	perk_pool.erase(perk)
	EventBus.perk_picked.emit(perk)
	_end_draft()


func _give_enemies_perks(skip_index: int)->void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for i in current_enemy_rolls.size():
		if i == skip_index:
			continue
		var shadow_perk := current_enemy_rolls[i]
		for enemy in enemies:
			var comp = enemy.get_node_or_null("PerkComponent")
			if comp:
				comp.apply_perk(shadow_perk)
		EventBus.perk_rejected.emit(shadow_perk)


func _on_perk_card_removed(perk: PerkData)->void:
	var index := current_offer.find(perk)
	if player:
		player.drain_dash(destroy_dash_cost)
	perk_pool.erase(perk)
	if index != -1:
		current_offer.remove_at(index)
		current_enemy_rolls.remove_at(index)
	perk_ui.remove_card(perk)
	EventBus.perk_destroyed.emit(perk)
	if not perk_ui.has_cards():
		_end_draft()
