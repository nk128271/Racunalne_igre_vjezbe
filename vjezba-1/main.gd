extends Node

func _ready():
	randomize()

	var warrior = Warrior.new("Garren")
	var mage = Mage.new("Dark Magician")
	print(warrior.name, "'s invetory:\n")
	warrior.inventory.add_item(HealingPotion.new(25))
	warrior.inventory.add_item(StrengthPotion.new(4))
	print(mage.name, "'s inventory:\n")
	mage.inventory.add_item(PoisonBomb.new())
	mage.inventory.add_item(HealingPotion.new(20))

	var battle = Battle.new(warrior, mage)

	battle.print_header()
	battle.print_status()

	
	print("\n[TURN 1]")
	battle.attack(warrior, mage)
	battle.use_ability(mage, warrior)
	battle.end_turn()

	
	print("\n[TURN 2]")
	battle.use_item(warrior, 1, warrior)
	battle.use_item(mage, 0, warrior)   
	battle.end_turn()

	
	print("\n[TURN 3]")
	battle.use_ability(warrior, mage)
	battle.attack(mage, warrior)
	battle.end_turn()

	
	print("\n[TURN 4]")
	battle.use_item(warrior, 0, warrior) 
	battle.use_ability(mage, warrior)
	battle.end_turn()

	print("\n[TURN 5]")
	battle.use_ability(warrior, mage)
	
	battle.announce_result()
