extends CharacterBody2D

var vlc = Vector2()
@export var speed = 200
@export var speed_acceleration = 5
@export var rotation_speed = 0.025

var bullets = []

func move():
	var up = Input.is_action_pressed("player_up")
	var down = Input.is_action_pressed("player_down")
	var left = Input.is_action_pressed("player_left")
	var right = Input.is_action_pressed("player_right")
	
	if up or down:
		
		if !$RunSound.playing:
			$RunSound.play()
			$IdleSound.stop()
		
		if up:
			vlc.y += speed_acceleration
		elif down:
			vlc.y -= speed_acceleration
		
		velocity = (vlc.normalized() * speed).rotated(rotation) 
		move_and_slide()
	else:
		vlc.y = 0
		$RunSound.stop()
		if !$IdleSound.playing:
			$IdleSound.play()
		
	if left or right:
		if left:
			rotation += rotation_speed
		elif right:
			rotation -= rotation_speed

func attack(delta):
	var shot = Input.is_action_just_pressed("player_shot")
	
	if shot and $Shot/ShotTimer.is_stopped():
		
		$Shot/ShotTimer.start()
		$Shot.visible = true
		$Shot/ShotSound.play()
	
		var kb = CharacterBody2D.new()
		var cs = CollisionShape2D.new()
		
		var bs = Sprite2D.new()
		var bullet_res = "res://asserts/sprites/bulletRed1_outline.png"
		var bullet_texture = load(bullet_res) as Texture2D
		bs.texture = bullet_texture
		bs.rotation = rotation + deg_to_rad(180)
		
		kb.position = position + Vector2(0, 130).rotated(rotation)
		kb.velocity = (kb.position - position) * 5
		
		cs.add_child(bs)
		kb.add_child(cs)
		get_parent().add_child(kb)
		bullets.append(kb)
		
	for b in bullets:
		b = b as CharacterBody2D
#		b.velocity = (Vector2(0,50).normalized() * 200)
		b.move_and_slide()

func _process(delta):
	move()
	attack(delta)
	


func _on_shot_timeout():
	$Shot.visible = false
