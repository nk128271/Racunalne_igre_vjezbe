class_name PoisonBomb
extends Item

func _init():
	super._init("Poison Bomb", 1.0)

func use(user: Character, target: Character) -> bool:
	print(user.name, " throws ", item_name, " on ", target.name)
	target.add_effect(PoisonEffect.new(3, 8))
	return true
