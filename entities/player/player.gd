class_name Player
extends Orb

@export var trajectory_steps: int = 200
@export var trajectory_step_size: float = 1.0 / 60.0

@onready var sprites: Node2D = $Sprites
@onready var trajectory_probe: Orb = $TrajectoryProbe
@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var gravitated_trajectory_line: Line2D = $GravitatedTrajectoryLine

var latched := false
var dead := false


func _process(delta: float) -> void:
	super(delta)
	latched = not dead and Input.is_action_pressed("latch")
	draw_trajectories()

	if not dead and check_collisions([trajectory_probe]):
		die.emit()


func gravitate(exclusions: Array = []) -> Vector2:
	if latched:
		return super(exclusions + [trajectory_probe])
	else:
		return Vector2(0.0, 0.0)


func map_trajectory(gravitated: bool) -> PackedVector2Array:
	trajectory_probe.position = Vector2(0.0, 0.0)
	trajectory_probe.mass = mass
	trajectory_probe.linear_velocity = linear_velocity
	trajectory_probe.radius = radius

	var path: PackedVector2Array = [Vector2(0.0, 0.0)]
	for _i in range(trajectory_steps):
		trajectory_probe.position += trajectory_probe.linear_velocity * trajectory_step_size
		if gravitated:
			var accel := trajectory_probe.gravitate([self]) / trajectory_probe.mass
			trajectory_probe.linear_velocity += accel * trajectory_step_size

		if trajectory_probe.check_collisions([self], 1.0):
			break

		path.append(trajectory_probe.position)

	return path


func draw_trajectories() -> void:
	trajectory_line.points = map_trajectory(false)
	gravitated_trajectory_line.points = map_trajectory(true)


func _on_body_entered(body: Node) -> void:
	print(body)
	# if not dead and body is Orb and body.active:
	# 	die.emit()


signal die
func _on_die() -> void:
	print("Dead!")
	dead = true
	trajectory_line.hide()
	gravitated_trajectory_line.hide()
	$Sprites/Back.hide()
	$Sprites/Lupin.hide()
	$Sprites/Front.play("pop")
