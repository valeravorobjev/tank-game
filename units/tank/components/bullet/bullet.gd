extends CharacterBody2D

var bullet_speed = 5
var tank_position = Vector2.ZERO
var tank_rotation: float = 0.0

var bang_scene = preload("res://units/tank/components/bang/bang.tscn")

func _ready():
	$Sprite2D.rotation = tank_rotation + deg_to_rad(180)
	position = tank_position + Vector2(0, 130).rotated(tank_rotation)
	velocity = (position - tank_position) * bullet_speed
	
func _on_bullet_outofscreen():
	queue_free()
	
func bullet_collide():
	var collision = get_last_slide_collision()
	if collision != null:
		velocity = Vector2.ZERO
		$Sprite2D.hide()
		var collider = collision.get_collider()
		var km = collision as KinematicCollision2D
		var km_pos = km.get_position()

		var tm = collider as TileMap
		if tm == null:
			var bang = bang_scene.instantiate() as AnimatedSprite2D
			bang.connect("animation_finished",_end_band_animation)
			add_child(bang)
			bang.play("smoke")
			return

		var cell_position = tm.local_to_map(km_pos) 

		var tile_data = tm.get_cell_tile_data(1, cell_position)
		if tile_data != null:
			var data = tile_data.get_custom_data("coins")
			print(data)
			tm.set_cell(1, cell_position, -1)
			var bang = bang_scene.instantiate() as AnimatedSprite2D
			bang.connect("animation_finished",_end_band_animation)
			add_child(bang)
			var sound = bang.get_child(0) as AudioStreamPlayer2D
			sound.play()
			bang.play("smoke")

func _end_band_animation():
	queue_free()
	
func _physics_process(delta):
	move_and_slide()
	bullet_collide()

