class_name Player
extends Orb

@export var rotation_factor: float = 0.95
@export var trajectory_steps: int = 96
@export var trajectory_step_size: float = 1.0 / 60.0
@export var trajectory_line_steps: int = 4
@export var unlatched_gravitation: float = 0.15
@export var unlatching_boost: float = 1.25
@export var unlatching_time: float = 2.0

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


var time := 0.0
var latch_time := 0.0
func _process(delta: float) -> void:
	time += delta
	super(delta)
	handle_rotation(delta)

	draw_trajectories()

	if not dead:
		if check_collisions([trajectory_probe]):
			die.emit()
		if Input.is_action_just_pressed("latch"):
			latch_time = time
		if Input.is_action_just_released("latch"):
			linear_velocity *= get_unlatch_boost()

	latched = not dead and Input.is_action_pressed("latch")


func handle_rotation(delta: float) -> void:
	var rot := atan2(linear_velocity.y, linear_velocity.x)
	$Sprites.rotation = lerp_angle($Sprites.rotation, rot, rotation_factor * delta)


func get_unlatch_boost() -> float:
	if not latched:
		return 1.0

	var time_latched := clampf(time - latch_time, 0.0, unlatching_time)
	var boost := lerpf(1.0, unlatching_boost, time_latched / unlatching_time)
	return boost ** 2


static func calc_latch(force: Vector2, velocity: Vector2, latching: bool, unlatched_grav: float) -> Vector2:
	if latching:
		return force
	else:
		var dotted := force.normalized().dot(velocity.normalized())
		if dotted > 0:
			return force * unlatched_grav * dotted
		else:
			return Vector2(0.0, 0.0)


func gravitate(exclusions: Array = []) -> Vector2:
	return calc_latch(super(exclusions + [trajectory_probe]), linear_velocity, latched, unlatched_gravitation)


func map_trajectory(latching: bool) -> PackedVector2Array:
	trajectory_probe.position = Vector2(0.0, 0.0)
	trajectory_probe.mass = mass
	trajectory_probe.linear_velocity = linear_velocity * (1.0 if latching else get_unlatch_boost())
	trajectory_probe.radius = radius

	var path: PackedVector2Array = [Vector2(0.0, 0.0)]
	for _i in range(trajectory_steps):
		trajectory_probe.position += trajectory_probe.linear_velocity * trajectory_step_size

		var accel := trajectory_probe.gravitate([self]) / trajectory_probe.mass
		trajectory_probe.linear_velocity += calc_latch(accel, trajectory_probe.linear_velocity,
													   latching, unlatched_gravitation) * trajectory_step_size

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

	$DeathAudio.play()


func _on_danger_body_enter(_body: Node2D) -> void:
	if not dead:
		die.emit()


func _on_death_audio_finished() -> void:
	queue_free()
