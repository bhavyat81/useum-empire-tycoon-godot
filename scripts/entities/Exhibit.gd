extends Area2D
class_name Exhibit

@export var item_name: String = "Artifact"
@export var price: int = 10

func try_buy() -> bool:
	# TODO: connect to real money system; for now just log
	print("Customer bought: %s for %d" % [item_name, price])
	return true
