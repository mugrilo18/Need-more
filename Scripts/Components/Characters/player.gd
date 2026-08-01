extends CharacterBody3D
class_name Player

@export var head: Node3D
@export var grabbed_anchor: Marker3D
@export var object_grabbed_shape_cast: ShapeCast3D
@export var lantern: OmniLight3D

const JUMP_VELOCITY = 4.5

var speed: float = 5.0
var grabbed_object: Pickable = null
var mouse_sens: float = 0.005

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	lantern.visible = false

func _physics_process(delta: float) -> void:
	_player_movement(delta)
	_move_grab_object(delta)
	_lantern()

func _input(event: InputEvent) -> void:
	_camera_movement(event)
	_grab_object(event)

func _player_movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = 10.0
	else:
		speed = 5.0
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _camera_movement(event):
	if event is InputEventMouseMotion:
		var y_rot: float = -event.relative.x * mouse_sens
		rotate_y(y_rot)
		
		var x_tilt: float = -event.relative.y * mouse_sens
		head.rotate_x(x_tilt)
	

func _try_grabbibng(collided: Pickable):
	grabbed_object = collided

func _throw_object():
	grabbed_object.apply_impulse((-head.global_basis.z * 5.0) + Vector3(0.0, 2.0, 0.0))
	grabbed_object = null

func _grab_object(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("interact"):
			if grabbed_object:
				grabbed_object = null
			elif object_grabbed_shape_cast.is_colliding():
				var collided = object_grabbed_shape_cast.get_collision_result()[0]["collider"]
				if collided is Pickable:
					if !grabbed_object:
						_try_grabbibng(collided)
		elif Input.is_action_just_pressed("throw"):
			if grabbed_object:
				_throw_object()

func _move_grab_object(delta):
	if !grabbed_object:
		return
	
	var target_pos: Vector3 = grabbed_anchor.global_position
	var current_pos: Vector3 = grabbed_object.global_position
	
	var direction = target_pos - current_pos
	
	var required_velocity = direction / delta
	
	grabbed_object.linear_velocity = required_velocity
	
	grabbed_object.angular_velocity *= 0.5

func _lantern():
	if PlayerStatus.lantern == true:
		lantern.visible = true
	elif PlayerStatus.lantern == false:
		lantern.visible = false
