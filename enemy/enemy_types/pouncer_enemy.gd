class_name PouncerEnemy extends BaseEnemy

func _ready() -> void:
	super._ready()
	var pounce_attack = PouncingAttack.new()
	pounce_attack.pounce_force = 12.0
	add_child(pounce_attack)
	var default_movement = MovementStrategy.new()
	add_child(default_movement)
	set_movement(default_movement)
	set_attack(pounce_attack)
