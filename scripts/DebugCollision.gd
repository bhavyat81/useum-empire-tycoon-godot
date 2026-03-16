extends Node

func _ready() -> void:
	# Show collision shapes
	if OS.is_debug_build():
		get_tree().debug_collisions_hint = true
		get_tree().debug_navigation_hint = true
