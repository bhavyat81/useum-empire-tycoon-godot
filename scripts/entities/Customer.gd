extends CharacterBody2D
class_name Customer

@export var speed: float = 140.0

var target: Node2D
var shelf: Shelf

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(p_shelf: Shelf, p_target: Node2D) -> void:
	shelf = p_shelf
	target = p_target

func _physics_process(_delta: float) -> void:
	if target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		_set_walking(false)
		return

	var dir := (target.global_position - global_position)
	var dist := dir.length()
	if dist < 6.0:
		_on_reached_target()
		return

	velocity = dir.normalized() * speed
	move_and_slide()

	_update_anim_from_velocity()
	_set_walking(true)

func _set_walking(walking: bool) -> void:
	if sprite == null:
		return
	if walking:
		if not sprite.is_playing():
			sprite.play()
	else:
		if sprite.is_playing():
			sprite.stop()

func _update_anim_from_velocity() -> void:
	if sprite == null:
		return

	var v := velocity
	if v.length() < 0.1:
		return

	var ax := absf(v.x)
	var ay := absf(v.y)

	var anim_name := "walk_down"

	# Godot 2D: +Y is down
	if ax > ay * 0.6 and ay > ax * 0.6:
		# diagonal
		if v.y >= 0:
			anim_name = "walk_downRight" if v.x >= 0 else "walk_downLeft"
		else:
			anim_name = "walk_upRight" if v.x >= 0 else "walk_upLeft"
	else:
		# cardinal
		if ay >= ax:
			anim_name = "walk_down" if v.y >= 0 else "walk_up"
		else:
			anim_name = "walk_right" if v.x >= 0 else "walk_left"

	if sprite.animation != anim_name:
		sprite.animation = anim_name
		sprite.play()

func _on_reached_target() -> void:
	_set_walking(false)
	if shelf != null:
		shelf.try_buy()
	queue_free()
