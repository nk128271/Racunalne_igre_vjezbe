class_name Item
extends RefCounted

var item_name: String
var weight: float

func _init(_item_name: String, _weight: float = 1.0):
	item_name = _item_name
	weight = _weight

func use(user: Character, target: Character) -> bool:
	return false
