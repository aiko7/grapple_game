extends CharacterBody2D

# ——— MOVEMENT SETTINGS ———
const SPEED         = 150
const GRAVITY       = 1000
const JUMP_VELOCITY = -400
var facing_dir = 1

# cap downward speed (tweak this value to taste)
const MAX_FALL_SPEED = 700

# ——— GRAPPLE SETTINGS ———
@export var grapple_speed       = 500    # hook travel speed (px/s)
@export var pull_speed          = 400    # player pull speed (px/s)
@export var max_grapple_dist    = 200    # fixed hook range
@export var grapple_cooldown    = 1.0    # seconds between shots
@export var wall_attach_time    = 1.0    # seconds to stay attached to wall
@export var no_double_jump_level = false

# ——— WALL TYPE COLLISION LAYERS ———
const NORMAL_WALL_LAYER = 1
const INSTANT_BREAK_LAYER = 2
const NO_GRAPPLE_LAYER = 3

# ——— JUMP STATE ———
var on_ground        = false
var did_double_jump  = false

# ——— GRAPPLE STATE ———
var is_grappling       = false
var grapple_connected  = false
var grapple_point      = Vector2.ZERO
var hook_position      = Vector2.ZERO
var flight_distance    = 0.0
var grapple_cool_timer = 0.0
var missed_grapple_timer = 0.0
var wall_attach_timer = 0.0
var is_attached_to_wall = false
var current_wall_type = NORMAL_WALL_LAYER

# ——— Animation STATE ———
var idle = true
var run = false
var jump = false

# ——— NODE REFERENCES ———
@onready var rope = $Line2D
@export var anim_tree : AnimationTree

func _ready():
	add_to_group("player")
	GameManager.start_level()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if grapple_cool_timer > 0 or is_grappling:
			return

		var dir = (get_global_mouse_position() - global_position).normalized()
		var target = global_position + dir * max_grapple_dist

		var space = get_world_2d().direct_space_state
		var params = PhysicsRayQueryParameters2D.new()
		params.from = global_position
		params.to = target
		params.exclude = [self]
		params.collision_mask = (1 << (NORMAL_WALL_LAYER - 1)) | (1 << (INSTANT_BREAK_LAYER - 1)) | (1 << (NO_GRAPPLE_LAYER - 1))
		var result = space.intersect_ray(params)

		is_grappling = true
		hook_position = global_position
		flight_distance = 0
		grapple_cool_timer = grapple_cooldown
		missed_grapple_timer = 0.0
		wall_attach_timer = 0.0
		is_attached_to_wall = false

		if result.has("position"):
			grapple_point = result.position
			var collider = result.collider
			if collider.has_method("get_collision_layer_value"):
				if collider.get_collision_layer_value(NO_GRAPPLE_LAYER):
					current_wall_type = NO_GRAPPLE_LAYER
					grapple_connected = false
				elif collider.get_collision_layer_value(INSTANT_BREAK_LAYER):
					current_wall_type = INSTANT_BREAK_LAYER
					grapple_connected = true
				else:
					current_wall_type = NORMAL_WALL_LAYER
					grapple_connected = true
			else:
				var layer = collider.tile_set.get_physics_layer_collision_layer(0)
				if layer & (1 << (NO_GRAPPLE_LAYER - 1)):
					current_wall_type = NO_GRAPPLE_LAYER
					grapple_connected = false
				elif layer & (1 << (INSTANT_BREAK_LAYER - 1)):
					current_wall_type = INSTANT_BREAK_LAYER
					grapple_connected = true
				else:
					current_wall_type = NORMAL_WALL_LAYER
					grapple_connected = true
		else:
			grapple_connected = false
			grapple_point = target
			current_wall_type = NORMAL_WALL_LAYER

func update_anim():
	if is_on_floor(): 
		jump = false
		if velocity.length() == 0:
			idle = true
			run = false
		else:
			idle = false
			run = true
	else:
		jump = true
		run = false
		idle = false
		
	anim_tree.set("parameters/conditions/Idle", idle)
	anim_tree.set("parameters/conditions/Run", run)
	anim_tree.set("parameters/conditions/Jump", jump)
	
	anim_tree.set("parameters/Idle/blend_position", facing_dir)
	anim_tree.set("parameters/Run/blend_position", velocity.x)
	anim_tree.set("parameters/Jump/blend_position", facing_dir)

