extends Sprite2D

func _ready():
	$Timer.start()

func _on_track_life_timeout():
	queue_free()
