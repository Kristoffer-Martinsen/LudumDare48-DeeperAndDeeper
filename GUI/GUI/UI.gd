extends Control

var health = 5 setget set_health

var max_health = 5 setget set_max_health

onready var label = $Label

func set_health(value):
    health = clamp(value, 0, max_health)

func set_max_health(value):
    max_health = max(value, 1)

func _ready():
    self.max_health = Ship.max_health
    self.health = Ship.health
    Ship.connect("health_changed", self, "set_health")