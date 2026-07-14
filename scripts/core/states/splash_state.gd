class_name SplashState
extends GameState

var _machine: Node


func _init(machine: Node) -> void:
	_machine = machine


func enter() -> void:
	_machine.set_physics_active(false)


func get_state_name() -> StringName:
	return GameState.SPLASH
