extends CharacterBody2D


#used for changing camera y
var grounded_last_frame: bool = false


var double_jump_used: bool = false
var dash_used: bool = false


@export var dash_speed: int = 10000


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	
	#Check if touched ground this frame
	if is_on_floor():
		if not grounded_last_frame:
			grounded_last_frame = true
			$Camera2D.drag_vertical_enabled = false
	else:
		grounded_last_frame = false
			
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			double_jump_used = false
			dash_used = false
			print("Jump")
		else:
			if not double_jump_used:
				velocity.y = JUMP_VELOCITY
				double_jump_used = true
				print("Jump 2")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		if Input.is_action_just_pressed("Dash"):
			if not dash_used:
				velocity.x = direction * dash_speed
				dash_used = true
		else:
			velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
