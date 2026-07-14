extends Node

# Player events
signal player_fired(weapon: Weapon)
signal player_dashed
signal player_jumped
signal player_landed
signal player_took_damage(amount: float)
signal player_killed_enemy

# Room events
signal room_entered
signal room_cleared

# Perk events
signal perk_picked(perk: PerkData)
signal perk_rejected(perk: PerkData)
signal perk_destroyed(perk: PerkData)
