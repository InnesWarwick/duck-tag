extends CharacterBody2D


const SPEED = 125.0
const JUMP_VELOCITY = -215
const ACCELERATION = 30
var is_caught = false
var is_immune = false
@export var up : String
@export var down : String
@export var left : String
@export var right : String

func _physics_process(delta: float) -> void:
	

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			continue
		else:
			if collider.collision_layer and is_caught == false:
				is_caught = true


	if not is_on_floor():
		if Input.is_action_pressed(up) and velocity.y > 0:
			velocity += (get_gravity() * delta) / 3
		else:
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed(up) and is_on_floor():
		velocity.y = move_toward(JUMP_VELOCITY, 0, JUMP_VELOCITY / 4)

	var direction := Input.get_axis(left, right)
	if direction:
		var target_speed = direction * SPEED
		velocity.x = move_toward(velocity.x, target_speed, ACCELERATION)
		$Sprite2D.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	move_and_slide()
	
func reset_duck(new_position: Vector2):
	position = new_position
	velocity = Vector2.ZERO
