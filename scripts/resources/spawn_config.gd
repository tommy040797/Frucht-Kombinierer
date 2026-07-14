class_name SpawnConfig
extends Resource

@export var tier_1_weight: int = 35
@export var tier_2_weight: int = 28
@export var tier_3_weight: int = 20
@export var tier_4_weight: int = 12
@export var tier_5_weight: int = 5


func get_weight(tier: int) -> int:
	match tier:
		1:
			return tier_1_weight
		2:
			return tier_2_weight
		3:
			return tier_3_weight
		4:
			return tier_4_weight
		5:
			return tier_5_weight
		_:
			return 0


func get_total_weight() -> int:
	return tier_1_weight + tier_2_weight + tier_3_weight + tier_4_weight + tier_5_weight
