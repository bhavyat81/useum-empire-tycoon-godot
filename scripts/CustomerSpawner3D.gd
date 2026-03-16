extends Node
class_name CustomerSpawner3D

@export var customer_scene: PackedScene
@export var spawn_interval: float = 1.2
@export var max_alive: int = 12

@export var entry_path: NodePath
@export var exit_path: NodePath
@export var container_path: NodePath

var _t: float = 0.0

func _process(delta: float) -> void:
	if customer_scene == null:
		return

	var container := get_node_or_null(container_path) as Node
	var entry := get_node_or_null(entry_path) as Node3D
	var exitp := get_node_or_null(exit_path) as Node3D
	if container == null or entry == null or exitp == null:
		return

	_t -= delta
	if _t > 0.0:
		return
	_t = spawn_interval

	if container.get_child_count() >= max_alive:
		return

	var c := customer_scene.instantiate()
	container.add_child(c)

	if c.has_method("setup"):
		c.setup(entry.global_position, exitp.global_position)
	elif c is Node3D:
		(c as Node3D).global_position = entry.global_position
