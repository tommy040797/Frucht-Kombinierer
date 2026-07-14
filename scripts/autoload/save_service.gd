extends Node

const _SaveData = preload("res://scripts/persistence/save_data.gd")

var _data: Dictionary = {}


func _ready() -> void:
	_data = _SaveData.create_default()


func load() -> Dictionary:
	return _data.duplicate(true)


func save(data: Dictionary) -> void:
	_data = data.duplicate(true)


func get_settings() -> Dictionary:
	return _data.get("settings", {}).duplicate(true)
