extends Control

const _SaveData = preload("res://scripts/persistence/save_data.gd")
const DB = preload("res://resources/fruit_database.tres")
const SPAWN = preload("res://resources/spawn_config.tres")
const SCORE = preload("res://resources/score_config.tres")
const PHYS = preload("res://resources/physics_config.tres")


func _ready() -> void:
	var state := {"received": false}
	var callback := func(data: Variant) -> void:
		state.received = data == "ok"

	EventBus.subscribe(&"smoke_test", callback)
	EventBus.emit(&"smoke_test", "ok")
	assert(state.received, "EventBus smoke test failed")

	assert(not FeatureFlags.is_enabled(&"dual_preview"), "FeatureFlags default wrong")
	assert(SaveService.load().get("version") == _SaveData.SCHEMA_VERSION, "SaveService stub wrong")

	assert(DB.get_by_tier(1).tier == 1, "FruitDatabase preload failed")
	assert(SPAWN.get_weight(1) == 35, "SpawnConfig preload failed")
	assert(SCORE.get_score_for_merge(1) == 10, "ScoreConfig preload failed")
	assert(PHYS.bounce_floor == 0.3, "PhysicsConfig preload failed")

	EventBus.unsubscribe(&"smoke_test", callback)
