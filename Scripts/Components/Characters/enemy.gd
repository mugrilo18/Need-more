extends CharacterBody3D
class_name Enemy

@export var destination_array: Array[Marker3D]
@export var player_ref_pos: Marker3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var idle_timer: Timer = $IdleTimer

enum EnemyState {
	IDLE,
	PATROL,
	CHASE,
}

var current_state: EnemyState = EnemyState.IDLE

var saw_player := false
var lantern_on := false

const SPEED_WALK := 2.0
const SPEED_CHASE := 4.0


func _ready():
	_set_state(EnemyState.IDLE)


func _physics_process(_delta):
	lantern_on = PlayerStatus.lantern

	match current_state:

		EnemyState.IDLE:
			if saw_player or lantern_on:
				_set_state(EnemyState.CHASE)
			

		EnemyState.PATROL:
			if saw_player or lantern_on:
				_set_state(EnemyState.CHASE)
			else:
				_move_to_target(SPEED_WALK)

		EnemyState.CHASE:
			if !saw_player and !lantern_on:
				_set_state(EnemyState.IDLE)
			else:
				navigation_agent_3d.target_position = player_ref_pos.global_position
				_move_to_target(SPEED_CHASE)


func _set_state(new_state: EnemyState):
	current_state = new_state

	match current_state:

		EnemyState.IDLE:
			velocity = Vector3.ZERO
			idle_timer.start()

		EnemyState.PATROL:
			_choose_random_destination()

		EnemyState.CHASE:
			navigation_agent_3d.target_position = player_ref_pos.global_position


func _choose_random_destination():
	var destination = destination_array.pick_random()
	navigation_agent_3d.target_position = destination.global_position


func _move_to_target(speed: float):
	if navigation_agent_3d.is_navigation_finished():
		return

	var next = navigation_agent_3d.get_next_path_position()

	velocity = global_position.direction_to(next) * speed

	var look = Vector3(next.x, global_position.y, next.z)
	if !global_position.is_equal_approx(look):
		look_at(look)

	move_and_slide()


func _on_idle_timer_timeout():
	if current_state == EnemyState.IDLE:
		_set_state(EnemyState.PATROL)


func _on_navigation_agent_3d_navigation_finished():
	if current_state == EnemyState.PATROL:
		_set_state(EnemyState.IDLE)


func _on_area_3d_body_entered(body):
	if body is Player:
		saw_player = true


func _on_area_3d_body_exited(body):
	if body is Player:
		saw_player = false
