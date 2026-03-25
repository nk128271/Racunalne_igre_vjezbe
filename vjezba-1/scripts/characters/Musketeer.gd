class_name Musketeer
extends Character

var dodge_chance: float = 0.25

func _init(_name: String):
	super._init(_name, 100, 18, 4)

func take_damage(amount: int) -> void:
	if randf() < dodge_chance:
		print(name, " dodged the attack!")
		return
	super.take_damage(amount)

func use_ability(target: Character) -> void:
	var damage1 = max(0, attack_power - target.defense)
	var damage2 = max(0, attack_power - target.defense)
	print(name, " uses Double Shot on ", target.name, "!")
	target.take_damage(damage1)
	if target.is_alive():
		target.take_damage(damage2)
