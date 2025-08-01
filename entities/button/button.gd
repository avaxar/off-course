extends Area2D

@export var door: Door
var press: bool = false

func _process(delta):
	if press == false:
		$AnimationPlayer.play("unpressed")
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimationPlayer.play("press")
		door.open()
		press = true
