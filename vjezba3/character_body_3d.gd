extends CharacterBody3D

const SPEED = 5.0
const RUN_SPEED = 10.0
const CROUCH_SPEED = 2.5
const STAND_HEIGHT = 1.8
const CROUCH_HEIGHT = 1.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8
const SENSITIVITY = 0.03

var stamina = 100.0
var is_running = false
var is_crouching = false
var pitch = 0.0
var camera_stand_y
var camera_crouch_y

var health := 100.0
var max_health := 100.0
var jump_velocity_current := JUMP_VELOCITY
var speed_multiplier := 1.0
var current_gravity := GRAVITY

@onready var head = $Head
@onready var fps_camera = $Head/Camera3D
@onready var weapon_pivot = $Head/Camera3D/Weapon
@onready var collider = $CollisionShape3D
@onready var health_bar = $"../HUD/VBoxContainer/HealthBar"
@onready var hud_status = $"../HUD/VBoxContainer/StatusLabel"
@onready var speed_zone = $"../SpeedZone"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fps_camera.current = true
	camera_stand_y = head.position.y
	camera_crouch_y = camera_stand_y - 0.6
	head.position.y = camera_stand_y
	collider.shape.radius = 0.3
	collider.shape.height = STAND_HEIGHT
	update_hud()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		pitch -= event.relative.y * SENSITIVITY
		pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))
		fps_camera.rotation.x = pitch
		return

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

	var wants_to_run = Input.is_action_pressed("run")
	is_running = wants_to_run and is_moving
	var speed = SPEED
	if is_running:
		speed = RUN_SPEED
	elif is_crouching:
		speed = CROUCH_SPEED

	velocity.x = direction.x * speed * speed_multiplier
	velocity.z = direction.z * speed * speed_multiplier

	if not is_on_floor():
		velocity.y -= current_gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity_current

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var col = collision.get_collider()
		if col.has_method("on_player_hit"):
			col.on_player_hit(self)

func take_damage(amount: float):
	health = clamp(health - amount, 0.0, max_health)
	update_hud()
	set_status("-%d HP" % amount)
	if health <= 0.0:
		set_status("Mrtav!")

func apply_jump_boost(new_jump: float, duration: float):
	jump_velocity_current = new_jump
	set_status( "Jump boost aktiviran!")
	await get_tree().create_timer(duration).timeout
	jump_velocity_current = JUMP_VELOCITY
	set_status("")

func set_speed_multiplier(value: float):
	speed_multiplier = value

func set_gravity(value: float):
	current_gravity = value

func set_status(text: String):
	if hud_status:
		hud_status.text = text

func update_hud():
	if health_bar:
		health_bar.value = health
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("interact"):
			if speed_zone:
				speed_zone.deactivate_temporarily(self)
