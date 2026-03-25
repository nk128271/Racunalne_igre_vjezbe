class_name Battle
extends RefCounted

var fighter_a: Character
var fighter_b: Character
var turn_count: int = 1

func _init(_fighter_a: Character, _fighter_b: Character):
	fighter_a = _fighter_a
	fighter_b = _fighter_b

func print_header() -> void:
	print("\n==============================")
	print("BORBA: ", fighter_a.name, " vs ", fighter_b.name)
	print("==============================\n")

func print_status() -> void:
	fighter_a.print_status()
	fighter_b.print_status()

func is_over() -> bool:
	return not fighter_a.is_alive() or not fighter_b.is_alive()

func get_winner() -> Character:
	if fighter_a.is_alive() and not fighter_b.is_alive():
		return fighter_a
	if fighter_b.is_alive() and not fighter_a.is_alive():
		return fighter_b
	return null

func attack(attacker: Character, defender: Character) -> void:
	if not attacker.is_alive() or not defender.is_alive():
		return
	attacker.attack(defender)

func use_ability(attacker: Character, defender: Character) -> void:
	if not attacker.is_alive() or not defender.is_alive():
		return
	attacker.use_ability(defender)

func use_item(user: Character, item_index: int, target: Character) -> void:
	if not user.is_alive():
		return
	user.inventory.use_item(item_index, user, target)

func end_turn() -> void:
	print("\n-- Kraj poteza ", turn_count, " --")
	fighter_a.process_turn_effects()
	fighter_b.process_turn_effects()
	print_status()
	turn_count += 1

func announce_result() -> void:
	if get_winner() != null:
		print("\nPOBJEDNIK JE: ", get_winner().name)
	else:
		print("\nBorba je završila bez pobjednika.")
