extends CharacterBody2D

@export var speed = 200
@export var rotation_speed = 0.025
@export var speed_acceleration = 5

var tank_h_position = Vector2.ZERO
var track = TrackEngine.new()
