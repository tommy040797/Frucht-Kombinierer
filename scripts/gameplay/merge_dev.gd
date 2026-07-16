extends Node2D

## Dev scene: spawn two tier-1 fruits so they can collide and merge.

@onready var _pool: Node = $FruitPool
@onready var _merge_service: Node = $MergeService

const SPAWN_A := Vector2(300, 420)
const SPAWN_B := Vector2(420, 420)


func _ready() -> void:
	_merge_service.fruit_pool = _pool
	_spawn_pair()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_spawn_pair()


func _spawn_pair() -> void:
	var a := _pool.acquire(1, SPAWN_A) as RigidBody2D
	var b := _pool.acquire(1, SPAWN_B) as RigidBody2D
	if a == null or b == null:
		return
