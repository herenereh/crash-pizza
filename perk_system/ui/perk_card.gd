extends Control

## Emitted when the player picks this card to add the perk to their build.
signal picked(perk: PerkData)
## Emitted when the player destroys this card instead of picking it.
signal card_destroyed(perk: PerkData)

var perk_data: PerkData

@onready var artwork = $MarginContainer/VBoxContainer/PerkArtwork
@onready var name_label = $MarginContainer/VBoxContainer/PerkName
@onready var desc_label = $MarginContainer/VBoxContainer/PerkDescription
@onready var rarity_label = $MarginContainer/VBoxContainer/Rarity
@onready var pick_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/PickButton
@onready var destroy_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/DestroyButton

func _ready() -> void:
	pick_button.pressed.connect(_on_pick_pressed)
	destroy_button.pressed.connect(_on_destroy_pressed)

func _setup(data: PerkData) -> void:
	perk_data = data
	artwork.texture = data.perk_icon
	name_label.text = data.perk_name
	desc_label.text = data.perk_description
	rarity_label.text = PerkData.Rarity.keys()[data.rarity]

func _on_pick_pressed() -> void:
	picked.emit(perk_data)

func _on_destroy_pressed() -> void:
	card_destroyed.emit(perk_data)
