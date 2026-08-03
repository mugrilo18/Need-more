extends CharacterBody3D
class_name Enemy

@export var destination_array: Array[Marker3D]
@export var player_ref_pos: Marker3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var idle_timer: Timer = $IdleTimer

enum EnemyState {
	IDLE,
	WALKING
}

var SPEED: float = 4.0
var current_state:EnemyState = EnemyState.IDLE
var current_destination

#stats
var angry: bool = false

func _ready() -> void:
	_set_state(EnemyState.IDLE)

func _set_state(new_state: EnemyState) -> void:
	current_state = new_state
	
	match current_state:
		EnemyState.IDLE:
			idle_timer.start()
		EnemyState.WALKING:
			if angry == true:
				SPEED = 4.0
			else:
				SPEED = 2.0

func _physics_process(_delta: float) -> void:
	match current_state:
		EnemyState.IDLE:
			pass
		EnemyState.WALKING:
			var next_path_pos: Vector3 = navigation_agent_3d.get_next_path_position()
			var new_velocity: Vector3 = global_position.direction_to(next_path_pos) * SPEED
			velocity = new_velocity
			var look_at_target: Vector3 = Vector3(next_path_pos.x, global_position.y, next_path_pos.z)
			if not global_position.is_equal_approx(look_at_target):
				look_at(look_at_target)
			
			move_and_slide()
	
	_apply_status()

func _on_idle_timer_timeout() -> void:
	_decide_next_state()

func _decide_next_state() -> void:
	if current_state == EnemyState.IDLE:
		_get_new_target()
		_set_state(EnemyState.WALKING)

func _get_new_target():
	if angry == false:
		#normal behavior
		current_destination = destination_array.pick_random()
	else:
		#angry
		current_destination = player_ref_pos
	
	navigation_agent_3d.target_position = current_destination.global_position
		

func _on_navigation_agent_3d_navigation_finished() -> void:
	if current_destination == player_ref_pos:
		angry = false
	_set_state(EnemyState.IDLE)

func _apply_status():
	if PlayerStatus.lantern == true:
		angry = true
	else:
		angry = false
