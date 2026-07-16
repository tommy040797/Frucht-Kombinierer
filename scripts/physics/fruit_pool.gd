class_name FruitPool
extends Node

const FRUIT_BODY_SCENE := preload("res://scenes/fruits/fruit_body.tscn")
const PHYSICS_CONFIG := preload("res://resources/physics_config.tres")
const DEFAULT_DATABASE := preload("res://resources/fruit_database.tres")

@export var database: Resource = DEFAULT_DATABASE

var _available: Array = []
var _all_bodies: Array = []


func acquire(tier: int, at_position: Vector2 = Vector2.ZERO, exclude: Array = []) -> RigidBody2D:
	var body := _take_available(exclude)
	if body == null:
		if _all_bodies.size() >= PHYSICS_CONFIG.max_bodies:
			push_error("FruitPool: max bodies reached (%d)" % PHYSICS_CONFIG.max_bodies)
			return null
		body = FRUIT_BODY_SCENE.instantiate() as RigidBody2D
		_all_bodies.append(body)
		add_child(body)
		body.reset_for_pool()

	if body.get_parent() != self:
		if body.get_parent():
			body.get_parent().remove_child(body)
		add_child(body)

	body.configure_from_tier(tier, database)
	if int(body.get("tier")) != tier:
		release(body)
		return null

	body.activate_at(at_position)
	return body


func release(body: RigidBody2D) -> void:
	if body == null or not is_instance_valid(body):
		return
	if not _all_bodies.has(body):
		push_error("FruitPool: release unknown body")
		return

	body.reset_for_pool()
	if body.get_parent() != self:
		if body.get_parent():
			body.get_parent().remove_child(body)
		add_child(body)
	if not _available.has(body):
		_available.append(body)


func _take_available(exclude: Array) -> RigidBody2D:
	for i in range(_available.size() - 1, -1, -1):
		var candidate: RigidBody2D = _available[i] as RigidBody2D
		if exclude.has(candidate):
			continue
		_available.remove_at(i)
		return candidate
	return null


func get_active_count() -> int:
	return _all_bodies.size() - _available.size()


func get_available_count() -> int:
	return _available.size()


func get_total_count() -> int:
	return _all_bodies.size()
