# GdUnit4Suite
extends GdUnitTestSuite

const FRUIT_POOL_SCRIPT := preload("res://scripts/physics/fruit_pool.gd")

var _pool: Node


func before_test() -> void:
	_pool = FRUIT_POOL_SCRIPT.new()
	add_child(_pool)
	auto_free(_pool)


func test_acquire_tier_one_fruit() -> void:
	var body := _pool.acquire(1) as RigidBody2D
	assert_that(body).is_not_null()
	assert_that(body.get("tier")).is_equal(1)
	assert_that(body.contact_monitor).is_true()
	assert_that(body.continuous_cd).is_equal(RigidBody2D.CCD_MODE_CAST_SHAPE)
	_pool.release(body)


func test_pool_acquire_release_stable() -> void:
	for _cycle in 2:
		for _i in 5:
			var body := _pool.acquire(1) as RigidBody2D
			assert_that(body).is_not_null()
			_pool.release(body)
	assert_that(_pool.get_total_count()).is_equal(1)


func test_release_does_not_free() -> void:
	var body := _pool.acquire(1) as RigidBody2D
	_pool.release(body)
	assert_that(is_instance_valid(body)).is_true()


func test_release_disables_physics_and_parks() -> void:
	var body := _pool.acquire(1) as RigidBody2D
	body.global_position = Vector2(300, 500)
	_pool.release(body)

	assert_that(body.freeze).is_true()
	assert_that(body.collision_layer).is_equal(0)
	assert_that(body.collision_mask).is_equal(0)
	assert_that(body.visible).is_false()
	assert_that(body.get_node("CollisionShape2D").disabled).is_true()
	assert_float(body.global_position.x).is_less(-1000.0)

	var reused := _pool.acquire(1) as RigidBody2D
	assert_that(reused).is_same(body)
	assert_that(reused.freeze).is_false()
	assert_that(reused.collision_layer).is_equal(2)
	assert_that(reused.get_node("CollisionShape2D").disabled).is_false()
	_pool.release(reused)
