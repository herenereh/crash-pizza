class_name PerkData
extends Resource

enum Rarity { COMMON, RARE, LEGENDARY }

@export_category("Identity")
@export var perk_name: String
@export var perk_description: String
@export var perk_icon: Texture2D
@export var rarity: Rarity

@export_category("Effect")
@export var effect_scene: PackedScene
