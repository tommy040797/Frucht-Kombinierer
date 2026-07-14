extends Node

var _listeners: Dictionary = {}


func subscribe(event_name: StringName, callable: Callable) -> void:
	if not _listeners.has(event_name):
		_listeners[event_name] = []
	var listeners: Array = _listeners[event_name]
	if listeners.has(callable):
		return
	listeners.append(callable)


func unsubscribe(event_name: StringName, callable: Callable) -> void:
	if not _listeners.has(event_name):
		return
	var listeners: Array = _listeners[event_name]
	listeners.erase(callable)
	if listeners.is_empty():
		_listeners.erase(event_name)


func emit(event_name: StringName, data: Variant = null) -> void:
	if not _listeners.has(event_name):
		return
	for callable: Callable in _listeners[event_name]:
		callable.call(data)
