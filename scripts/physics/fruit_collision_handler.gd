class_name FruitCollisionHandler
extends Node

## Forwards RigidBody2D body_entered contacts to MergeService.
## Resolves MergeService via @export or group "merge_service".

@export var merge_service: Node

var _body: RigidBody2D


func _ready() -> void:
	_body = get_parent() as RigidBody2D
	if _body == null:
		push_error("FruitCollisionHandler: parent must be RigidBody2D")
		return
	if not _body.body_entered.is_connected(_on_body_entered):
		_body.body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node) -> void:
	if _body == null or not is_instance_valid(_body):
		return
	if other == null or not is_instance_valid(other):
		return
	if not (other is RigidBody2D):
		return
	# Only FruitBody-like nodes expose tier; walls are StaticBody2D.
	if other.get("tier") == null:
		return

	var service := _resolve_merge_service()
	if service == null or not service.has_method("try_merge"):
		return

	# Pair key by instance_id order so A→B and B→A share one identity.
	# Defer out of the physics flush so release/freeze is safe.
	var id_a := _body.get_instance_id()
	var id_b := other.get_instance_id()
	if id_a > id_b:
		service.call_deferred("try_merge", other as RigidBody2D, _body)
	else:
		service.call_deferred("try_merge", _body, other as RigidBody2D)


func _resolve_merge_service() -> Node:
	if merge_service != null and is_instance_valid(merge_service):
		return merge_service
	if not is_inside_tree():
		return null
	var nodes := get_tree().get_nodes_in_group("merge_service")
	if nodes.is_empty():
		return null
	return nodes[0] as Node
