class_name DropPreview
extends Node2D

## Ghost silhouette along the container top edge; clamps X to inner walls.

const INNER_LEFT := 20.0
const INNER_RIGHT := 592.0
const TIER1_RADIUS := 18.0

@export var container: Node2D
@export var ghost_radius: float = TIER1_RADIUS

var _ghost: ColorRect


func _ready() -> void:
	_ghost = ColorRect.new()
	_ghost.name = "Ghost"
	_ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ghost.color = Color(0.9, 0.2, 0.2, 0.45)
	_apply_ghost_size(ghost_radius)
	add_child(_ghost)
	hide_ghost()


func map_screen_to_drop_x(screen_x: float) -> float:
	var origin_x := 0.0
	if container != null and is_instance_valid(container):
		origin_x = container.global_position.x
	var min_x := origin_x + INNER_LEFT + ghost_radius
	var max_x := origin_x + INNER_RIGHT - ghost_radius
	return clampf(screen_x, min_x, max_x)


func show_ghost(world_x: float) -> void:
	if _ghost == null:
		return
	var drop_y := 0.0
	if container != null and is_instance_valid(container):
		drop_y = container.global_position.y
	_ghost.global_position = Vector2(world_x - ghost_radius, drop_y - ghost_radius)
	_ghost.visible = true


func hide_ghost() -> void:
	if _ghost == null:
		return
	_ghost.visible = false


func _apply_ghost_size(radius: float) -> void:
	var size := radius * 2.0
	_ghost.offset_left = 0.0
	_ghost.offset_top = 0.0
	_ghost.offset_right = size
	_ghost.offset_bottom = size
