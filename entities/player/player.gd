class_name Player
extends Orb

@export var rotation_factor: float = 0.95
@export var trajectory_steps: int = 64
@export var trajectory_step_size: float = 1.0 / 60.0
@export var unlatched_gravitation: float = 0.15

@onready var trajectory_probe: Orb = $TrajectoryProbe
@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var gravitated_trajectory_line: Line2D = $GravitatedTrajectoryLine

var latched := false
var dead := false


func _process(delta: float) -> void:
	super(delta)
	handle_rotation(delta)

	latched = not dead and Input.is_action_pressed("latch")
	draw_trajectories()

	if dead:
		linear_velocity -= linear_velocity * 0.975 * delta
	elif check_collisions([trajectory_probe]):
		die.emit()


func handle_rotation(delta: float) -> void:
	var rot := atan2(linear_velocity.y, linear_velocity.x)
	$Sprites.rotation = lerp_angle($Sprites.rotation, rot, rotation_factor * delta)


func gravitate(exclusions: Array = []) -> Vector2:
	return super(exclusions + [trajectory_probe]) * (1.0 if latched else unlatched_gravitation)


func map_trajectory(latching: bool) -> PackedVector2Array:
	trajectory_probe.position = Vector2(0.0, 0.0)
	trajectory_probe.mass = mass
	trajectory_probe.linear_velocity = linear_velocity
	trajectory_probe.radius = radius

	var path: PackedVector2Array = [Vector2(0.0, 0.0)]
	for _i in range(trajectory_steps):
		trajectory_probe.position += trajectory_probe.linear_velocity * trajectory_step_size

		var accel := trajectory_probe.gravitate([self]) / trajectory_probe.mass
		trajectory_probe.linear_velocity += accel * trajectory_step_size * (1.0 if latching else unlatched_gravitation)

		if trajectory_probe.check_collisions([self], 1.0):
			break

		path.append(trajectory_probe.position)

	return path


func draw_trajectories() -> void:
	trajectory_line.points = map_trajectory(false)
	gravitated_trajectory_line.points = map_trajectory(true)


signal die
func _on_die() -> void:
	print("Dead!")
	dead = true
	trajectory_line.hide()
	gravitated_trajectory_line.hide()
	$Sprites/Back.hide()
	$Sprites/Lupin.hide()
	$Sprites/Front.play("pop")


func _on_danger_body_enter(_body: Node2D) -> void:
	if not dead:
		die.emit()
