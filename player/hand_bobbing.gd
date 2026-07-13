extends Sprite2D

@export var player: Player
@export var is_left_hand: bool = false


@export var bob_frequency: float 
@export var bob_amount_x: float
@export var bob_amount_y: float	
@export var bob_return_speed: float

@export var recoil_amount: float
@export var recoil_return_speed: float

@export var vertical_tilt_amount: float = 1.5
@export var horizontal_tilt_amount: float = 1.5
@export var max_vertical_offset: float = 50
@export var max_horizontal_offset: float = 75
var bob_time = 0.0
var bob_offset := Vector2.ZERO
var recoil_offset := Vector2.ZERO
var rest_position := Vector2.ZERO
var vertical_offset := Vector2.ZERO
var horizontal_offset := Vector2.ZERO



func _ready() -> void:
	rest_position = position

func _process(delta: float) -> void:
	var local_velocity: Vector3 = player.camera.global_transform.basis.inverse() * player.velocity
	var speed := Vector2(player.velocity.x, player.velocity.z).length()
	
	if speed > 0.1 and player.is_on_floor():
		bob_time += delta * bob_frequency * (speed/player.SPEED)
		var phase: float = bob_time + (PI if is_left_hand else 0.0)
		var bob_x: float = sin(phase) * bob_amount_x
		var bob_y: float = abs(sin(phase)) * bob_amount_y
		var target_offset := Vector2(bob_x, bob_y)
		bob_offset = lerp(bob_offset, target_offset, 0.5)
	else:
		bob_offset = lerp(bob_offset, Vector2.ZERO, bob_return_speed * delta)
	
	var horizontal_target := Vector2(
		clamp(local_velocity.x * horizontal_tilt_amount, -max_horizontal_offset, max_horizontal_offset), 
		clamp(local_velocity.z * horizontal_tilt_amount, -max_horizontal_offset, max_horizontal_offset))
	horizontal_offset = lerp(horizontal_offset, horizontal_target, 0.1)
	var vertical_target := Vector2(0.0, clamp(-local_velocity.y * vertical_tilt_amount, -max_vertical_offset, max_vertical_offset))
	vertical_offset = lerp(vertical_offset, vertical_target, 0.1)
	position = rest_position + bob_offset + recoil_offset + vertical_offset + horizontal_offset
	
