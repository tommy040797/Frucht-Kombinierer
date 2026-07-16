# GdUnit4Suite
extends GdUnitTestSuite

const DROP_PREVIEW_SCRIPT := preload("res://scripts/presentation/drop_preview.gd")
const CONTAINER_ORIGIN_X := 54.0
const INNER_LEFT := 20.0
const INNER_RIGHT := 592.0
const TIER1_RADIUS := 18.0


func test_map_screen_to_drop_x_clamps_to_inner_walls() -> void:
	var container := Node2D.new()
	container.position = Vector2(CONTAINER_ORIGIN_X, 384.0)
	add_child(container)
	auto_free(container)

	var preview = DROP_PREVIEW_SCRIPT.new()
	preview.set("container", container)
	preview.set("ghost_radius", TIER1_RADIUS)
	add_child(preview)
	auto_free(preview)

	var min_x := CONTAINER_ORIGIN_X + INNER_LEFT + TIER1_RADIUS
	var max_x := CONTAINER_ORIGIN_X + INNER_RIGHT - TIER1_RADIUS

	assert_float(preview.map_screen_to_drop_x(0.0)).is_equal_approx(min_x, 0.01)
	assert_float(preview.map_screen_to_drop_x(360.0)).is_equal_approx(360.0, 0.01)
	assert_float(preview.map_screen_to_drop_x(2000.0)).is_equal_approx(max_x, 0.01)


func test_show_and_hide_ghost() -> void:
	var container := Node2D.new()
	container.position = Vector2(CONTAINER_ORIGIN_X, 384.0)
	add_child(container)
	auto_free(container)

	var preview = DROP_PREVIEW_SCRIPT.new()
	preview.set("container", container)
	add_child(preview)
	auto_free(preview)

	await get_tree().process_frame

	var ghost: ColorRect = preview.get_node("Ghost") as ColorRect
	assert_that(ghost).is_not_null()
	assert_that(ghost.visible).is_false()

	var drop_x: float = preview.map_screen_to_drop_x(360.0)
	preview.show_ghost(drop_x)
	assert_that(ghost.visible).is_true()
	assert_float(ghost.global_position.x).is_equal_approx(drop_x - TIER1_RADIUS, 0.5)
	assert_float(ghost.global_position.y).is_equal_approx(384.0 - TIER1_RADIUS, 0.5)

	preview.hide_ghost()
	assert_that(ghost.visible).is_false()
