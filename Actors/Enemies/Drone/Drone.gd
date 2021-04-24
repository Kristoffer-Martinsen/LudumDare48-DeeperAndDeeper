extends KinematicBody2D

const ACCELERATION: float = 2.0
const MAX_SPEED: float = 16.0
const FRICTION: float = 3.0
var velocity: Vector2 = Vector2.ZERO

enum STATES {
	IDLE,
	MOVE,
	CHASE,
	RETREAT
}
var state = STATES.IDLE

onready var sensors_pivot = $SensorsPivot
const ROTATION_SPEED = 8


onready var aggro_range = $AggroRange
onready var deaggro_range = $DeaggroRange
var target = null


func _physics_process(delta):
	sensors_pivot.rotation += ROTATION_SPEED * delta

	match state:
		STATES.IDLE:
			idle_state()
		STATES.MOVE:
			move_state()
		STATES.CHASE:
			chase_state()
		STATES.RETREAT:
			retreat_state()
		_:
			pass
	# TODO: Clamp max speed
	velocity = move_and_slide(velocity)

func idle_state():
	pass

func move_state():

	pass

func chase_state():
	if target == null:
		return
	velocity += position.direction_to(target.position) * ACCELERATION
	pass

func retreat_state():
	pass


func _on_Hurtbox_body_entered(_body):
	# TODO: Take damage
	pass

func _on_AggroRange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = STATES.CHASE

func _on_DeaggroRange_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		state = STATES.IDLE
