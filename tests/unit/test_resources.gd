# GdUnit4Suite
extends GdUnitTestSuite

const DB = preload("res://resources/fruit_database.tres")
const SPAWN = preload("res://resources/spawn_config.tres")
const SCORE = preload("res://resources/score_config.tres")
const PHYS = preload("res://resources/physics_config.tres")


func test_fruit_database_preloads_tier_1() -> void:
	assert_that(DB.get_by_tier(1).tier).is_equal(1)


func test_fruit_database_covers_all_eleven_tiers() -> void:
	assert_that(DB.get_max_tier()).is_equal(11)
	for tier in range(1, 12):
		var definition = DB.get_by_tier(tier)
		assert_that(definition).is_not_null()
		assert_that(definition.tier).is_equal(tier)


func test_spawn_config_weights() -> void:
	assert_that(SPAWN.get_weight(1)).is_equal(35)
	assert_that(SPAWN.get_total_weight()).is_equal(100)


func test_score_config_merge_points() -> void:
	assert_that(SCORE.get_score_for_merge(1)).is_equal(10)
	assert_that(SCORE.get_score_for_merge(10)).is_equal(7500)


func test_physics_config_defaults() -> void:
	assert_that(PHYS.bounce_floor).is_equal(0.3)
	assert_that(PHYS.gravity).is_equal(980.0)
