class_name Door
extends StaticBody2D


func open():
	$DoorPlayer.play("open") 
	$SmokeDown.emitting = true
	$SmokeUp.emitting = true

	
func close():
	$DoorPlayer.play("close")
