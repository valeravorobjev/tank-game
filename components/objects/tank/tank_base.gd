extends CharacterBody2D

@export var speed = 200
@export var rotation_speed = 0.025
@export var speed_acceleration = 5

var tank_h_position = Vector2.ZERO

var track = TrackEngine.new()

func _move():
	var up = Input.is_action_pressed("player_up")
	var down = Input.is_action_pressed("player_down")
	var left = Input.is_action_pressed("player_left")
	var right = Input.is_action_pressed("player_right")
	
	if up or down:
		if !$RunSound.playing:
			$RunSound.play()
			$IdleSound.stop()
			
		
		if up:
			tank_h_position.y += speed_acceleration
		elif down:
			tank_h_position.y -= speed_acceleration
		
		velocity = (tank_h_position.normalized() * speed).rotated(rotation)
		track.tracking(get_parent(),position, rotation) 
		move_and_slide()
	else:
		$RunSound.stop()
		if !$IdleSound.playing:
			$IdleSound.play()
			pass
			

	if left:
		rotation += rotation_speed
	elif right:
		rotation -= rotation_speed

func _physics_process(delta):
	_move()
