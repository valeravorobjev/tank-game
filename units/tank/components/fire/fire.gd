extends Sprite2D

var bullet_src = preload("res://units/tank/components/bullet/bullet.tscn")

func _ready():
	visible = false

func _on_shot_timeout():
	visible = false

func _fire(parent:Node):
	$FireTimer.start()
	visible = true
	$FireSound.play()
		
	var bullet = bullet_src.instantiate()
	bullet.set("tank_position", parent.get("position"))
	bullet.set("tank_rotation", parent.get("rotation"))
	parent.get_parent().add_child(bullet)


func player_fire(parent: Node):
	var shot = Input.is_action_just_pressed("player_shot")
	
	if shot and $FireTimer.is_stopped():
		_fire(parent)
		
func ai_fire(parent: Node):
	_fire(parent)
		

