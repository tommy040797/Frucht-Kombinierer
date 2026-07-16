class_name FruitBody
extends RigidBody2D

const DEFAULT_DATABASE := preload("res://resources/fruit_database.tres")
const ACTIVE_COLLISION_LAYER := 2
const ACTIVE_COLLISION_MASK := 3
const POOL_PARK_POSITION := Vector2(-10000, -10000)

const TIER_COLORS := {
	1: Color(0.9, 0.2, 0.2, 1.0),
	2: Color(0.95, 0.35, 0.55, 1.0),
	3: Color(0.55, 0.25, 0.75, 1.0),
	4: Color(1.0, 0.55, 0.15, 1.0),
	5: Color(0.85, 0.15, 0.15, 1.0),
	6: Color(0.7, 0.85, 0.25, 1.0),
	7: Color(1.0, 0.65, 0.4, 1.0),
	8: Color(0.3, 0.75, 0.35, 1.0),
	9: Color(0.95, 0.85, 0.2, 1.0),
	10: Color(0.9, 0.45, 0.1, 1.0),
	11: Color(1.0, 0.84, 0.0, 1.0),
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
	_set_pooled(false)
	visible = true
	sleeping = false


func reset_for_pool() -> void:
	tier = 0
	is_settled = false
	is_in_danger_zone = false
	is_merging = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	_set_pooled(true)
	global_position = POOL_PARK_POSITION
	visible = false
	sleeping = true


func _set_pooled(pooled: bool) -> void:
	freeze = pooled
	if pooled:
		collision_layer = 0
		collision_mask = 0
	else:
		collision_layer = ACTIVE_COLLISION_LAYER
		collision_mask = ACTIVE_COLLISION_MASK
	if _collision_shape != null:
		_collision_shape.disabled = pooled


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
