extends Label
class_name MoneyPopup

@export var rise_px: float = 30.0
@export var duration: float = 0.8

var _t: float = 0.0
var _start_pos: Vector2

func _ready() -> void:
	_start_pos = position

func _process(delta: float) -> void:
	_t += delta
	var a := clampf(_t / duration, 0.0, 1.0)

	position = _start_pos + Vector2(0, -rise_px * a)
	modulate.a = 1.0 - a

	if _t >= duration:
		queue_free()
