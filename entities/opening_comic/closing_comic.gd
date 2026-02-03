extends Node2D

var panel := 0
var closing := false

func _process(delta: float) -> void:
	if closing:
		modulate.a -= 4.0 * modulate.a * delta
		modulate.a = max(modulate.a, 0.0)

	if Input.is_action_just_pressed("latch") && panel == 0:
		$AnimationPlayer.play("panel1")
		print("com")

	if Input.is_action_just_pressed("latch") && panel == 1:
		$AnimationPlayer.play("panel2")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 2:
		$AnimationPlayer.play("panel3")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 3:
		$AnimationPlayer.play("panel4")
		print("com")

	if Input.is_action_just_pressed("latch") && panel == 4:
		closing = true
		$Timer.start()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	panel += 1


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://entities/thankyou.tscn")
