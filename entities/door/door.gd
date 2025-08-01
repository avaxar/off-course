class_name Door
extends StaticBody2D

func _process(delta):
	pass

func open():
	$AnimationPlayer.play("open")
	$AnimationPlayer.play("collision")
