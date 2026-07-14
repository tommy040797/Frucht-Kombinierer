class_name SaveData
extends RefCounted

const SCHEMA_VERSION := 1


static func create_default() -> Dictionary:
	return {
		"version": SCHEMA_VERSION,
		"high_score": 0,
		"catalog": {
			"discovered_tiers": [],
			"counts": {},
		},
		"lifetime_stats": {
			"total_runs": 0,
			"total_merges": 0,
			"golden_fruits": 0,
		},
		"settings": {
			"master_volume": 1.0,
			"sfx_volume": 1.0,
			"music_volume": 0.8,
			"haptics_enabled": true,
			"large_touch_zones": false,
			"reduced_shake": false,
			"color_blind_mode": false,
		},
		"last_played_at": "",
	}
