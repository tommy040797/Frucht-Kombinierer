class_name FruitBody
extends RigidBody2D

const DEFAULT_DATABASE := preload("res://resources/fruit_database.tres")

const TIER_COLORS := {
	1: Color(0.9, 0.2, 0.2, 1.0),
	2: Color(0.95, 0.35, 0.55, 1.0),
}

@export var database: Resource = DEFAULT_DATABASE

var tier: int = 0
var is_settled: bool = false
var is_in_danger_zone: bool = false
var is_merging: bool = false

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _visual: ColorRect = $FruitVisual


func configure_from_tier(p_tier: int, p_database: Resource = database) -> void:
	var definition = p_database.get_by_tier(p_tier)
	if definition == null:
		push_error("FruitBody: no definition for tier %d" % p_tier)
		return

	tier = p_tier
	mass = definition.mass
	_apply_physics_material(definition.friction)
	_apply_radius(definition.radius, p_tier)
	visible = true
	sleeping = false


func reset_for_pool() -> void:
	tier = 0
	is_settled = false
	is_in_danger_zone = false
	is_merging = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	sleeping = true
	visible = false


func _apply_radius(radius: float, p_tier: int) -> void:
	var circle := CircleShape2D.new()
	circle.radius = radius
	_collision_shape.shape = circle
	_apply_visual(radius, p_tier)


func _apply_visual(radius: float, p_tier: int) -> void:
	_visual.color = TIER_COLORS.get(p_tier, Color(0.7, 0.7, 0.7, 1.0))
	_visual.offset_left = -radius
	_visual.offset_top = -radius
	_visual.offset_right = radius
	_visual.offset_bottom = radius


func _apply_physics_material(friction: float) -> void:
	var material := PhysicsMaterial.new()
	material.friction = friction
	material.bounce = 0.2
	physics_material_override = material