func die():
	print("Player died!")
	if get_tree()!=null:
		get_tree().reload_current_scene()		
	else:
		call_deferred("_reload_scene_deferred")

func _reload_scene_deferred():
	get_tree().reload_current_scene()

# helper to cap only downward velocity (positive y)
func _cap_fall_speed() -> void:
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func _physics_process(delta):
	# ——— UPDATE ANIMATIONS ———
	update_anim()
	
	# ——— UPDATE COOLDOWN ———
	if grapple_cool_timer > 0:
		grapple_cool_timer = max(grapple_cool_timer - delta, 0)

	# ——— GRAPPLE MODE ———
	if is_grappling:
		# Apply gravity while hook is flying (before connection)
		if not (grapple_connected and hook_position == grapple_point):
			velocity.y += GRAVITY * delta
			_cap_fall_speed()                 # clamp here

		# Allow horizontal movement only while hook is flying (before connection)
		if not (grapple_connected and hook_position == grapple_point):
			var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			var accel = 2000.0
			var friction = 1800.0
			var max_speed = SPEED

			if dir_x != 0:
				velocity.x = move_toward(velocity.x, dir_x * max_speed, accel * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, friction * delta)

		# manual break on jump
		if Input.is_action_just_pressed("jump"):
			if grapple_connected and not is_attached_to_wall:
				did_double_jump = false
			
			is_grappling = false
			is_attached_to_wall = false
			wall_attach_timer = 0.0
			_cap_fall_speed()                 # ensure clamp before physics step
			move_and_slide()
			return

		# move hook towards grapple_point
		var to_target = grapple_point - hook_position
		var step = grapple_speed * delta

		if to_target.length() > step:
			var move_vec = to_target.normalized() * step
			hook_position += move_vec
			flight_distance += move_vec.length()
		else:
			hook_position = grapple_point
			flight_distance += to_target.length()

			if not grapple_connected:
				is_grappling = false

		# if latched, pull player or handle wall attachment
		if grapple_connected and hook_position == grapple_point:
			var distance_to_wall = global_position.distance_to(grapple_point)
			
			if distance_to_wall > 10:
				var pull_dir = (grapple_point - global_position).normalized()
				velocity = pull_dir * pull_speed
				_cap_fall_speed()               # clamp after setting pull velocity
				is_attached_to_wall = false
				wall_attach_timer = 0.0
			else:
				if not is_attached_to_wall:
					is_attached_to_wall = true
					if current_wall_type == INSTANT_BREAK_LAYER:
						wall_attach_timer = 0.0
					else:
						wall_attach_timer = wall_attach_time
				
				if current_wall_type == NORMAL_WALL_LAYER:
					wall_attach_timer -= delta
				
				if current_wall_type != INSTANT_BREAK_LAYER or wall_attach_timer > 0:
					velocity = Vector2.ZERO
				
				if wall_attach_timer <= 0.0:
					is_grappling = false
					is_attached_to_wall = false
					wall_attach_timer = 0.0

		# draw rope line
		rope.points = [
			Vector2.ZERO,
			hook_position - global_position
		]

		_cap_fall_speed()                     # final clamp before physics step in grapple mode
		move_and_slide()
		return


	# ——— NORMAL MOVEMENT & JUMPING ———
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		_cap_fall_speed()                     # clamp during normal fall
	else:
		velocity.y = 0

	if is_on_floor():
		on_ground = true
		did_double_jump = false
	elif on_ground:
		on_ground = false
		did_double_jump = false

	# horizontal momentum-based movement
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir_x != 0:
		facing_dir = dir_x

	var accel = 2000.0
	var friction = 1800.0
	var max_speed = SPEED

	if dir_x != 0:
		velocity.x = move_toward(velocity.x, dir_x * max_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	if Input.is_action_just_pressed("jump"):
		if on_ground:
			velocity.y = JUMP_VELOCITY
			on_ground = false
		elif not did_double_jump and not no_double_jump_level:
			velocity.y = JUMP_VELOCITY
			did_double_jump = true

	rope.points = []
	_cap_fall_speed()                         # one last clamp before the physics step
	move_and_slide()
