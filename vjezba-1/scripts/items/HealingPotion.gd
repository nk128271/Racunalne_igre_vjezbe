class_name HealingPotion
extends Item

var heal_amount: int

func _init(_heal_amount: int = 30):
	super._init("Healing Potion", 0.5)
	heal_amount = _heal_amount

func use(user: Character, target: Character) -> bool:
	print(user.name, " uses ", item_name)
	user.heal(heal_amount)
	return true
