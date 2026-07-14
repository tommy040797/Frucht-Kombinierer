class_name GameEvents
extends RefCounted

# Gameplay
const FRUIT_DROPPED := &"fruit_dropped"
const MERGE_STARTED := &"merge_started"
const MERGE_COMPLETED := &"merge_completed"
const COMBO_INCREASED := &"combo_increased"
const COMBO_BROKEN := &"combo_broken"
const DANGER_ENTERED := &"danger_entered"
const DANGER_EXITED := &"danger_exited"
const DANGER_ESCALATED := &"danger_escalated"
const GAME_OVER_TRIGGERED := &"game_over_triggered"
const NEW_HIGH_SCORE := &"new_high_score"
const FRUIT_DISCOVERED := &"fruit_discovered"

# System
const GAME_STATE_CHANGED := &"game_state_changed"
const SETTINGS_CHANGED := &"settings_changed"
const RUN_STARTED := &"run_started"
const RUN_ENDED := &"run_ended"
