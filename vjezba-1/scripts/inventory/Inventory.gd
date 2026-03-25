class_name Inventory
extends RefCounted

var items: Array[Item] = []
var max_slots: int

func _init(_max_slots: int):
	max_slots = _max_slots

func add_item(item: Item) -> bool:
	if items.size() >= max_slots:
		print("Inventory full.")
		return false
	items.append(item)
	print(item.item_name, " added to inventory.")
	return true

func remove_item(item: Item) -> void:
	items.erase(item)

func use_item(index: int, user: Character, target: Character) -> void:
	if index < 0 or index >= items.size():
		print("Neispravan indeks predmeta.")
		return

	var item = items[index]
	var consumed = item.use(user, target)
	if consumed:
		print(item.item_name, " removed from inventory.")
		items.remove_at(index)

func print_inventory() -> void:
	print("=== INVENTORY ===")
	for i in range(items.size()):
		print(i, ": ", items[i].item_name)
	if items.is_empty():
		print("Empty inventory.")
