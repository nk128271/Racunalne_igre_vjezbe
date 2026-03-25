class_name Character
extends RefCounted

var name: String
var max_health: int
var health: int
var attack_power: int
var defense: int
var inventory: Inventory
var active_effects: Array[StatusEffect] = []

func _init(_name: String, _max_health: int, _attack_power: int, _defense: int):
	name = _name
	max_health = _max_health
	health = _max_health
	attack_power = _attack_power
	defense = _defense
	inventory = Inventory.new(5) 

func is_alive() -> bool:
	return health > 0

func attack(target: Character) -> void:
	var damage = max(0, attack_power - target.defense)
	print(name, " attacks ", target.name, ".")
	target.take_damage(damage)

func take_damage(amount: int) -> void:
	health = max(0, health - amount)
	print(name, " takes ", amount, " dmg. HP: ", health, "/", max_health)

func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	print(name, " heals himself. HP: ", health, "/", max_health)

func add_effect(effect: StatusEffect) -> void:
	active_effects.append(effect)
	effect.on_apply(self)

func process_turn_effects() -> void:
	var expired: Array[StatusEffect] = []
	for effect in active_effects:
		effect.on_turn(self)
		effect.duration -= 1
		if effect.duration <= 0:
			effect.on_expire(self)
			expired.append(effect)

	for e in expired:
		active_effects.erase(e)

func use_ability(target: Character) -> void:
	print(name, " has no special ability.")

func print_status() -> void:
	print("== ", name, " | HP: ", health, "/", max_health, " | ATK: ", attack_power, " | DEF: ", defense)
