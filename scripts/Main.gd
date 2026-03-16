extends Node2D

@export var customer_scene: PackedScene

@export var spawn_interval_sec: float = 1.6
@export var max_visitors_alive: int = 10

@onready var shelf: Area2D = $World/shelf
@onready var spawn_point: Marker2D = $World/SpawnPoint
@onready var entities: Node2D = $World/Entities
@onready var spawn_timer: Timer = $World/SpawnTimer

func _ready() -> void:
	if customer_scene == null:
		push_error("Main.gd: customer_scene not set in Inspector")
		return

	spawn_timer.wait_time = spawn_interval_sec
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	# Spawn one immediately so the scene doesn't feel empty
	_spawn_customer()

func _on_spawn_timer_timeout() -> void:
	_spawn_customer()

func _spawn_customer() -> void:
	if entities.get_child_count() >= max_visitors_alive:
		return

	var c := customer_scene.instantiate()
	entities.add_child(c)
	c.global_position = spawn_point.global_position

	if c.has_method("setup"):
		c.setup(shelf, shelf)
	else:
		push_error("Spawned scene has no setup() method. Attach Customer.gd to Customer.tscn root.")
