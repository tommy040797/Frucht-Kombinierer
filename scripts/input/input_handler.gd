class_name InputHandler
extends Node

## Touch + mouse pointer state for drop aiming.
## `was_released` is edge-triggered: true for one process frame after release.

var pointer_position: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var was_released: bool = false

var _release_pending: bool = false
## -1 = mouse-owned drag; >= 0 = active touch index
var _active_pointer_id: int = -1


func _ready() -> void:
	process_priority = -100


func _process(_delta: float) -> void:
	was_released = _release_pending
	_release_pending = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_screen_touch(event as InputEventScreenTouch)
	elif event is InputEventScreenDrag:
		_handle_screen_drag(event as InputEventScreenDrag)
	elif event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		_handle_mouse_button(event as InputEventMouseButton)
	elif event is InputEventMouseMotion and is_dragging and _active_pointer_id < 0:
		pointer_position = (event as InputEventMouseMotion).position


func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if is_dragging:
			return
		_begin_drag(event.position, event.index)
	elif is_dragging and event.index == _active_pointer_id:
		_end_drag(event.position)


func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	if not is_dragging or event.index != _active_pointer_id:
		return
	pointer_position = event.position


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.pressed:
		# With emulate_touch_from_mouse, ScreenTouch already owns the drag.
		if is_dragging:
			return
		_begin_drag(event.position, -1)
	elif is_dragging and _active_pointer_id < 0:
		_end_drag(event.position)


func _begin_drag(pos: Vector2, pointer_id: int) -> void:
	is_dragging = true
	_active_pointer_id = pointer_id
	pointer_position = pos
	was_released = false
	_release_pending = false


func _end_drag(pos: Vector2) -> void:
	pointer_position = pos
	is_dragging = false
	_active_pointer_id = -1
	_release_pending = true
