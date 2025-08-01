class_name Door
extends StaticBody2D

func _process(delta):
	pass

func open():
	$DoorPlayer.play("open") 
	$CollisionPlayer.play("Disable")
