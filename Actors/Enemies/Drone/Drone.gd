extends KinematicBody2D

const ACCELERATION: float = 2.0
const MAX_SPEED: float = 16.0
const FRICTION: float = 3.0
var velocity: Vector2 = Vector2.ZERO

export (int) var health: int = 6

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
onready var retreat_range = $RetreatRange
var target = null

onready var turret = $DroneTurret

export var bullet_scene: PackedScene
var can_shoot: bool = true
onready var shoot_cooldown: Timer = $Timers/ShootCooldown
export (float) var fire_rate = 1
export (int) var damage = 1 
onready var shoot_sound := $ShootSound
onready var hit_sound = $HitSound
onready var death_sound = $DeathSound

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
	velocity = velocity.clamped(MAX_SPEED)
	velocity = move_and_slide(velocity)

func idle_state():
	pass

func move_state():
	pass

func chase_state():
	if target == null:
		return
	velocity += position.direction_to(target.position) * ACCELERATION
	do_shoot()

func retreat_state():
	if target == null:
		return
	velocity += position.direction_to(target.position) * ACCELERATION * -1
	do_shoot()

func take_damage(dmg: int):
	if health - dmg <= 0 and !death_sound.playing:
		death_sound.play()
	else:
		health -= dmg

func do_shoot():
	aim_target()
	if can_shoot:
		var bullet = bullet_scene.instance()
		get_tree().get_root().add_child(bullet)
		shoot_sound.play()
		bullet.position = position
		bullet.damage = damage
		bullet.look_at(target.position)
		can_shoot = false
		shoot_cooldown.start(fire_rate)

func aim_target():
	if target == null:
		return
	turret.look_at(target.position)
	#rotation = position.angle_to(target.position)
	if turret.rotation_degrees < -360:
		turret.rotation_degrees = 0
	if turret.rotation_degrees > 360:
		turret.rotation_degrees = 0

func _on_AggroRange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = STATES.CHASE

func _on_DeaggroRange_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		state = STATES.IDLE

func _on_RetreatRange_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		state = STATES.RETREAT

func _on_RetreatRange_body_exited(body):
	if body.is_in_group("Player"):
		target = body
		state = STATES.CHASE

func _on_Hurtbox_area_entered(area):
	take_damage(area.get_parent().damage)
	hit_sound.play()
	area.get_parent().queue_free()

func _on_ShootCooldown_timeout():
	can_shoot = true

func _on_DeathSound_finished():
	queue_free()
	pass # Replace with function body.
