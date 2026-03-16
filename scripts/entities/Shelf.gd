extends Area2D
class_name Shelf

@export var item_name: String = "Exhibit"
@export var price: int = 25

func try_buy() -> void:
	# For now: infinite stock, instant purchase
	get_node("/root/GameState").add_money(price)

	# Spawn popup (if present in the main scene)
	var spawner = get_tree().root.get_node_or_null("Main/MoneyPopupSpawner")
	if spawner != null and spawner.has_method("spawn_money_popup"):
		spawner.spawn_money_popup(price, global_position)
