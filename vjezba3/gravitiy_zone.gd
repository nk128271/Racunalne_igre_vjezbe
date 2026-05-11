extends Area3D

@export var gravity_scale := 2.5

func _ready():
	body_entered.connect(_on_entered)
	body_exited.connect(_on_exited)

func _on_entered(body):
	if body.has_method("set_gravity"):
		body.set_gravity(gravity_scale)
		body.set_status("Low gravity zona!")

func _on_exited(body):
	if body.has_method("set_gravity"):
		body.set_gravity(9.8)
		body.set_status("")
