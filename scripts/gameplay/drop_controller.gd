class_name DropController
extends Node

## Spawns the current drop fruit from FruitPool at the preview X.

const DROP_TIER := 1

@export var fruit_pool: Node
@export var container: Node2D
@export var input_handler: Node
@export var drop_preview: Node2D

var can_drop: bool = true
var preview_x: float = 0.0
var cooldown_remaining: float = 0.0


func _process(delta: float) -> void:
	_update_cooldown(delta)
	_sync_from_input()


func set_preview_x(x: float) -> void:
	preview_x = x


func drop() -> RigidBody2D:
	if not can_drop:
		return null
	if fruit_pool == null or not is_instance_valid(fruit_pool):
		push_error("DropController: fruit_pool missing")
		return null

	var body: RigidBody2D = fruit_pool.acquire(DROP_TIER) as RigidBody2D
	if body == null:
		return null

	var drop_y := 0.0
	if container != null and is_instance_valid(container):
		drop_y = container.global_position.y
	body.global_position = Vector2(preview_x, drop_y)

	EventBus.emit(GameEvents.FRUIT_DROPPED, {
		"tier": DROP_TIER,
		"position": body.global_position,
	})
	return body


func start_cooldown(duration: float) -> void:
	cooldown_remaining = maxf(0.0, duration)
	if cooldown_remaining > 0.0:
		can_drop = false


func _sync_from_input() -> void:
	if input_handler == null or not is_instance_valid(input_handler):
		return

	if input_handler.get("is_dragging") and drop_preview != null:
		var mapped_x: float = drop_preview.map_screen_to_drop_x(input_handler.pointer_position.x)
		drop_preview.show_ghost(mapped_x)
		set_preview_x(mapped_x)
	elif drop_preview != null:
		drop_preview.hide_ghost()

	if input_handler.get("was_released"):
		drop()


func _update_cooldown(delta: float) -> void:
	if cooldown_remaining <= 0.0:
		return
	cooldown_remaining = maxf(0.0, cooldown_remaining - delta)
	if cooldown_remaining <= 0.0:
		can_drop = true
