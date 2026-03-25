class_name StrengthPotion
extends Item

var bonus: int

func _init(_bonus: int = 5):
	super._init("Strength Potion", 0.5)
	bonus = _bonus

func use(user: Character, target: Character) -> bool:
	user.attack_power += bonus
	print(user.name, " uses ", item_name, " and gains +", bonus, " ATK.")
	return true
