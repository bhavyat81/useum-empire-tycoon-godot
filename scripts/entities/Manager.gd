extends CharacterBody2D
class_name Manager

@export var speed: float = 200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if dir.length() > 1.0:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()

	_update_anim(dir)

func _update_anim(dir: Vector2) -> void:
	if sprite == null:
		return

	if dir.length() < 0.01:
		if sprite.is_playing():
			sprite.stop()
		return

	# Prefer cardinal anims
	var anim := "walk_down"
	if absf(dir.x) > absf(dir.y):
		anim = "walk_right" if dir.x > 0 else "walk_left"
	else:
		anim = "walk_down" if dir.y > 0 else "walk_up"

	if sprite.animation != anim:
		sprite.animation = anim
	sprite.play()
