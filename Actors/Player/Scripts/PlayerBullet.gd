extends KinematicBody2D

var speed: float = 400
var velocity: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	velocity = move_and_slide(velocity)

func _on_DestroyTimer_timeout():
	queue_free()

func _on_Hurtbox_body_entered(_body):
	queue_free()
