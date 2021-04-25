extends StaticBody2D

export (int) var health = 5

onready var pivot: Position2D = $Pivot

onready var attack_range: Area2D = $Range
export var bullet_scene: PackedScene
onready var shoot_cooldown: Timer = $ShootTimer
var can_shoot: bool = true
var damage: int = 1
var target = null
export var fire_rate: float = 2.0
onready var shoot_sound = $ShootSound
onready var hit_sound = $HitSound
onready var death_sound = $

func _physics_process(delta):
	if target == null:
		return
	do_shoot()

func _on_ShootTimer_timeout():
	can_shoot = true

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
	pivot.look_at(target.position)
	#rotation = position.angle_to(target.position)
	if pivot.rotation_degrees < -360:
		pivot.rotation_degrees = 0
	if pivot.rotation_degrees > 360:
		pivot.rotation_degrees = 0

func take_damage(dmg: int):
	if health - dmg <= 0:
		queue_free()
	else:
		health -= dmg

func _on_Range_body_entered(body):
	if body.is_in_group("Player"):
		target = body


func _on_Hurtbox_area_entered(area):
	take_damage(area.get_parent().damage)
	hit_sound.play()
	area.get_parent().queue_free()
	pass # Replace with function body.
