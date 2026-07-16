extends CanvasLayer

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
	show()


func hide_ui()->void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
