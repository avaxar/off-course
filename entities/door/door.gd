class_name Door
extends StaticBody2D

func _process(delta):
	pass

func open():
	$DoorPlayer.play("open") 
	$CollisionPlayer.play("Disable")
	$SmokeDown.emitting = true
	$SmokeUp.emitting = true
	
func close():
	if mouse_entered:
		$DoorPlayer.play("close")
