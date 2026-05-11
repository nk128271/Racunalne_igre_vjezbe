extends StaticBody3D

@export var damage := 20.0
@export var cooldown := 1.5
var on_cooldown := false

func on_player_hit(player):
	if on_cooldown:
		return
	player.take_damage(damage)
	on_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false
