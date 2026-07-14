class_name ScoreConfig
extends Resource

# PRD §8.1 — points for merge source_tier → source_tier + 1 (tiers 1–10)
@export var merge_scores: Array[int] = [10, 25, 50, 100, 200, 400, 800, 1600, 3200, 7500]


func get_score_for_merge(source_tier: int) -> int:
	var index := source_tier - 1
	if index < 0 or index >= merge_scores.size():
		return 0
	return merge_scores[index]
