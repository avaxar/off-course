class_name Orb
extends RigidBody2D

@export var active: bool = true
@export var radius: float = 12.0
@export var intensity: float = 1.0
@export var correction_radius: float = 128.0
@export var preferred_radius: float = 48.0


func _process(_delta: float) -> void:
	$CollisionShape.shape.radius = radius


func _physics_process(_delta: float) -> void:
	if active:
		apply_force(gravitate())


func gravitate(exclusions: Array = []) -> Vector2:
	var force := Vector2(0.0, 0.0)
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb == self or not orb.active or orb in exclusions:
			continue

		var g := 1000000.0 * orb.intensity

		# Newton's universal gravitation
		var distance_sq := (orb.global_position - global_position).length_squared()
		var distance := sqrt(distance_sq)
		var direction := (orb.global_position - global_position) / distance
		var force_vec := g * mass * orb.mass / distance_sq * direction
		force += force_vec

		# Circular orbit correction
		if distance > correction_radius:
			continue

		var perpendicular := direction.rotated(PI / 2.0)
		if linear_velocity.normalized().dot(perpendicular) < 0.0:
			# Makes sure the perpendicular direction matches with the direction
			perpendicular = -perpendicular
		var orbital_speed := sqrt(g * orb.mass / distance) * mass
		var orbital_vec := perpendicular * orbital_speed

		var correction_vec := orbital_vec - linear_velocity
		var correction_strength := 1.0 - (distance / correction_radius) ** 64.0
		force += correction_vec * correction_strength * mass

		# Preferred orbital radius, as to not hit directly
		if distance > preferred_radius:
			continue
		
		var safety_strength := 1.0 - (distance / preferred_radius) ** 4.0
		force += -force_vec * safety_strength
	
	return force


func check_collisions(exclusions: Array = [], margin: float = 0.5) -> bool:
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb == self or not orb.active or orb in exclusions:
			continue
		if (orb.global_position - global_position).length() <= radius + orb.radius + margin:
			return true
	
	return false
