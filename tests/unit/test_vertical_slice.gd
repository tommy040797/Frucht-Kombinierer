# GdUnit4Suite
extends GdUnitTestSuite

## Playtest coverage for M10 vertical slice: drops + merge → score > 0.

const GAME_SCENE := preload("res://scenes/game/game.tscn")

var _game: Node2D
var _drop: Node
var _merge: Node
var _score: Node
var _pool: Node
var _merge_events: Array = []


func before_test() -> void:
	_merge_events.clear()
	_game = GAME_SCENE.instantiate() as Node2D
	add_child(_game)
	auto_free(_game)
	# Ensure _ready wiring finished before interacting.
	await get_tree().process_frame

	_drop = _game.get_node("DropController")
	_merge = _game.get_node("MergeService")
	_score = _game.get_node("ScoreService")
	_pool = _game.get_node("FruitPool")

	EventBus.subscribe(GameEvents.MERGE_COMPLETED, _on_merge_completed)


func after_test() -> void:
	EventBus.unsubscribe(GameEvents.MERGE_COMPLETED, _on_merge_completed)


func _on_merge_completed(data: Variant) -> void:
	_merge_events.append(data)


func test_game_scene_wires_vertical_slice_nodes() -> void:
	assert_that(_game.get_node_or_null("Container")).is_not_null()
	assert_that(_pool).is_not_null()
	assert_that(_score).is_not_null()
	assert_that(_merge).is_not_null()
	assert_that(_drop).is_not_null()
	assert_that(_game.get_node_or_null("InputHandler")).is_not_null()
	assert_that(_game.get_node_or_null("DropPreview")).is_not_null()
	assert_that(_game.get_node_or_null("DebugOverlay")).is_not_null()


func test_twenty_drops_and_merge_increase_score() -> void:
	# 20 drops across the basket (milestone playtest script).
	var dropped: Array = []
	for i in 20:
		_drop.can_drop = true
		_drop.cooldown_remaining = 0.0
		var x := 120.0 + float(i % 10) * 40.0
		_drop.set_preview_x(x)
		var body: RigidBody2D = _drop.drop() as RigidBody2D
		assert_that(body).is_not_null()
		dropped.append(body)

	assert_that(_pool.get_active_count()).is_equal(20)

	# Force at least one merge (physics collision is non-deterministic headless).
	var a: RigidBody2D = dropped[0] as RigidBody2D
	var b: RigidBody2D = dropped[1] as RigidBody2D
	a.global_position = Vector2(300, 500)
	b.global_position = Vector2(320, 500)

	var result: Dictionary = _merge.try_merge(a, b)
	assert_that(result.get("success")).is_true()
	assert_that(result.get("result_tier")).is_equal(2)

	assert_that(_merge_events.size()).is_greater(0)
	assert_that(_score.current_score).is_greater(0)
	assert_that(_score.current_score).is_equal(10)


func test_merge_starts_drop_cooldown() -> void:
	_drop.set_preview_x(300.0)
	var a: RigidBody2D = _drop.drop() as RigidBody2D
	assert_that(a).is_not_null()

	_drop.can_drop = true
	_drop.cooldown_remaining = 0.0
	_drop.set_preview_x(340.0)
	var b: RigidBody2D = _drop.drop() as RigidBody2D
	assert_that(b).is_not_null()

	_merge.try_merge(a, b)
	assert_that(_drop.can_drop).is_false()
	assert_float(_drop.cooldown_remaining).is_greater(0.0)
