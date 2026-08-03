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

var SPEED: float = 4.0
var current_state:EnemyState = EnemyState.IDLE
var current_destination

#stats
var angry: bool = false
const SPEED_WALK: float = 2.0
const SPEED_CHASE: float = 4.0

func _ready() -> void:
	_set_state(EnemyState.IDLE)

func _set_state(new_state: EnemyState) -> void:
	current_state = new_state
	
	match current_state:
		EnemyState.IDLE:
			idle_timer.start()
		EnemyState.PATROL:
			pass
		EnemyState.CHASE:
			if angry == true:
				SPEED = 4.0
			else:
				SPEED = 2.0

func _physics_process(_delta: float) -> void:
	_apply_status()

	if angry:
		navigation_agent_3d.target_position = player_ref_pos.global_position
	
	match current_state:
		EnemyState.IDLE:
			pass
		
		EnemyState.PATROL:
			_speed_to_target(SPEED_WALK)
		
		EnemyState.CHASE:
			_speed_to_target(SPEED_CHASE)

func _on_idle_timer_timeout() -> void:
	_decide_next_state()

func _decide_next_state() -> void:
	if current_state == EnemyState.IDLE:
		_get_new_target()
		_set_state(EnemyState.PATROL)

func _get_new_target():
	if angry == false:
		#normal behavior
		current_destination = destination_array.pick_random()
	else:
		#angry
		current_destination = player_ref_pos
	
	navigation_agent_3d.target_position = current_destination.global_position
		

func _on_navigation_agent_3d_navigation_finished() -> void:
	if angry:
		return

	_set_state(EnemyState.IDLE)

func _apply_status():
	if PlayerStatus.lantern == true:
		if angry == false:
			angry = true
			navigation_agent_3d.target_position = player_ref_pos.global_position
			_set_state(EnemyState.CHASE)
	else:
		if angry == true:
			angry = false
			_set_state(EnemyState.IDLE)

func _speed_to_target(speed: float):
	var next = navigation_agent_3d.get_next_path_position()
	velocity = global_position.direction_to(next) * speed

	var look = Vector3(next.x, global_position.y, next.z)
	if !global_position.is_equal_approx(look):
		look_at(look)

	move_and_slide()
