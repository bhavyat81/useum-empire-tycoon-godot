extends CharacterBody3D
class_name Customer3D

@export var speed: float = 3.8
@export var accel: float = 10.0

@export var min_x: float = -16.5
@export var max_x: float = 16.5
@export var min_z: float = -11.5
@export var max_z: float = 11.5

@export var min_wait: float = 0.4
@export var max_wait: float = 1.2

@export var life_time_sec: float = 12.0
@export var exit_radius: float = 0.8

var _target: Vector3
var _wait_t: float = 0.0
var _life_t: float = 0.0
var _exiting: bool = false
var _exit_pos: Vector3

func setup(entry_position: Vector3, exit_position: Vector3) -> void:
	global_position = entry_position
	_exit_pos = exit_position
	_pick_new_target()

func _pick_new_target() -> void:
	_wait_t = randf_range(min_wait, max_wait)
	_target = Vector3(
		randf_range(min_x, max_x),
		0.0,
		randf_range(min_z, max_z)
	)

func _physics_process(delta: float) -> void:
	_life_t += delta
	if not _exiting and _life_t >= life_time_sec:
		_exiting = true

	if _exiting:
		_move_towards(_exit_pos, delta)
		if global_position.distance_to(_exit_pos) <= exit_radius:
			queue_free()
		return

	_wait_t -= delta
	if _wait_t > 0.0:
		velocity.x = move_toward(velocity.x, 0.0, accel * delta)
		velocity.z = move_toward(velocity.z, 0.0, accel * delta)
		velocity.y = 0.0
		move_and_slide()
		return

	if global_position.distance_to(_target) < 0.7:
		_pick_new_target()
		return

	_move_towards(_target, delta)

func _move_towards(pos: Vector3, delta: float) -> void:
	var to := pos - global_position
	to.y = 0.0
	var desired := Vector3.ZERO
	if to.length() > 0.001:
		desired = to.normalized() * speed

	velocity.x = move_toward(velocity.x, desired.x, accel * delta)
	velocity.z = move_toward(velocity.z, desired.z, accel * delta)
	velocity.y = 0.0

	if desired.length() > 0.05:
		look_at(global_position + Vector3(desired.x, 0, desired.z), Vector3.UP)

	move_and_slide()
