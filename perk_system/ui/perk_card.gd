extends PanelContainer

func _setup(data: PerkData):
	$VBoxContainer/PerkArtwork.texture = data.perk_icon
	$VBoxContainer/PerkDescription.text = data.perk_description
	$VBoxContainer/PerkName.text = data.perk_name
	$VBoxContainer/Rarity.text = data.Rarity.keys()[data.rarity]
