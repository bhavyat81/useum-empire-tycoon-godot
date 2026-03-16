extends CanvasLayer
class_name MoneyPopupSpawner

@export var popup_scene: PackedScene

func spawn_money_popup(amount: int, world_pos: Vector2) -> void:
	if popup_scene == null:
		return

	var p = popup_scene.instantiate()
	add_child(p)

	# Convert world -> screen/canvas coordinates
	var vp := get_viewport()
	var cam := vp.get_camera_2d()
	var screen_pos := world_pos
	if cam != null:
		screen_pos = cam.unproject_position(world_pos)

	p.position = screen_pos
	p.text = "+%d" % amount
	p.add_theme_color_override("font_color", Color(0.2, 1.0, 0.2))
