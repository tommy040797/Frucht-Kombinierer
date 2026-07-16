# GdUnit4Suite
extends GdUnitTestSuite

const SCORE_SERVICE_SCRIPT := preload("res://scripts/gameplay/score_service.gd")
const SCORE_CONFIG := preload("res://resources/score_config.tres")

var _score: Node


func before_test() -> void:
	_score = SCORE_SERVICE_SCRIPT.new()
	_score.score_config = SCORE_CONFIG
	add_child(_score)
	auto_free(_score)


func test_add_merge_score_tier_one() -> void:
	var awarded: int = _score.add_merge_score(1, Vector2.ZERO)
	assert_that(awarded).is_equal(10)
	assert_that(_score.current_score).is_equal(10)


func test_add_merge_score_tier_four() -> void:
	var awarded: int = _score.add_merge_score(4, Vector2.ZERO)
	assert_that(awarded).is_equal(100)
	assert_that(_score.current_score).is_equal(100)


func test_add_merge_score_all_source_tiers() -> void:
	var expected := [10, 25, 50, 100, 200, 400, 800, 1600, 3200, 7500]
	var total := 0
	for tier in range(1, 11):
		var awarded: int = _score.add_merge_score(tier, Vector2.ZERO)
		assert_that(awarded).is_equal(expected[tier - 1])
		total += awarded
	assert_that(_score.current_score).is_equal(total)


func test_reset_clears_score() -> void:
	_score.add_merge_score(1, Vector2.ZERO)
	_score.reset()
	assert_that(_score.current_score).is_equal(0)
	assert_that(_score.combo_multiplier).is_equal(1.0)


func test_invalid_tier_awards_zero() -> void:
	assert_that(_score.add_merge_score(0, Vector2.ZERO)).is_equal(0)
	assert_that(_score.add_merge_score(11, Vector2.ZERO)).is_equal(0)
	assert_that(_score.current_score).is_equal(0)
