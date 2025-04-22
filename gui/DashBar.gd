extends ProgressBar

@export var player: Player
@export var regen_per_unit: int = 5

func _ready():
	player.dashed.connect(update)
	update()

func update():
	value = player.CURRENT_DASH * 100 / player.MAX_DASH
	
