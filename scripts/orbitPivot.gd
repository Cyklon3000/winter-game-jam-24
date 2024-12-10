extends Camera3D

var currentPivot: Node3D # The pivot to orbit around

var orbitTarget: Vector3
var orbitDistance: float
@export var rotationSpeed: float = 0.015
var dampingProgress: float = 0
@export var dampingSpeed: float = 2

var rotationVelocity: Vector2 = Vector2.ZERO

func _ready():
	_set_new_pivot_(get_node("../SnowGlobe"))

func _set_new_pivot_(pivot: Node3D):
	currentPivot = pivot

	orbitTarget = currentPivot.global_position + currentPivot.orbitPivot
	orbitDistance = currentPivot.orbitDistance

func _get_height_clamp_(orbitDistance:float) -> Array[float]:
	return [
		orbitTarget.y + currentPivot.heightClamp[0] * orbitDistance, 
		orbitTarget.y + currentPivot.heightClamp[1] * orbitDistance
	]

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
	position += transform.basis.x.normalized() * rotationVelocity.x * ease(1-dampingProgress, 0.8)
	position -= transform.basis.y.normalized() * rotationVelocity.y * ease(1-dampingProgress, 0.8)

	# Limit Movement in height
	var heightClamp:Array[float] = _get_height_clamp_(orbitDistance)
	if position.y < heightClamp[0]:
		position.y = heightClamp[0]
	if position.y > heightClamp[1]:
		position.y = heightClamp[1]

	look_at(orbitTarget, Vector3.UP) # Does always look at (0,0,0)

	# Fix distance from target to orbitDistance
	position = orbitTarget + (position - orbitTarget).normalized() * orbitDistance
