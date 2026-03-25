class_name ConsumableItem
extends Item

func use(user, target) -> bool:
	apply_effect(user, target)
	return true 

func apply_effect(user, target) -> void:
	pass
