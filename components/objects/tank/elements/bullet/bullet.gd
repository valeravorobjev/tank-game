extends CharacterBody2D

var bullet_speed = 5
var tank_position = Vector2.ZERO
var tank_rotation: float = 0.0

func _ready():
	$Sprite2D.rotation = tank_rotation + deg_to_rad(180)
	position = tank_position + Vector2(0, 130).rotated(tank_rotation)
	velocity = (position - tank_position) * bullet_speed
	
func _on_bullet_outofscreen():
	queue_free()
	
func _physics_process(delta):
	move_and_slide()

