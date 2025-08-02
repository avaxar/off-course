class_name Camera
extends Camera2D

@export var focus_radius: float = 64.0
@export var correction_factor: float = 0.99995


func move(delta: float, player: Player) -> void:
	var interest := get_interest(player)
	if interest != null:
		var correction := interest.global_position - global_position
		global_position += correction * correction_factor * delta


func get_interest(player: Player) -> Node2D:
	var interest: Node2D = null
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb in get_tree().get_nodes_in_group("player") or not orb.active:
			continue
		
		var distance := (orb.global_position - player.global_position).length()
		if distance > focus_radius:
			continue
		if interest == null or distance < (interest.global_position - player.global_position).length():
			interest = orb
	
	if interest == null:
		return player
	else:
		return interest
