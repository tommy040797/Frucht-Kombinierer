extends Control

const _SaveData = preload("res://scripts/persistence/save_data.gd")


func _ready() -> void:
	var state := {"received": false}
	var callback := func(data: Variant) -> void:
		state.received = data == "ok"

	EventBus.subscribe(&"smoke_test", callback)
	EventBus.emit(&"smoke_test", "ok")
	assert(state.received, "EventBus smoke test failed")

	assert(not FeatureFlags.is_enabled(&"dual_preview"), "FeatureFlags default wrong")
	assert(SaveService.load().get("version") == _SaveData.SCHEMA_VERSION, "SaveService stub wrong")

	EventBus.unsubscribe(&"smoke_test", callback)
