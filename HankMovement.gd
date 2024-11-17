extends CharacterBody3D

const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.002
const DASH_VELOCITY = 250.0
const WALL_TILT = 0.7

var JUMP_COUNT = 2
var WALL_INTERACTION = 1
var WALL_DETECTION = 1
var is_dashing = false
var DASH_TIME = 0.1
var DASH_TIMER = 0.0
var dash_direction = Vector3.ZERO


var SIDEWAYS_TILT = 0.0
var NORMAL_TILT = 0.0

var CURRENT_STATE = PlayerState.WalkingState

@onready var LEFT_RAYCAST = $LeftRaycast;
@onready var RIGHT_RAYCAST = $RightRaycast;
@onready var head = $Head;
@onready var camera = $Head/FPSCam;


enum PlayerState { WalkingState, RunningState, MidAirState, DashState, OnWallState}


func wall_detecion():
	
	RIGHT_RAYCAST.target_position = head.transform.basis.x.normalized() * WALL_DETECTION
	LEFT_RAYCAST.target_position = (-head.transform.basis.x).normalized() * WALL_DETECTION
	LEFT_RAYCAST.enabled = true
	RIGHT_RAYCAST.enabled = true
	if (RIGHT_RAYCAST.is_colliding()):
		head.rotation.z = lerp(head.rotation.z, WALL_TILT, 0.09)
	else:
		head.rotation.z = lerp(head.rotation.z, -WALL_TILT, 0.09)	

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
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_wall() and not is_on_floor() and WALL_INTERACTION > 0:
		
		wall_detecion()
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY * 2
			WALL_INTERACTION = 0;
			JUMP_COUNT += JUMP_COUNT
			#Çift zıplamada zıplamayı ikiye katlıyor
			#Tek zıplamada normal hızda zıplıyor
			#Çözülmesi gerek
			
	if not is_on_floor() :
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and JUMP_COUNT > 1 :
		
		velocity.y = JUMP_VELOCITY
		JUMP_COUNT -= JUMP_COUNT
		
	if is_on_floor():
		JUMP_COUNT = 2
		WALL_INTERACTION = 1;
		
	head.rotation_degrees.z = lerp(head.rotation_degrees.z, SIDEWAYS_TILT, 0.1)	
	head.rotation_degrees.x = lerp(head.rotation_degrees.x, NORMAL_TILT, 0.1)	
	
	if direction:
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		NORMAL_TILT = head.transform.basis.z.dot(direction) * 3.5
		SIDEWAYS_TILT = head.transform.basis.x.dot(direction) * -2.5
			  
		if is_dashing:
			
			DASH_TIMER -= delta
			if DASH_TIMER > 0:
				velocity.x = lerp(velocity.x, dash_direction.x * DASH_VELOCITY, 0.2)
				velocity.z = lerp(velocity.z, dash_direction.z * DASH_VELOCITY, 0.2)
			if DASH_TIMER <=0:
				is_dashing = false
		
		if Input.is_action_just_pressed("Dash"):
			is_dashing = true
			DASH_TIMER = DASH_TIME
			dash_direction = direction.normalized()
			
		
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		NORMAL_TILT = 0.0
		SIDEWAYS_TILT = 0.0
		
	move_and_slide()
