extends Area2D
class_name Shelf

@export var item_name: String = "Toy"
@export var price: int = 25

func try_buy() -> void:
	# For now: infinite stock, instant purchase
	get_node("/root/GameState").add_money(price)
