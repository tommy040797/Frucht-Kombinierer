class_name MergeService
extends Node

const MAX_MERGES_PER_TICK := 10
const RESULT_UPWARD_IMPULSE := Vector2(0, -80)
const MAX_RESULT_TIER := 11

@export var fruit_pool: Node
@export var score_service: Node

var _merge_queue: Array = []
var _processing_queue: bool = false
var _last_result: Dictionary = {}


func _ready() -> void:
	add_to_group("merge_service")


func can_merge(a: RigidBody2D, b: RigidBody2D) -> bool:
	if a == null or b == null:
		return false
	if not is_instance_valid(a) or not is_instance_valid(b):
		return false
	if a == b:
		return false

	var tier_a: int = int(a.get("tier"))
	var tier_b: int = int(b.get("tier"))
	if tier_a <= 0 or tier_b <= 0:
		return false
	if tier_a != tier_b:
		return false
	if bool(a.get("is_merging")) or bool(b.get("is_merging")):
		return false
	if tier_a + 1 > MAX_RESULT_TIER:
		return false
	return true


func try_merge(a: RigidBody2D, b: RigidBody2D) -> Dictionary:
	_last_result = {"success": false, "result": null, "result_tier": 0}

	if not can_merge(a, b):
		return _last_result

	# Immediate lock before queue to block symmetric body_entered.
	a.set("is_merging", true)
	b.set("is_merging", true)

	_merge_queue.append({"a": a, "b": b})
	process_chain_merges()
	return _last_result


func process_chain_merges() -> void:
	if _processing_queue:
		return
	_processing_queue = true

	var processed := 0
	while not _merge_queue.is_empty() and processed < MAX_MERGES_PER_TICK:
		var pair: Dictionary = _merge_queue.pop_front()
		_execute_merge(pair.get("a") as RigidBody2D, pair.get("b") as RigidBody2D)
		processed += 1

	_merge_queue.clear()
	_processing_queue = false


func _execute_merge(a: RigidBody2D, b: RigidBody2D) -> void:
	if a == null or b == null or not is_instance_valid(a) or not is_instance_valid(b):
		_last_result = {"success": false, "result": null, "result_tier": 0}
		return

	var pool := _resolve_pool()
	if pool == null:
		push_error("MergeService: FruitPool missing")
		a.set("is_merging", false)
		b.set("is_merging", false)
		_last_result = {"success": false, "result": null, "result_tier": 0}
		return

	var source_tier: int = int(a.get("tier"))
	var result_tier: int = source_tier + 1
	var contact_point: Vector2 = (a.global_position + b.global_position) * 0.5

	EventBus.emit(GameEvents.MERGE_STARTED, {
		"tier_a": source_tier,
		"tier_b": source_tier,
		"contact_point": contact_point,
	})

	pool.release(a)
	pool.release(b)

	var result: RigidBody2D = pool.acquire(result_tier, contact_point) as RigidBody2D
	if result == null or int(result.get("tier")) != result_tier:
		push_error("MergeService: failed to acquire result tier %d" % result_tier)
		if result != null:
			pool.release(result)
		_last_result = {"success": false, "result": null, "result_tier": 0}
		return

	result.apply_central_impulse(RESULT_UPWARD_IMPULSE)

	var awarded := 0
	var combo := 1.0
	var scorer := _resolve_score_service()
	if scorer != null and scorer.has_method("add_merge_score"):
		awarded = int(scorer.add_merge_score(source_tier, contact_point))
		combo = float(scorer.get("combo_multiplier"))
	else:
		push_warning("MergeService: ScoreService missing — merge score stubbed to 0")

	EventBus.emit(GameEvents.MERGE_COMPLETED, {
		"result_tier": result_tier,
		"position": contact_point,
		"score": awarded,
		"combo_multiplier": combo,
	})

	_last_result = {
		"success": true,
		"result": result,
		"result_tier": result_tier,
		"contact_point": contact_point,
		"score": awarded,
	}


func _resolve_pool() -> Node:
	if fruit_pool != null and is_instance_valid(fruit_pool):
		return fruit_pool
	var parent_pool := get_parent()
	if parent_pool != null and parent_pool.has_method("acquire") and parent_pool.has_method("release"):
		return parent_pool
	return null


func _resolve_score_service() -> Node:
	if score_service != null and is_instance_valid(score_service):
		return score_service
	var tree := get_tree()
	if tree == null:
		return null
	return tree.get_first_node_in_group("score_service")
