extends Control

@onready var money_label: Label = $VBoxContainer/MoneyLabel
@onready var add_money_button: Button = $VBoxContainer/AddMoneyButton

func _ready() -> void:
	add_money_button.pressed.connect(_on_add_money_pressed)

	var gs := get_node("/root/GameState")
	gs.money_changed.connect(_on_money_changed)

	_refresh()

func _on_add_money_pressed() -> void:
	get_node("/root/GameState").add_money(10)

func _on_money_changed(_new_money: int) -> void:
	_refresh()

func _refresh() -> void:
	var gs := get_node("/root/GameState")
	money_label.text = "Money: %d" % gs.money
