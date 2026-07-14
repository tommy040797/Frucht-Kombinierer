class_name FruitDatabase
extends Resource

@export var definitions: Array = []


func get_by_tier(tier: int):
	for definition in definitions:
		if definition.tier == tier:
			return definition
	return null


func get_max_tier() -> int:
	var max_tier := 0
	for definition in definitions:
		max_tier = max(max_tier, definition.tier)
	return max_tier
