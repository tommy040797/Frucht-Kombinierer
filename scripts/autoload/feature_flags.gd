extends Node

const _MVP_DEFAULTS := {
	&"dual_preview": false,
	&"pity_spawn": false,
	&"daily_challenge": false,
	&"achievements": false,
	&"share": false,
}


func is_enabled(feature: StringName) -> bool:
	return _MVP_DEFAULTS.get(feature, false)
