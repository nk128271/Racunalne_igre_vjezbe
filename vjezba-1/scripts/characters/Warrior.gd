class_name Warrior
extends Character

func _init(_name: String):
	super._init(_name, 140, 20, 8)

func use_ability(target: Character) -> void:
	var damage = max(0, (attack_power * 2) - target.defense)
	print(name, " uses Power Slash on ", target.name, " for ", damage, " dmg!")
	target.take_damage(damage)
