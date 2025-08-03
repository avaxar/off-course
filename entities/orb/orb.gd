class_name Orb
extends RigidBody2D

@export var active: bool = true
@export var deadly: bool = false
@export var radius: float = 10.0
@export var intensity: float = 1.0
@export var correction_radius: float = 128.0
@export var preferred_radius: float = 48.0
@export var influence_radius: float = 256.0

var color: Color:
	get:
		var h := intensity / 2.5
		var s := lerpf(0.7, 0.0, inverse_lerp(48.0, 96.0, preferred_radius))
		var v := 1.0
		var rgb := Color.from_hsv(h, s, v)
		if deadly:
			rgb = lerp(rgb, Color(1.0, rgb.g / 2.0, rgb.b / 2.0), sin(time * PI * 2.0) / 2.0 + 0.5)
		else:
			rgb = lerp(rgb, rgb.darkened(0.2), sin(time * PI * 2.0) / 2.0 + 0.5)

		return rgb


var time := 0.0
func _process(delta: float) -> void:
	time += delta
	$CollisionShape.shape.radius = radius
	$Particles.color = color
	$Sprite.modulate = color


@onready var last_velocity := linear_velocity
func _physics_process(_delta: float) -> void:
	if active:
		apply_force(gravitate())
	last_velocity = linear_velocity


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer or body is StaticBody2D or body is RigidBody2D:
		bounce(linear_velocity.normalized(), last_velocity)


func bounce(normal: Vector2, incidence: Vector2) -> void:
	$BounceAudio.play()
	if normal.dot(incidence) < 0.0:
		linear_velocity = incidence.bounce(normal)
		position += linear_velocity / 120.0


func gravitate(exclusions: Array = []) -> Vector2:
	if freeze:
		return Vector2(0.0, 0.0)

	var force := Vector2(0.0, 0.0)
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb == self or not orb.active or orb in exclusions:
			continue

		var g := 2000000.0 * orb.intensity
		var distance_sq := (orb.global_position - global_position).length_squared()
		var distance := sqrt(distance_sq)

		if distance > orb.influence_radius:
			continue
		var influence := 1.0 - (distance / orb.influence_radius) ** 16.0

		# Newton's universal gravitation
		var direction := (orb.global_position - global_position) / distance
		var force_vec := g * mass * orb.mass / distance_sq * direction * influence
		force += force_vec

		# Circular orbit correction
		if distance > orb.correction_radius:
			continue

		var perpendicular := direction.rotated(PI / 2.0)
		if linear_velocity.normalized().dot(perpendicular) < 0.0:
			# Makes sure the perpendicular direction matches with the direction
			perpendicular = -perpendicular
		var orbital_speed := sqrt(g * orb.mass / distance) * mass
		var orbital_vec := perpendicular * orbital_speed

		var correction_vec := orbital_vec - linear_velocity
		var correction_strength := 1.0 - (distance / orb.correction_radius) ** 64.0
		force += correction_vec * correction_strength * mass

		# Preferred orbital radius, as to not hit directly
		if distance > orb.preferred_radius:
			continue
		
		var safety_strength := 1.0 - (distance / orb.preferred_radius) ** 4.0
		force += -force_vec * safety_strength
	
	return force


func check_collisions(exclusions: Array = [], margin: float = 0.5) -> bool:
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb == self or not orb.active or not orb.deadly or orb in exclusions:
			continue
		if (orb.global_position - global_position).length() <= radius + orb.radius + margin:
			return true
	
	return false
