class_name GameStateTransitions
extends RefCounted

const TRANSITIONS: Dictionary = {
	GameState.BOOT: [GameState.SPLASH],
	GameState.SPLASH: [GameState.MAIN_MENU],
	GameState.MAIN_MENU: [GameState.PLAYING],
	GameState.PLAYING: [GameState.PAUSED, GameState.GAME_OVER],
	GameState.PAUSED: [GameState.PLAYING, GameState.MAIN_MENU],
	GameState.GAME_OVER: [GameState.PLAYING, GameState.MAIN_MENU],
}


static func is_transition_allowed(from_state: StringName, to_state: StringName) -> bool:
	if not TRANSITIONS.has(from_state):
		return false
	var allowed: Array = TRANSITIONS[from_state]
	return to_state in allowed
