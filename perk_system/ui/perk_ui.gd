extends CanvasLayer

## Bubbled up from whichever PerkCard the player picked.
signal perk_selected(perk: PerkData)
## Bubbled up from whichever PerkCard the player destroyed.
signal perk_card_destroyed(perk: PerkData)

const PerkCard = preload("res://perk_system/ui/perk_card.tscn")

@onready var card_container: HBoxContainer = $PerkPanel/CardContainer

func _ready()->void:
	hide()


func show_perks(perks: Array[PerkData])->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for child in card_container.get_children():
		child.queue_free()
	for perk in perks:
		var card = PerkCard.instantiate()
		card.perk_data = perk
		card_container.add_child(card)
		card._setup(perk)
		card.picked.connect(_on_card_picked)
		card.card_destroyed.connect(_on_card_destroyed)
	show()


## Removes a single card from the offer (used after a destroy) without closing the whole draft.
func remove_card(perk: PerkData)->void:
	for card in card_container.get_children():
		if card.perk_data == perk:
			card.queue_free()
			break


func has_cards()->bool:
	return card_container.get_child_count() > 0


func hide_ui()->void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_card_picked(perk: PerkData)->void:
	perk_selected.emit(perk)


func _on_card_destroyed(perk: PerkData)->void:
	perk_card_destroyed.emit(perk)
