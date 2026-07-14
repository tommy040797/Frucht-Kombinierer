extends Node

const BootStateScript = preload("res://scripts/core/states/boot_state.gd")
const SplashStateScript = preload("res://scripts/core/states/splash_state.gd")
const MainMenuStateScript = preload("res://scripts/core/states/main_menu_state.gd")
const PlayingStateScript = preload("res://scripts/core/states/playing_state.gd")
const PausedStateScript = preload("res://scripts/core/states/paused_state.gd")
const GameOverStateScript = preload("res://scripts/core/states/game_over_state.gd")

var current_state_name: StringName = &""
var physics_active: bool = false

var _current_state: GameState = null
var _states: Dictionary = {}
var _physics_handlers: Array[Callable] = []


func _ready() -> void:
	_register_states()
	if _states.has(GameState.BOOT):
		_enter_state(GameState.BOOT)


func _process(delta: float) -> void:
	if _current_state:
		_current_state.process(delta)


func transition_to(target: StringName) -> bool:
	if not GameStateTransitions.is_transition_allowed(current_state_name, target):
		return false
	if not _states.has(target):
		return false

	var from_name := current_state_name
	if _current_state:
		_current_state.exit()

	_current_state = _states[target]
	current_state_name = target
	_current_state.enter()

	EventBus.emit(GameEvents.GAME_STATE_CHANGED, {"from": from_name, "to": target})
	return true


func set_physics_active(active: bool) -> void:
	physics_active = active
	for handler: Callable in _physics_handlers:
		handler.call(active)


func register_physics_handler(callable: Callable) -> void:
	if _physics_handlers.has(callable):
		return
	_physics_handlers.append(callable)


func _register_states() -> void:
	_states[GameState.BOOT] = BootStateScript.new(self)
	_states[GameState.SPLASH] = SplashStateScript.new(self)
	_states[GameState.MAIN_MENU] = MainMenuStateScript.new(self)
	_states[GameState.PLAYING] = PlayingStateScript.new(self)
	_states[GameState.PAUSED] = PausedStateScript.new(self)
	_states[GameState.GAME_OVER] = GameOverStateScript.new(self)


func _enter_state(state_name: StringName) -> void:
	_current_state = _states[state_name]
	current_state_name = state_name
	_current_state.enter()
