extends StaticBody2D

var open: bool = false
onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D

func _on_TargetTutorial_open():
	if sprite.frame != 1:
		sprite.frame = 1
		collision_shape.disabled = true
	pass # Replace with function body.
