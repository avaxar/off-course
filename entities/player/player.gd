class_name Player
extends Orb

@export var rotation_factor: float = 0.95
@export var trajectory_steps: int = 96
@export var trajectory_step_size: float = 1.0 / 60.0
@export var trajectory_line_steps: int = 4
@export var unlatched_gravitation: float = 0.15

@onready var trajectory_probe: Orb = $TrajectoryProbe

var latched_trajlines := []
var unlatched_trajlines := []
var latched := false
var dead := false


func _ready() -> void:
	for trajlines in [latched_trajlines, unlatched_trajlines]:
		for i in range(trajectory_line_steps, trajectory_steps, trajectory_line_steps * 2):
			var line := Line2D.new()
			add_child(line)
			trajlines.append(line)


func _process(delta: float) -> void:
	super(delta)
	handle_rotation(delta)

	latched = not dead and Input.is_action_pressed("latch")
	draw_trajectories()

	if not dead and check_collisions([trajectory_probe]):
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
	var unlatched_traj := map_trajectory(false)
	var latched_traj := map_trajectory(true)

	for tuple in [[unlatched_trajlines, unlatched_traj, Color(1.0, 1.0, 1.0)],
				  [latched_trajlines, latched_traj, Color(1.0, 0.0, 0.0)]]:
		var lines: Array = tuple[0]
		var traj: PackedVector2Array = tuple[1]
		var color: Color = tuple[2]

		for i in range(trajectory_line_steps, trajectory_steps, trajectory_line_steps * 2):
			@warning_ignore("integer_division")
			var j := i / (trajectory_line_steps * 2)

			lines[j].width = 1.0
			lines[j].default_color = Color(color.r, color.g, color.b, 1.0 - float(i) / trajectory_steps)
			lines[j].points = traj.slice(i, i + trajectory_line_steps)


signal die
func _on_die() -> void:
	call_deferred("do_death")


func do_death() -> void:
	dead = true
	active = false
	$CollisionShape.disabled = true
	linear_velocity = Vector2(0.0, 0.0)

	for trajlines in [latched_trajlines, unlatched_trajlines]:
		for line in trajlines:
			line.hide()
	$Sprites/Back.hide()
	$Sprites/Lupin.hide()
	$Sprites/Front.play("pop")


func _on_danger_body_enter(_body: Node2D) -> void:
	if not dead:
		die.emit()
