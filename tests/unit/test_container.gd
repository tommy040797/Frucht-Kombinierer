# GdUnit4Suite
extends GdUnitTestSuite

const CONTAINER_SCENE := preload("res://scenes/game/container.tscn")
const CONTAINER_HEIGHT := 896.0
const DANGER_LINE_RATIO := 0.85


func test_container_scene_loads() -> void:
	var container: Node2D = CONTAINER_SCENE.instantiate()
	add_child(container)

	var bounds: ContainerBounds = container.get_node("ContainerBounds") as ContainerBounds
	assert_that(bounds).is_not_null()
	assert_that(bounds.get_node("FloorBody/Floor")).is_not_null()
	assert_that(bounds.get_node("WallBody/LeftWall")).is_not_null()
	assert_that(bounds.get_node("WallBody/RightWall")).is_not_null()

	container.queue_free()


func test_danger_line_at_eighty_five_percent_height() -> void:
	var container: Node2D = CONTAINER_SCENE.instantiate()
	add_child(container)

	var danger_line: DangerLine = container.get_node("DangerLine") as DangerLine
	var expected_y := CONTAINER_HEIGHT * DANGER_LINE_RATIO

	assert_that(danger_line).is_not_null()
	assert_float(danger_line.position.y).is_equal_approx(expected_y, 1.0)
	assert_float(danger_line.danger_y).is_equal_approx(expected_y, 1.0)

	container.queue_free()
