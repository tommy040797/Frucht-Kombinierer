# GdUnit4Suite
extends GdUnitTestSuite

const DROP_CONTROLLER_SCRIPT := preload("res://scripts/gameplay/drop_controller.gd")
const FRUIT_POOL_SCRIPT := preload("res://scripts/physics/fruit_pool.gd")

var _pool: Node
var _controller: Node
var _container: Node2D
var _received: Array = []


func before_test() -> void:
	_received.clear()
	_container = Node2D.new()
	_container.position = Vector2(54.0, 384.0)
	add_child(_container)
	auto_free(_container)

	_pool = FRUIT_POOL_SCRIPT.new()
	add_child(_pool)
	auto_free(_pool)

	_controller = DROP_CONTROLLER_SCRIPT.new()
	_controller.set("fruit_pool", _pool)
	_controller.set("container", _container)
	add_child(_controller)
	auto_free(_controller)

	EventBus.subscribe(GameEvents.FRUIT_DROPPED, _on_fruit_dropped)


func after_test() -> void:
	EventBus.unsubscribe(GameEvents.FRUIT_DROPPED, _on_fruit_dropped)


func _on_fruit_dropped(data: Variant) -> void:
	_received.append(data)


func test_drop_acquires_tier_one_and_emits() -> void:
	_controller.set_preview_x(360.0)
	var body: RigidBody2D = _controller.drop() as RigidBody2D

	assert_that(body).is_not_null()
	assert_that(body.get("tier")).is_equal(1)
	assert_float(body.global_position.x).is_equal_approx(360.0, 0.01)
	assert_float(body.global_position.y).is_equal_approx(384.0, 0.01)
	assert_that(_pool.get_active_count()).is_equal(1)

	assert_that(_received.size()).is_equal(1)
	var payload: Dictionary = _received[0] as Dictionary
	assert_that(payload["tier"]).is_equal(1)
	assert_that(payload["position"]).is_equal(body.global_position)


func test_can_drop_false_skips_spawn() -> void:
	_controller.set("can_drop", false)
	_controller.set_preview_x(200.0)
	var body: RigidBody2D = _controller.drop() as RigidBody2D

	assert_that(body).is_null()
	assert_that(_pool.get_active_count()).is_equal(0)
	assert_that(_received.size()).is_equal(0)


func test_start_cooldown_blocks_then_recovers() -> void:
	_controller.start_cooldown(0.05)
	assert_that(_controller.get("can_drop")).is_false()
	assert_float(_controller.get("cooldown_remaining")).is_greater(0.0)

	var blocked: RigidBody2D = _controller.drop() as RigidBody2D
	assert_that(blocked).is_null()

	await await_millis(80)
	assert_that(_controller.get("can_drop")).is_true()
	assert_float(_controller.get("cooldown_remaining")).is_equal_approx(0.0, 0.001)

	_controller.set_preview_x(300.0)
	var body: RigidBody2D = _controller.drop() as RigidBody2D
	assert_that(body).is_not_null()
