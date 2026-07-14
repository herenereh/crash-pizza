class_name ChaseMovement extends MovementStrategy

var speed: float
var enemy: BaseEnemy

func _init(speed: float)->void:
    self.speed = speed

func move(enemy: BaseEnemy, player: Player)->void:
    var direction = (player.global_position - enemy.global_position).normalized()
    enemy.velocity = direction * speed

