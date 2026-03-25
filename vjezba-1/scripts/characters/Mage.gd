class_name Mage
extends Character

var mana: int = 100

func _init(_name: String):
	super._init(_name, 90, 12, 3)

func use_ability(target: Character) -> void:
	if mana >= 25:
		mana -= 25
		var damage = 35
		print(name, " casts Dark Magic Attack on ", target.name, " for ", damage, " dmg! Mana: ", mana)
		target.take_damage(damage)
	else:
		print(name, " Not enough mana.")
		attack(target)

func print_status() -> void:
	print("== ", name, " | HP: ", health, "/", max_health, " | Mana: ", mana, " | ATK: ", attack_power, " | DEF: ", defense)
