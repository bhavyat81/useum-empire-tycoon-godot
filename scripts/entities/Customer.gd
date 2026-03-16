extends CharacterBody2D
class_name Customer

@export var speed: float = 140.0

var target: Node2D
var shelf: Shelf

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

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

	# flip left/right depending on movement direction
	if absf(velocity.x) > 0.1:
		sprite.flip_h = velocity.x < 0.0

	_set_walking(true)

func _set_walking(walking: bool) -> void:
	if walking:
		if anim != null and anim.current_animation != "walk":
			anim.play("walk")
	else:
		if anim != null and anim.is_playing():
			anim.stop()
		if sprite != null:
			sprite.position = Vector2.ZERO

func _on_reached_target() -> void:
	_set_walking(false)
	# Buy once then despawn
	if shelf != null:
		shelf.try_buy()
	queue_free()
