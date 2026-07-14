extends Node2D

@onready var _pool: Node = $FruitPool

const SPAWN_POSITION := Vector2(360, 420)


func _ready() -> void:
	_spawn_tier_one()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_spawn_tier_one()


func _spawn_tier_one() -> void:
	var body := _pool.acquire(1) as RigidBody2D
	if body == null:
		return
	body.global_position = SPAWN_POSITION
