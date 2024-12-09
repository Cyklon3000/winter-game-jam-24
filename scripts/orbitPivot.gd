extends Camera3D

var currentPivot: StaticBody3D # The pivot to orbit around

var orbitTarget: Vector3
var orbitDistance: float
@export var rotationSpeed: float = 0.015
var dampingProgress: float = 0
@export var dampingSpeed: float = 2

var rotationVelocity: Vector2 = Vector2.ZERO

var heightClamp: Array[float]

func _ready():
	_set_new_pivot_(get_node("../SnowGlobe2"))

func _set_new_pivot_(pivot: StaticBody3D):
	currentPivot = pivot

	orbitTarget = currentPivot.global_position + currentPivot.orbitPivot
	orbitDistance = currentPivot.orbitDistance
	heightClamp = currentPivot.heightClamp

func _input(event: InputEvent) -> void:	
	# Orbit Movement (Right Click Drag)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotationVelocity.x = -event.relative.x * rotationSpeed
		rotationVelocity.y = -event.relative.y * rotationSpeed
		dampingProgress = 0
	
	# Orbit Size (Scroll)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		orbitDistance *= 1.1
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		orbitDistance /= 1.1
	
	# Change Pivot (Left Click)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var camera = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 1000
			
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from, to)
			
			var result = space_state.intersect_ray(query)
			
			if result:
				var clicked_object = result["collider"]
				if clicked_object is Globe and clicked_object != currentPivot:
					print("New pivot object: ", clicked_object.name)
					_set_new_pivot_(clicked_object)

func _process(delta):
	# Apply Orbit Movement 
	dampingProgress += delta * dampingSpeed
	position += transform.basis.x.normalized() * rotationVelocity.x * _ease_in_out_cube_(1-dampingProgress)
	position -= transform.basis.y.normalized() * rotationVelocity.y * _ease_in_out_cube_(1-dampingProgress)

	# Limit Movement in height (Not related with bug)
	#if position.y < (orbitTarget.y + heightClamp[0]) * orbitDistance:
		#position.y = (orbitTarget.y + heightClamp[0]) * orbitDistance
	#if position.y > (orbitTarget.y + heightClamp[1]) * orbitDistance:
		#position.y = (orbitTarget.y + heightClamp[1]) * orbitDistance

	look_at(orbitTarget) # Does always look at (0,0,0)
	print("look_at : " + str(orbitTarget))

	# Fix distance from target to orbitDistance
	position = (position - orbitTarget).normalized() * orbitDistance

func _ease_in_out_cube_(x:float) -> float:
	x = min(1, x)
	return max(0, 4 * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 3) / 2);
