# GdUnit4Suite
extends GdUnitTestSuite

const STATE_MACHINE_SCRIPT = preload("res://scripts/core/game_state_machine.gd")

var _sm: Node
var _last_state_event: Dictionary = {}


func before_test() -> void:
	_sm = STATE_MACHINE_SCRIPT.new()
	add_child(_sm)
	auto_free(_sm)
	_last_state_event = {}


func _on_state_changed(data: Variant) -> void:
	_last_state_event = data


func _navigate_to_playing() -> void:
	assert_that(_sm.transition_to(GameState.SPLASH)).is_true()
	assert_that(_sm.transition_to(GameState.MAIN_MENU)).is_true()
	assert_that(_sm.transition_to(GameState.PLAYING)).is_true()


func test_playing_to_paused_is_allowed() -> void:
	_navigate_to_playing()
	assert_that(_sm.transition_to(GameState.PAUSED)).is_true()
	assert_that(_sm.current_state_name).is_equal(GameState.PAUSED)


func test_boot_to_game_over_is_rejected() -> void:
	assert_that(_sm.current_state_name).is_equal(GameState.BOOT)
	assert_that(_sm.transition_to(GameState.GAME_OVER)).is_false()
	assert_that(_sm.current_state_name).is_equal(GameState.BOOT)


func test_splash_to_playing_is_rejected() -> void:
	assert_that(_sm.transition_to(GameState.SPLASH)).is_true()
	assert_that(_sm.transition_to(GameState.PLAYING)).is_false()
	assert_that(_sm.current_state_name).is_equal(GameState.SPLASH)


func test_physics_toggle_playing_paused() -> void:
	_navigate_to_playing()
	assert_that(_sm.physics_active).is_true()
	assert_that(_sm.transition_to(GameState.PAUSED)).is_true()
	assert_that(_sm.physics_active).is_false()
	assert_that(_sm.transition_to(GameState.PLAYING)).is_true()
	assert_that(_sm.physics_active).is_true()


func test_game_state_changed_event() -> void:
	var holder := {"payload": {}}
	var listener := func(data: Variant) -> void:
		holder.payload = data
	EventBus.subscribe(GameEvents.GAME_STATE_CHANGED, listener)

	assert_that(_sm.transition_to(GameState.SPLASH)).is_true()
	assert_that(_sm.transition_to(GameState.MAIN_MENU)).is_true()
	assert_that(_sm.transition_to(GameState.PLAYING)).is_true()
	assert_that(holder.payload).is_equal({"from": GameState.MAIN_MENU, "to": GameState.PLAYING})

	EventBus.unsubscribe(GameEvents.GAME_STATE_CHANGED, listener)
