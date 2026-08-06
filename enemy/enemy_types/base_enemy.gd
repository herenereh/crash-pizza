class_name BaseEnemy extends Entity

var player: Player

var movement: MovementStrategy
var attack: AttackStrategy

const BASE_MOVE_SPEED: float = 5.0
var bonus_move_speed: float = 0.0

func current_move_speed() -> float:
	return BASE_MOVE_SPEED + bonus_move_speed

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as Player

const ATTACK_RANGE = 3.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	if player:
		var dist = global_position.distance_to(player.global_position)
		if movement:
			movement.move(self, player)
		if attack and dist < ATTACK_RANGE:
			attack.attack(self, player)
	move_and_slide()
	
func set_movement(m: MovementStrategy)->void:
	movement = m

func set_attack(a: AttackStrategy)->void:
	attack = a
