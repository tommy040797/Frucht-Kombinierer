class_name DebugOverlay
extends CanvasLayer

## Minimal score HUD for the M10 vertical slice (not the real Game HUD).

@export var score_service: Node

@onready var _score_label: Label = $ScoreLabel


func _ready() -> void:
	EventBus.subscribe(GameEvents.MERGE_COMPLETED, _on_merge_completed)
	EventBus.subscribe(GameEvents.FRUIT_DROPPED, _on_fruit_dropped)
	_refresh_score()


func _exit_tree() -> void:
	EventBus.unsubscribe(GameEvents.MERGE_COMPLETED, _on_merge_completed)
	EventBus.unsubscribe(GameEvents.FRUIT_DROPPED, _on_fruit_dropped)


func _on_merge_completed(data: Variant) -> void:
	var awarded := 0
	if data is Dictionary:
		awarded = int(data.get("score", 0))
	_refresh_score("Merge +%d" % awarded)


func _on_fruit_dropped(_data: Variant) -> void:
	_refresh_score()


func _refresh_score(status: String = "") -> void:
	if _score_label == null:
		return
	var score := 0
	if score_service != null and is_instance_valid(score_service):
		score = int(score_service.get("current_score"))
	if status.is_empty():
		_score_label.text = "Score: %d" % score
	else:
		_score_label.text = "Score: %d  |  %s" % [score, status]
