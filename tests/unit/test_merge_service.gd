# GdUnit4Suite
extends GdUnitTestSuite

const FRUIT_POOL_SCRIPT := preload("res://scripts/physics/fruit_pool.gd")
const MERGE_SERVICE_SCRIPT := preload("res://scripts/gameplay/merge_service.gd")
const SCORE_SERVICE_SCRIPT := preload("res://scripts/gameplay/score_service.gd")
const SCORE_CONFIG := preload("res://resources/score_config.tres")

var _pool: Node
var _merge: Node
var _score: Node


func before_test() -> void:
	_pool = FRUIT_POOL_SCRIPT.new()
	add_child(_pool)
	auto_free(_pool)

	_score = SCORE_SERVICE_SCRIPT.new()
	_score.score_config = SCORE_CONFIG
	add_child(_score)
	auto_free(_score)

	_merge = MERGE_SERVICE_SCRIPT.new()
	_merge.fruit_pool = _pool
	_merge.score_service = _score
	add_child(_merge)
	auto_free(_merge)


func test_can_merge_same_tier() -> void:
	var a := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
	var b := _pool.acquire(1, Vector2(20, 10)) as RigidBody2D
	assert_that(_merge.can_merge(a, b)).is_true()
	_pool.release(a)
	_pool.release(b)


func test_can_merge_different_tier_false() -> void:
	var a := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
	var b := _pool.acquire(2, Vector2(20, 10)) as RigidBody2D
	assert_that(_merge.can_merge(a, b)).is_false()
	_pool.release(a)
	_pool.release(b)


func test_try_merge_produces_tier_two() -> void:
	var a := _pool.acquire(1, Vector2(100, 100)) as RigidBody2D
	var b := _pool.acquire(1, Vector2(120, 100)) as RigidBody2D

	var active_before: int = _pool.get_active_count()
	var result: Dictionary = _merge.try_merge(a, b)

	assert_that(result.get("success")).is_true()
	assert_that(result.get("result_tier")).is_equal(2)
	var body: RigidBody2D = result.get("result") as RigidBody2D
	assert_that(body).is_not_null()
	assert_that(body.get("tier")).is_equal(2)
	assert_that(_pool.get_active_count()).is_equal(active_before - 1)
	assert_that(body).is_not_same(a)
	assert_that(body).is_not_same(b)
	assert_that(a.visible).is_false()
	assert_that(b.visible).is_false()

	_pool.release(body)


func test_try_merge_tier_two_produces_grape() -> void:
	var a := _pool.acquire(2, Vector2(100, 100)) as RigidBody2D
	var b := _pool.acquire(2, Vector2(140, 100)) as RigidBody2D

	var result: Dictionary = _merge.try_merge(a, b)
	assert_that(result.get("success")).is_true()
	assert_that(result.get("result_tier")).is_equal(3)
	var body: RigidBody2D = result.get("result") as RigidBody2D
	assert_that(body).is_not_null()
	assert_that(body.get("tier")).is_equal(3)
	assert_that(_score.current_score).is_equal(25)

	_pool.release(body)


func test_lock_blocks_second_merge() -> void:
	var a := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
	var b := _pool.acquire(1, Vector2(20, 10)) as RigidBody2D
	var c := _pool.acquire(1, Vector2(30, 10)) as RigidBody2D
	a.set("is_merging", true)

	assert_that(_merge.can_merge(a, b)).is_false()
	var result: Dictionary = _merge.try_merge(a, c)
	assert_that(result.get("success")).is_false()

	_pool.release(a)
	_pool.release(b)
	_pool.release(c)


func test_merge_events_payload() -> void:
	var started := {"data": null}
	var completed := {"data": null}
	var on_started := func(data: Variant) -> void:
		started.data = data
	var on_completed := func(data: Variant) -> void:
		completed.data = data

	EventBus.subscribe(GameEvents.MERGE_STARTED, on_started)
	EventBus.subscribe(GameEvents.MERGE_COMPLETED, on_completed)

	var a := _pool.acquire(1, Vector2(200, 200)) as RigidBody2D
	var b := _pool.acquire(1, Vector2(220, 200)) as RigidBody2D
	var result: Dictionary = _merge.try_merge(a, b)

	assert_that(result.get("success")).is_true()
	assert_that(started.data).is_not_null()
	assert_that(started.data.get("tier_a")).is_equal(1)
	assert_that(started.data.get("tier_b")).is_equal(1)
	assert_that(started.data.get("contact_point")).is_equal(Vector2(210, 200))

	assert_that(completed.data).is_not_null()
	assert_that(completed.data.get("result_tier")).is_equal(2)
	assert_that(completed.data.get("position")).is_equal(Vector2(210, 200))
	assert_that(completed.data.get("score")).is_equal(10)
	assert_that(completed.data.get("combo_multiplier")).is_equal(1.0)
	assert_that(_score.current_score).is_equal(10)

	EventBus.unsubscribe(GameEvents.MERGE_STARTED, on_started)
	EventBus.unsubscribe(GameEvents.MERGE_COMPLETED, on_completed)

	var body: RigidBody2D = result.get("result") as RigidBody2D
	if body != null:
		_pool.release(body)


func test_pool_balance_after_merge() -> void:
	var a := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
	var b := _pool.acquire(1, Vector2(20, 10)) as RigidBody2D
	assert_that(_pool.get_active_count()).is_equal(2)

	var result: Dictionary = _merge.try_merge(a, b)
	assert_that(result.get("success")).is_true()
	var body: RigidBody2D = result.get("result") as RigidBody2D
	# Partners stay pooled; result is a fresh body (not a or b).
	assert_that(body).is_not_same(a)
	assert_that(body).is_not_same(b)
	assert_that(a.visible).is_false()
	assert_that(b.visible).is_false()
	assert_that(a.freeze).is_true()
	assert_that(b.freeze).is_true()
	assert_that(_pool.get_active_count()).is_equal(1)
	assert_that(_pool.get_available_count()).is_equal(2)
	assert_that(_pool.get_total_count()).is_equal(3)

	_pool.release(body)
	assert_that(_pool.get_active_count()).is_equal(0)
	assert_that(_pool.get_available_count()).is_equal(3)
