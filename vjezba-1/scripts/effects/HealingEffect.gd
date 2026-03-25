class_name HealingEffect
extends StatusEffect

var heal_per_turn: int

func _init(_duration: int, _heal_per_turn: int):
	super._init("Healing", _duration)
	heal_per_turn = _heal_per_turn

func on_apply(target: Character) -> void:
	print(target.name, " is healing for ", duration, " turns.")

func on_turn(target: Character) -> void:
	target.heal(heal_per_turn)

func on_expire(target: Character) -> void:
	print("Healing effect on character ", target.name, " is gone.")
