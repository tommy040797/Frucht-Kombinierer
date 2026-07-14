class_name GameState
extends RefCounted

const BOOT := &"boot"
const SPLASH := &"splash"
const MAIN_MENU := &"main_menu"
const PLAYING := &"playing"
const PAUSED := &"paused"
const GAME_OVER := &"game_over"


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> void:
	pass


func get_state_name() -> StringName:
	return &""
