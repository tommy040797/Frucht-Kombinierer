class_name SplashState
extends GameState

var _machine: GameStateMachine


func _init(machine: GameStateMachine) -> void:
	_machine = machine


func enter() -> void:
	_machine.set_physics_active(false)


func get_state_name() -> StringName:
	return GameState.SPLASH
