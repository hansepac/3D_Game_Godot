extends Node3D

@export var ANGLE: float = 30
@export var SPEED: float = 10

@export var projectile_scene: PackedScene = load("res://entity/weapons/projectiles/rock.tscn")

@onready var projectile_spawn_node: Node3D = $ProjectileSpawn

@onready var player_camera: Camera3D = get_parent().get_node("Head/Camera") # Assuming the player has a Camera3D node as a child

func fire() -> void:
	# Instantiate the projectile
	var projectile: RigidBody3D = projectile_scene.instantiate()

	# Add the projectile to the scene
	get_tree().root.add_child(projectile)

	# Set the position of the projectile at the spawn node's position
	projectile.global_position = projectile_spawn_node.global_position
	
	# Get the direction the camera is looking (forward direction)
	var firing_direction = -player_camera.global_transform.basis.z.normalized()

	# Apply an impulse in the direction the camera is looking
	projectile.apply_impulse(firing_direction * SPEED)
	
