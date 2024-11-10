extends CharacterBody3D

@onready var Head: Node3D = $Head

@export var SPEED: int = 5
@export var ACCEL: int = 50
@export var JUMP_VEL: int = 5

@export_category("Head")
@export var CLAMP_HEAD_ROTATION: bool = true
@export var CLAMP_HEAD_ROTATION_MIN: float = -90
@export var CLAMP_HEAD_ROTATION_MAX: float = 90


@export_category("Key Bindings")
@export var MOUSE_ACCEL: bool = true
@export var KEY_BIND_H_AIM_SENSITIVITY: float = 0.002
@export var KEY_BIND_V_AIM_SENSITIVITY: float = 0.002
@export var KEY_BIND_MOUSE_ACCEL: float = 50


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var horiz_direction: Vector3
var rotation_target_player: float
var rotation_target_head: float
#var gun: Node3D = load("res://entity/weapons/catapult_gun.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_rotation_target(event.relative)

func _physics_process(delta: float) -> void:
	var on_floor = is_on_floor()
	var speed = SPEED
	
	# If sprint
	if Input.is_action_pressed("sprint"):
		speed = 50
		
	
	# Movement Direction
	if Input.is_action_pressed("forward") or Input.is_action_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		horiz_direction = transform.basis * Vector3(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0,
			Input.get_action_strength("backward") - Input.get_action_strength("forward")
		)
	else:
		horiz_direction = Vector3.ZERO
	
	# Jump and Gravity
	if not on_floor:
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y += JUMP_VEL

	# Update Horizontal movement
	velocity.x = move_toward(velocity.x, horiz_direction.x * speed, ACCEL * delta)
	velocity.z = move_toward(velocity.z, horiz_direction.z * speed, ACCEL * delta)
	
	# Whatever the fetch this does
	move_and_slide()

func _process(delta: float) -> void:
	# Update camera aim
	rotate_player(delta)

func set_rotation_target(mouse_motion : Vector2):
	# Add player target to the mouse -x input
	rotation_target_player += -mouse_motion.x * KEY_BIND_H_AIM_SENSITIVITY
	# Add head target to the mouse -y input
	rotation_target_head += -mouse_motion.y * KEY_BIND_V_AIM_SENSITIVITY
	# Clamp rotation
	if CLAMP_HEAD_ROTATION:
		rotation_target_head = clamp(rotation_target_head, deg_to_rad(CLAMP_HEAD_ROTATION_MIN), deg_to_rad(CLAMP_HEAD_ROTATION_MAX))

func rotate_player(delta: float):
	if MOUSE_ACCEL:
		# Shperical lerp between player rotation and target
		quaternion = quaternion.slerp(Quaternion(Vector3.UP, rotation_target_player), KEY_BIND_MOUSE_ACCEL * delta)
		# Same again for head
		$Head.quaternion = $Head.quaternion.slerp(Quaternion(Vector3.RIGHT, rotation_target_head), KEY_BIND_MOUSE_ACCEL * delta)
	else:
		# If mouse accel is turned off, simply set to target
		quaternion = Quaternion(Vector3.UP, rotation_target_player)
		$Head.quaternion = Quaternion(Vector3.RIGHT, rotation_target_head)
	
	
	
	
	
