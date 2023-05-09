extends Node

class_name TrackEngine

var tank_position = Vector2.ZERO
var tank_rotation: float = 0.0
var tank_prev_position = Vector2.ZERO
var track_res = preload("res://components/objects/tank/track.tscn")

func tracking(ground: Node, position: Vector2, rotation: float):
	tank_position = position
	tank_rotation = rotation
	
	if tank_prev_position == Vector2.ZERO:
		
		tank_prev_position = tank_position
		var track = track_res.instantiate()
		
		track.rotate(tank_rotation)
		track.position = tank_position + Vector2(0, -1).rotated(tank_rotation)
		
		ground.add_child(track)
		
	else:
		var nnd = tank_position - tank_prev_position
		var diff = abs(nnd.x) + abs(nnd.y)
		
		if diff >= 110:
			tank_prev_position = Vector2.ZERO
