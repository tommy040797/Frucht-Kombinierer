class_name ContainerBounds
extends StaticBody2D

const DEFAULT_CONFIG := preload("res://resources/physics_config.tres")

@export var config: PhysicsConfig = DEFAULT_CONFIG

@onready var _floor: CollisionPolygon2D = $Floor
@onready var _left_wall: CollisionPolygon2D = $LeftWall
@onready var _right_wall: CollisionPolygon2D = $RightWall


func _ready() -> void:
	_apply_materials()


func _apply_materials() -> void:
	var floor_material := PhysicsMaterial.new()
	floor_material.bounce = config.bounce_floor
	floor_material.friction = config.friction
	_floor.physics_material_override = floor_material

	var wall_material := PhysicsMaterial.new()
	wall_material.bounce = 1.0
	wall_material.friction = config.friction
	_left_wall.physics_material_override = wall_material
	_right_wall.physics_material_override = wall_material
