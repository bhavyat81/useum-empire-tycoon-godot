extends Node2D

@export var customer_scene: PackedScene

@onready var shelf: Area2D = $World/shelf
@onready var spawn_point: Marker2D = $World/SpawnPoint

func _ready() -> void:
	print("Main.gd _ready()")
	print("customer_scene = ", customer_scene)
	print("spawn_point = ", spawn_point.global_position)
	print("shelf = ", shelf.global_position)
	_spawn_customer()

func _spawn_customer() -> void:
	if customer_scene == null:
		push_error("Main.gd: customer_scene not set in Inspector")
		return

	var c = customer_scene.instantiate()
	print("Spawned: ", c, " class=", c.get_class())
	$World/Entities.add_child(c)
	c.global_position = spawn_point.global_position
	print("Customer position set to ", c.global_position)

	if c.has_method("setup"):
		print("Calling c.setup(...)")
		c.setup(shelf, shelf)
	else:
		push_error("Spawned scene has no setup() method. Attach Customer.gd to Customer.tscn root.")
