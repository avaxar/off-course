extends Area2D

@export var door: Door
var press: bool = false

const lines: Array[String] = [
	"hey you",
	"if this works im going home"
]

func _process(_delta):
	if press == false:
		$AnimationPlayer.play("unpressed")
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player and press == false:
		$AnimationPlayer.play("press")
		door.open()
		press = true
