extends CharacterBody3D

class_name Player

#General Movement
const SPEED = 10.0
const JUMP_VELOCITY = 10.0
const SENSITIVITY = 0.002
const DASH_VELOCITY = 250.0
const WALL_TILT = 0.7
var direction: Vector3 = Vector3.ZERO

#To Avoid Magic Numbers
const HALF_TIME = 0.5
const NORMAL_TIME = 1.0
const WALL_TILT_WEIGHT = 0.09
const TILT_WEIGHT = 0.1
const CROUCH_WEIGHT = 0.3


#Jump
var JUMP_COUNT = 2

#Wall Movement
var WALL_INTERACTION = 1
var WALL_DETECTION = 1

#Dash

signal dashed
var MIN_DASH = 0;
var MAX_DASH = 100;
var is_dashing = false
var dash_direction = Vector3.ZERO
var DASH_TIME = 0.1
var DASH_TIMER = 0.0

#Slowdown
var is_slowdown = false
var SLOW_TIME = 1.0
var SlOW_TIMER = 0.0

#Tilt
var SIDEWAYS_TILT = 0.0
var NORMAL_TILT = 0.0

var crouching_height = 1.0
var standing_height = 2.0
var is_crouching = false

@onready var state_machine = $StateMachine
@onready var CURRENT_DASH: int = MIN_DASH
@onready var LEFT_RAYCAST = $LeftRaycast;
@onready var RIGHT_RAYCAST = $RightRaycast;
@onready var FORWARD_RAYCAST = $ForwardRaycast;
@onready var BACKWARD_RAYCAST = $BackwardRaycast;
@onready var head = $Head;
@onready var camera = $Head/FPSCam;
@onready var head_mesh = $Head/HeadMesh
@onready var weapon_controller = $WeaponController

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		if is_on_floor():
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(100))

func _physics_process(delta: float) -> void:
	update_direction()
	if not is_on_floor():
		handle_slowdown(delta)
	apply_head_tilt()
	if state_machine.active_state:
		state_machine.active_state._physics_update(delta)
	move_and_slide()


	
func update_direction() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func apply_head_tilt() -> void:
	if direction:
		NORMAL_TILT = head.transform.basis.z.dot(direction) * 3.5
		SIDEWAYS_TILT = head.transform.basis.x.dot(direction) * -2.5
	else:
		NORMAL_TILT = 0.0
		SIDEWAYS_TILT = 0.0
	head.rotation_degrees.z = lerp(head.rotation_degrees.z, SIDEWAYS_TILT, TILT_WEIGHT)
	head.rotation_degrees.x = lerp(head.rotation_degrees.x, NORMAL_TILT, TILT_WEIGHT)

func apply_ground_movement() -> void:
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		

func apply_air_movement() -> void:
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func reset_ground_vars() -> void:
	JUMP_COUNT = 2
	WALL_INTERACTION = 1
	SlOW_TIMER = 0.0
	is_slowdown = false
	Engine.time_scale = NORMAL_TIME

func try_dash() -> bool:
	if Input.is_action_just_pressed("Dash") and direction != Vector3.ZERO:
		return true
	return false

func try_jump() -> bool:
	if Input.is_action_just_pressed("Jump") and JUMP_COUNT > 0:
		velocity.y = JUMP_VELOCITY
		JUMP_COUNT -= 1
		return true
	return false

func try_wall_jump() -> bool:
	if Input.is_action_just_pressed("Jump") and JUMP_COUNT > 0 and is_on_wall() and not is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.5
		JUMP_COUNT -= 1
		WALL_INTERACTION = 0
		return true
	return false

func crouching() -> void:
	if Input.is_action_pressed("Crouch"):
		camera.position.y = lerp(camera.position.y, crouching_height, CROUCH_WEIGHT)
	else:
		camera.position.y = lerp(camera.position.y, standing_height, CROUCH_WEIGHT)

func wall_detection() -> void:
	RIGHT_RAYCAST.target_position = head.transform.basis.x.normalized() * WALL_DETECTION
	LEFT_RAYCAST.target_position = (-head.transform.basis.x).normalized() * WALL_DETECTION
	FORWARD_RAYCAST.target_position = head.transform.basis.z.normalized() * WALL_DETECTION
	BACKWARD_RAYCAST.target_position = (-head.transform.basis.z.normalized()) * WALL_DETECTION
	LEFT_RAYCAST.enabled = true
	RIGHT_RAYCAST.enabled = true
	FORWARD_RAYCAST.enabled = true
	BACKWARD_RAYCAST.enabled = true
	if RIGHT_RAYCAST.is_colliding():
		head.rotation.z = lerp(head.rotation.z, WALL_TILT, WALL_TILT_WEIGHT)
	elif LEFT_RAYCAST.is_colliding():
		head.rotation.z = lerp(head.rotation.z, -WALL_TILT, WALL_TILT_WEIGHT)
	elif FORWARD_RAYCAST.is_colliding() or BACKWARD_RAYCAST.is_colliding():
		pass

func handle_slowdown(delta: float) -> void:
	if Input.is_action_just_pressed("Slowdown"):
		is_slowdown = !is_slowdown
		SlOW_TIMER = SLOW_TIME
	if is_slowdown:
		SlOW_TIMER -= delta
		Engine.time_scale = HALF_TIME if SlOW_TIMER > 0 else NORMAL_TIME
		if SlOW_TIMER <= 0:
			is_slowdown = false
	elif not is_on_floor():
		Engine.time_scale = NORMAL_TIME
