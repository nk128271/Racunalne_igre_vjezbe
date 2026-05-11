extends Area3D

@export var speed_multiplier := 2.0
var is_active := true

func _ready():
	body_entered.connect(_on_entered)
	body_exited.connect(_on_exited)

func _on_entered(body):
	if not is_active:
		return
	if body.has_method("set_speed_multiplier"):
		body.set_speed_multiplier(speed_multiplier)
		body.set_status("Speed zona!")

func _on_exited(body):
	if body.has_method("set_speed_multiplier"):
		body.set_speed_multiplier(1.0)
		body.set_status("")

func deactivate_temporarily(player):
	if not is_active:
		return
	is_active = false
	$MeshInstance3D.visible = false
	player.set_status("Speed zona deaktivirana!")
	await get_tree().create_timer(5.0).timeout
	is_active = true
	$MeshInstance3D.visible = true
	player.set_status("Speed zona aktivna!")
	await get_tree().create_timer(2.0).timeout
	player.set_status("")
