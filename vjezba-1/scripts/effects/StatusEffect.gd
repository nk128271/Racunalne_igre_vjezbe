class_name StatusEffect
extends RefCounted

var effect_name: String
var duration: int

func _init(_effect_name: String, _duration: int):
	effect_name = _effect_name
	duration = _duration

func on_apply(target: Character) -> void:
	pass

func on_turn(target: Character) -> void:
	pass

func on_expire(target: Character) -> void:
	pass
