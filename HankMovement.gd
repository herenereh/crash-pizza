extends CharacterBody3D

const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.002
const DASHVELOCITY = 400

var zAngforCamToLerpTo = 0.0
var xAngforCamToLerpTo = 0.0

@onready var head = $Head;
@onready var camera = $Head/FPSCam;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;  
	# Video'da farklı bir kod kullanıyor fakat ileriki versiyonlarında artık bu kod kullanılıyor.
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)	
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(100))
		
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Dash mechanic
	#if Input.is_action_just_pressed("Dash"):
				
				
	head.rotation_degrees.z = lerp(head.rotation_degrees.z, zAngforCamToLerpTo, 0.1)	
	head.rotation_degrees.x = lerp(head.rotation_degrees.x, xAngforCamToLerpTo, 0.1)	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		xAngforCamToLerpTo = direction.x * -2.5
		zAngforCamToLerpTo = direction.z * 2.5
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		xAngforCamToLerpTo = 0.0;
		zAngforCamToLerpTo = 0.0;
		
	move_and_slide()
