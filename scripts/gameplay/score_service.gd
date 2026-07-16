class_name ScoreService
extends Node

const DEFAULT_SCORE_CONFIG := preload("res://resources/score_config.tres")

@export var score_config: Resource = DEFAULT_SCORE_CONFIG

var current_score: int = 0
var combo_multiplier: float = 1.0


func _ready() -> void:
	add_to_group("score_service")


func add_merge_score(source_tier: int, _position: Vector2) -> int:
	if score_config == null or not score_config.has_method("get_score_for_merge"):
		push_error("ScoreService: score_config missing or invalid")
		return 0

	var base_points: int = int(score_config.get_score_for_merge(source_tier))
	var awarded: int = int(round(float(base_points) * combo_multiplier))
	current_score += awarded
	return awarded


func reset() -> void:
	current_score = 0
	combo_multiplier = 1.0
