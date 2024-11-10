extends Node3D

@export var ANGLE: float = 30
@export var SPEED: float = 5

@export var projectile_scene: PackedScene = load("res://entity/weapons/projectiles/rock.tscn")

@onready var projectile_spawn_node: Node3D = $ProjectileSpawn

func fire() -> void:
	var projectile: RigidBody3D = projectile_scene.instantiate()
	
	projectile.global_position = projectile_spawn_node.global_position
	projectile.look_at(projectile_spawn_node.global_position + global_transform.basis.z.normalized())
	
	projectile.apply_impulse(Vector3.ZERO, -global_transform.basis.z.normalized() * SPEED)  # Apply an impulse force
	
	self.add_child(projectile)
