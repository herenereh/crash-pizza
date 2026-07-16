extends Control

var perk_data: PerkData

@onready var artwork = $MarginContainer/VBoxContainer/PerkArtwork
@onready var name_label = $MarginContainer/VBoxContainer/PerkName
@onready var desc_label = $MarginContainer/VBoxContainer/PerkDescription
@onready var rarity_label = $MarginContainer/VBoxContainer/Rarity

func _setup(data: PerkData) -> void:
	perk_data = data
	artwork.texture = data.perk_icon
	name_label.text = data.perk_name
	desc_label.text = data.perk_description
	rarity_label.text = PerkData.Rarity.keys()[data.rarity]
