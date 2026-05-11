# jump_boost_wall.gd
extends StaticBody3D

@export var boosted_jump := 10.0
@export var duration := 10.0
var _on_cooldown := false

func on_player_hit(player):
	if _on_cooldown:
		return
	player.apply_jump_boost(boosted_jump, duration)
	_on_cooldown = true
	await get_tree().create_timer(duration + 0.5).timeout
	_on_cooldown = false
