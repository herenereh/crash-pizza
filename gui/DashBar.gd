extends ProgressBar

@export var player: Player
@export var increase_per_dash: float = 5.0
@export var decrease_per_second: float = 1.0
@export var wait_before_decay: float = 3.0

var time_since_last_dash := 0.0

func _ready():
	player.dashed.connect(_on_player_dashed)
	update()
	set_process(true)

func _on_player_dashed():
	player.CURRENT_DASH += increase_per_dash
	player.CURRENT_DASH = clamp(player.CURRENT_DASH, 0, player.MAX_DASH)
	time_since_last_dash = 0.0
	update()
	
func _process(delta):
	time_since_last_dash += delta

	if time_since_last_dash > wait_before_decay:
		player.CURRENT_DASH -= decrease_per_second * delta
		player.CURRENT_DASH = clamp(player.CURRENT_DASH, 0, player.MAX_DASH)
		update()

func update():
	value = player.CURRENT_DASH * 100 / player.MAX_DASH
