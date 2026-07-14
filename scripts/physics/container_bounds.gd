class_name ContainerBounds
extends Node2D

const DEFAULT_CONFIG := preload("res://resources/physics_config.tres")

@export var config: PhysicsConfig = DEFAULT_CONFIG

@onready var _floor_body: StaticBody2D = $FloorBody
@onready var _wall_body: StaticBody2D = $WallBody


func _ready() -> void:
	_apply_materials()


func _apply_materials() -> void:
	var floor_material := PhysicsMaterial.new()
	floor_material.bounce = config.bounce_floor
	floor_material.friction = config.friction
	_floor_body.physics_material_override = floor_material

	var wall_material := PhysicsMaterial.new()
	wall_material.bounce = 1.0
	wall_material.friction = config.friction
	_wall_body.physics_material_override = wall_material
