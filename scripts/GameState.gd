extends Node

signal money_changed(new_money: int)

var money: int = 0

func add_money(amount: int) -> void:
	money += amount
	money_changed.emit(money)
