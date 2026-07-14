class_name PlayingState
extends GameState

var _machine: GameStateMachine


func _init(machine: GameStateMachine) -> void:
	_machine = machine


func enter() -> void:
	_machine.set_physics_active(true)


func get_state_name() -> StringName:
	return GameState.PLAYING
