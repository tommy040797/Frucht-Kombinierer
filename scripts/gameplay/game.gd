class_name GameRoot
extends Node2D

## Vertical-slice game scene: Drop → Physics → Merge 1→2 → Score.


func _ready() -> void:
	_wire_services()


func _wire_services() -> void:
	var pool := $FruitPool
	var score := $ScoreService
	var container := $Container
	var input_handler := $InputHandler
	var preview := $DropPreview
	var merge := $MergeService
	var drop := $DropController
	var overlay := $DebugOverlay

	merge.fruit_pool = pool
	merge.score_service = score

	drop.fruit_pool = pool
	drop.container = container
	drop.input_handler = input_handler
	drop.drop_preview = preview

	preview.container = container
	overlay.score_service = score


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_request_reset()


func _request_reset() -> void:
	get_tree().reload_current_scene()
