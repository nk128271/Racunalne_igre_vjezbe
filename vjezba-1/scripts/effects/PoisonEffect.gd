class_name PoisonEffect
extends StatusEffect

var damage_per_turn: int

func _init(_duration: int, _damage_per_turn: int):
	super._init("Poison", _duration)
	damage_per_turn = _damage_per_turn

func on_apply(target: Character) -> void:
	print(target.name, " is poisoned for ", duration, " turns.")

func on_turn(target: Character) -> void:
	print(target.name, " takes ", damage_per_turn, " poison dmg.")
	target.take_damage(damage_per_turn)

func on_expire(target: Character) -> void:
	print("Poison effect on character ", target.name, " is gone.")
