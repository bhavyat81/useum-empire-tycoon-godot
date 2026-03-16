extends CharacterBody2D
class_name Customer

@export var speed: float = 140.0
@export var view_time_sec: float = 0.8
@export var min_exhibits_to_view: int = 1
@export var max_exhibits_to_view: int = 3

var _route: Array[Node2D] = []
var _route_index: int = 0

var _exit_target: Node2D = null
var _current_target: Node2D = null

var _view_t: float = 0.0
var _viewing: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(exhibits: Array[Node2D], exit_target: Node2D) -> void:
	_exit_target = exit_target
	_route = _pick_route(exhibits)
	_route_index = 0
	_set_next_target()

func _pick_route(exhibits: Array[Node2D]) -> Array[Node2D]:
	var arr: Array[Node2D] = exhibits.duplicate()
	arr.shuffle()

	var n := clampi(randi_range(min_exhibits_to_view, max_exhibits_to_view), 1, arr.size())
	return arr.slice(0, n)

func _set_next_target() -> void:
	_viewing = false
	_view_t = 0.0

	if _route_index < _route.size():
		_current_target = _route[_route_index]
	else:
		_current_target = _exit_target

func _physics_process(delta: float) -> void:
	if _current_target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		_set_walking(false)
		return

	if _viewing:
		velocity = Vector2.ZERO
		move_and_slide()
		_set_walking(false)

		_view_t += delta
		if _view_t >= view_time_sec:
			_finish_viewing_current()
		return

	var dir := (_current_target.global_position - global_position)
	var dist := dir.length()

	if dist < 8.0:
		_reached_target()
		return

	velocity = dir.normalized() * speed
	move_and_slide()

	_update_anim_from_velocity()
	_set_walking(true)

func _reached_target() -> void:
	# If we're at an exhibit, pause and "look"
	if _route_index < _route.size():
		_viewing = true
		_view_t = 0.0
	else:
		queue_free()

func _finish_viewing_current() -> void:
	_viewing = false

	# Buy from exhibit (if it supports try_buy)
	var ex := _route[_route_index]
	if ex != null and ex.has_method("try_buy"):
		ex.try_buy()

	_route_index += 1
	_set_next_target()

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
		if v.y >= 0:
			anim_name = "walk_downRight" if v.x >= 0 else "walk_downLeft"
		else:
			anim_name = "walk_upRight" if v.x >= 0 else "walk_upLeft"
	else:
		if ay >= ax:
			anim_name = "walk_down" if v.y >= 0 else "walk_up"
		else:
			anim_name = "walk_right" if v.x >= 0 else "walk_left"

	if sprite.animation != anim_name:
		sprite.animation = anim_name
		sprite.play()
