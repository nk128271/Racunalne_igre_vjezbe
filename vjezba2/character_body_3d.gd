extends CharacterBody3D

const SPEED = 5.0
const RUN_SPEED = 10.0
const CROUCH_SPEED = 2.5

const STAND_HEIGHT = 1.8
const CROUCH_HEIGHT = 1.0

const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

const SENSITIVITY = 0.03

const STAMINA_MAX = 100.0
const STAMINA_DRAIN = 20.0
const STAMINA_RECOVER = 10.0
const STAMINA_THRESHOLD = 10.0

const EXHAUST_DELAY = 5.0
const TPS_SMOOTH = 8.0

var stamina = 100.0
var is_running = false
var is_crouching = false
var exhausted = false
var exhaust_timer = 0.0

var is_fps = true
var pitch = 0.0

var camera_stand_y
var camera_crouch_y

@onready var head = $Head
@onready var fps_camera = $Head/Camera3D
@onready var tps_camera = $ThirdPersonPivot/Camera3D
@onready var tps_pivot = $ThirdPersonPivot
@onready var weapon_pivot = $Head/Camera3D/Weapon
@onready var collider = $CollisionShape3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	fps_camera.current = true
	tps_camera.current = false

	camera_stand_y = head.position.y
	camera_crouch_y = camera_stand_y - 0.6

	head.position.y = camera_stand_y

	collider.shape.radius = 0.3
	collider.shape.height = STAND_HEIGHT

func _unhandled_input(event):
	if Input.is_action_just_pressed("switch_camera"):
		is_fps = !is_fps
		fps_camera.current = is_fps
		tps_camera.current = not is_fps
		weapon_pivot.visible = is_fps

	if event is InputEventMouseMotion:
		if is_fps:
			head.rotate_y(-event.relative.x * SENSITIVITY)

			pitch -= event.relative.y * SENSITIVITY
			pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))

			fps_camera.rotation.x = pitch
		else:
			head.rotate_y(-event.relative.x * SENSITIVITY)

func _physics_process(delta):

	var direction = Vector3.ZERO

	var forward = -head.global_transform.basis.z
	var right = head.global_transform.basis.x

	forward.y = 0
	right.y = 0

	forward = forward.normalized()
	right = right.normalized()

	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_backward"):
		direction -= forward
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_right"):
		direction += right

	direction = direction.normalized()
	var is_moving = direction.length() > 0


	is_crouching = Input.is_action_pressed("crouch")

	collider.shape.height = lerp(
		collider.shape.height,
		STAND_HEIGHT if not is_crouching else CROUCH_HEIGHT,
		10 * delta
	)

	var target_y = camera_crouch_y if is_crouching else camera_stand_y
	head.position.y = lerp(head.position.y, target_y, 10 * delta)

	if stamina <= 0 and not exhausted:
		exhausted = true
		exhaust_timer = EXHAUST_DELAY

	if exhausted:
		exhaust_timer -= delta
		if exhaust_timer <= 0:
			exhausted = false

	
	var wants_to_run = Input.is_action_pressed("run")
	is_running = wants_to_run and is_moving and not exhausted and not is_crouching

	if is_running:
		stamina -= STAMINA_DRAIN * delta
	elif not exhausted:
		stamina += STAMINA_RECOVER * delta

	stamina = clamp(stamina, 0, STAMINA_MAX)

	
	var speed = SPEED

	if is_running:
		speed = RUN_SPEED
	elif is_crouching:
		speed = CROUCH_SPEED

	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	if not is_fps:
		var target_pos = $CameraTarget.global_position

		tps_pivot.global_position = tps_pivot.global_position.lerp(
			target_pos,
			8.0 * delta
	)
		tps_pivot.rotation.y = lerp_angle(
			tps_pivot.rotation.y,
			head.rotation.y,
			8.0 * delta
	)


	move_and_slide()
	print("Stamina:", stamina, " Running:", is_running, " Exhausted:", exhausted)
