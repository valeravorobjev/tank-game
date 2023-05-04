extends CharacterBody2D

var vlc = Vector2()
@export var speed = 200
@export var speed_acceleration = 5
@export var rotation_speed = 0.025

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
	
func attack():
	var shot = Input.is_action_just_pressed("player_shot")
	
	if shot and $Shot/ShotTimer.is_stopped():
		$Shot/ShotTimer.start()
		$Shot.visible = true
		$Shot/ShotSound.play()
		

func _process(delta):
	move()
	attack()


func _on_shot_timeout():
	$Shot.visible = false
