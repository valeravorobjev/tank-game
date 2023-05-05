extends CharacterBody2D

var vlc = Vector2()
@export var speed = 200
@export var bullet_speed = 5
@export var speed_acceleration = 5
@export var rotation_speed = 0.025

var prev_track_position = Vector2.ZERO

var bullets = []
var tracks = []

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
			vlc.y += speed_acceleration
		elif down:
			vlc.y -= speed_acceleration
		
		velocity = (vlc.normalized() * speed).rotated(rotation) 
		move_and_slide()
		_make_track()
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

func _make_bullet():
	var kb = CharacterBody2D.new()
	var cs = CollisionShape2D.new()
	var vn = VisibleOnScreenNotifier2D.new()
	
	vn.connect("screen_exited",_on_bullet_outofscreen.bind(kb))
	kb.add_child(vn)
		
	var bs = Sprite2D.new()
	var bullet_res = "res://asserts/sprites/bulletRed1_outline.png"
	var bullet_texture = load(bullet_res) as Texture2D
	bs.texture = bullet_texture
	bs.rotation = rotation + deg_to_rad(180)
		
	kb.position = position + Vector2(0, 130).rotated(rotation)
	kb.velocity = (kb.position - position) * bullet_speed
		
	cs.add_child(bs)
	kb.add_child(cs)
	get_parent().add_child(kb)
	bullets.append(kb)

func _make_track():
	
	if prev_track_position == Vector2.ZERO:
		prev_track_position = position
		
		var track = Sprite2D.new()
		track.texture = load("res://asserts/sprites/tracksSmall.png") as Texture2D
		track.rotate(rotation)
		track.position = position + Vector2(0, -1).rotated(rotation)
		
		var track_timer = Timer.new()
		add_child(track_timer)
		track_timer.connect("timeout", _on_track_life_timeout)
		track_timer.one_shot = true
		track_timer.wait_time = 10
		track_timer.start()
		
		tracks.push_back(track)

		get_parent().add_child(track)
	else:
		var nnd = position - prev_track_position
		var diff = abs(nnd.x) + abs(nnd.y)
		
		if diff >= 50:
			prev_track_position = Vector2.ZERO
	

func _shot():
	var shot = Input.is_action_just_pressed("player_shot")
	
	if shot and $Shot/ShotTimer.is_stopped():
		
		$Shot/ShotTimer.start()
		$Shot.visible = true
		$Shot/ShotSound.play()
		
		_make_bullet()
		
	for b in bullets:
		b = b as CharacterBody2D
		b.move_and_slide()

func _process(delta):
	_move()
	_shot()
	
func _ready():
	z_index = 10

func _on_shot_timeout():
	$Shot.visible = false
	
func _on_bullet_outofscreen(kb):
	bullets.erase(kb)
	kb.queue_free()
	
func _on_track_life_timeout():
	if len(tracks) > 0:
		var track = tracks.pop_front()
		track.queue_free()
