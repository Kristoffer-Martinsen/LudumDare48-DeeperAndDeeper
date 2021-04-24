extends KinematicBody2D

var speed: float = 200
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	move_and_slide(velocity)


func _on_DestroyTimer_timeout():
	queue_free()
