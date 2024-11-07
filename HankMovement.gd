extends CharacterBody3D

const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.002
const DASH_VELOCITY = 400
var JUMP_COUNT = 2
var WALL_INTERACTION = 1

var SIDEWAYS_TILT = 0.0
var NORMAL_TILT = 0.0

var CURRENT_STATE = PlayerState.WalkingState

@onready var head = $Head;
@onready var camera = $Head/FPSCam;

enum PlayerState { WalkingState, RunningState, MidAirState, DashState, OnWallState}


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;  
	# Video'da farklı bir kod kullanıyor fakat ileriki versiyonlarında artık bu kod kullanılıyor.
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if not is_on_floor():
			
			head.rotate_y(-event.relative.x * SENSITIVITY)	
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			
		else:
			
			head.rotate_y(-event.relative.x * SENSITIVITY)	
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(100))
			
			
			
			
func _physics_process(delta: float) -> void:
	
	if is_on_wall() and not is_on_floor() and WALL_INTERACTION > 0:
		head.rotation.z = lerp(head.rotation.z, 0.5, 0.1)
		if Input.is_action_just_pressed("Jump"):
			WALL_INTERACTION = 0;
			JUMP_COUNT += JUMP_COUNT
			velocity.y = JUMP_VELOCITY * 2
			
			
			
	if not is_on_floor() :
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and JUMP_COUNT > 1 :
		
		velocity.y = JUMP_VELOCITY
		JUMP_COUNT -= JUMP_COUNT
		
	if is_on_floor():
		JUMP_COUNT = 2
		WALL_INTERACTION = 1;
		
	# Dash mechanic
	#if Input.is_action_just_pressed("Dash"):
	
	
	head.rotation_degrees.z = lerp(head.rotation_degrees.z, SIDEWAYS_TILT, 0.1)	
	head.rotation_degrees.x = lerp(head.rotation_degrees.x, NORMAL_TILT, 0.1)	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		NORMAL_TILT = head.transform.basis.z.dot(direction) * 3.5
		SIDEWAYS_TILT = head.transform.basis.x.dot(direction) * -2.5
		
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		NORMAL_TILT = 0.0
		SIDEWAYS_TILT = 0.0
		
	move_and_slide()
	
