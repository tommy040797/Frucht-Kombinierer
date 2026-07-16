class_name GameRoot
extends Node2D

## Vertical-slice game scene: Drop → Physics → Merge 1→2 → Score.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_clear") or (event is InputEventKey and event.pressed and event.keycode == KEY_R):
		_request_reset()


func _request_reset() -> void:
	# Soft reset: reload this scene for quick playtests.
	get_tree().reload_current_scene()
