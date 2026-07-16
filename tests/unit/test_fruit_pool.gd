# GdUnit4Suite
extends GdUnitTestSuite

const FRUIT_POOL_SCRIPT := preload("res://scripts/physics/fruit_pool.gd")

var _pool: Node


func before_test() -> void:
	_pool = FRUIT_POOL_SCRIPT.new()
	add_child(_pool)
	auto_free(_pool)


func test_acquire_tier_one_fruit() -> void:
	var body := _pool.acquire(1, Vector2(100, 200)) as RigidBody2D
	assert_that(body).is_not_null()
	assert_that(body.get("tier")).is_equal(1)
	assert_that(body.contact_monitor).is_true()
	assert_that(body.continuous_cd).is_equal(RigidBody2D.CCD_MODE_CAST_SHAPE)
	assert_float(body.global_position.x).is_equal_approx(100.0, 0.01)
	assert_float(body.global_position.y).is_equal_approx(200.0, 0.01)
	_pool.release(body)


func test_pool_acquire_release_stable() -> void:
	for _cycle in 2:
		for _i in 5:
			var body := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
			assert_that(body).is_not_null()
			_pool.release(body)
	assert_that(_pool.get_total_count()).is_equal(1)


func test_release_does_not_free() -> void:
	var body := _pool.acquire(1, Vector2(10, 10)) as RigidBody2D
	_pool.release(body)
	assert_that(is_instance_valid(body)).is_true()


func test_release_removes_from_tree_and_disables_physics() -> void:
	var body := _pool.acquire(1, Vector2(300, 500)) as RigidBody2D
	_pool.release(body)

	assert_that(body.get_parent()).is_same(_pool)
	assert_that(body.freeze).is_true()
	assert_that(body.collision_layer).is_equal(0)
	assert_that(body.collision_mask).is_equal(0)
	assert_that(body.visible).is_false()
	assert_that(body.contact_monitor).is_false()
	assert_float(body.global_position.x).is_less(-1000.0)

	var reused := _pool.acquire(1, Vector2(120, 380)) as RigidBody2D
	assert_that(reused).is_same(body)
	assert_that(reused.get_parent()).is_same(_pool)
	assert_that(reused.freeze).is_false()
	assert_that(reused.collision_layer).is_equal(2)
	assert_float(reused.global_position.x).is_equal_approx(120.0, 0.01)
	assert_float(reused.global_position.y).is_equal_approx(380.0, 0.01)
	_pool.release(reused)
