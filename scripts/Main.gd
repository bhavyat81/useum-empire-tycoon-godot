extends Node2D

@export var customer_scene: PackedScene
@export var spawn_interval_sec: float = 1.2
@export var max_visitors_alive: int = 12

@onready var spawn_point: Marker2D = $World/SpawnPoint
@onready var exit_point: Marker2D = $World/ExitPoint
@onready var entities: Node2D = $World/Entities
@onready var spawn_timer: Timer = $World/SpawnTimer

func _ready() -> void:
	randomize()

	if customer_scene == null:
		push_error("Main.gd: customer_scene not set in Inspector")
		return

	spawn_timer.wait_time = spawn_interval_sec
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	_spawn_customer()

func _on_spawn_timer_timeout() -> void:
	_spawn_customer()

func _get_exhibits() -> Array[Node2D]:
	var room := get_node_or_null("World/Room")
	if room == null:
		return []
	var arr: Array[Node2D] = []
	for c in room.get_children():
		if c is Area2D and c.has_method("try_buy"):
			arr.append(c)
	return arr

func _spawn_customer() -> void:
	if entities.get_child_count() >= max_visitors_alive:
		return

	var exhibits := _get_exhibits()
	if exhibits.is_empty():
		return

	var c := customer_scene.instantiate()
	entities.add_child(c)
	c.global_position = spawn_point.global_position

	if c.has_method("setup"):
		c.setup(exhibits, exit_point)
	else:
		push_error("Spawned scene has no setup(exhibits, exit_target) method.")
