extends Camera3D

var allowedPivotDepth: int = 1
var currentPivot: Node3D # The pivot to orbit around

@onready var largestSnowglobe: Node3D = %SnowGlobe1

var orbitTarget: Vector3 = Vector3.ZERO
var orbitDistance: float
var minOrbitDistance: float = 0.014
var maxOrbitDistance: float = 1300
@export var rotationSpeed: float = 0.00175
var dampingProgress: float = 0
@export var dampingSpeed: float = 2
var rotationVelocity: Vector2 = Vector2.ZERO

var wasDraggingLastTime: bool = false
var wasHoveringGlobeLastTime: bool = false

var lastRaycastResult:Dictionary
var isRaycastActive:bool = true

func _ready():
	set_new_pivot(largestSnowglobe)
	orbitTarget = largestSnowglobe.get_node("Pivot").global_position


func set_new_pivot(pivot: Globe):
	if pivot != null:
		currentPivot = pivot

	orbitTarget = currentPivot.orbitPivot
	orbitDistance = (orbitTarget - position).length()


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
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
		wasDraggingLastTime = true
	elif wasDraggingLastTime:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		wasDraggingLastTime = false
	
	# Orbit Size (Scroll)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		orbitDistance *= 1.020
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		orbitDistance /= 1.020
	orbitDistance = clamp(orbitDistance, minOrbitDistance, maxOrbitDistance)
	
	# Change Pivot (Left Click)
	var hoveredObject = get_last_raycast_object()
	if hoveredObject is Globe and hoveredObject != currentPivot:
		var hoveredGlobe: Globe = hoveredObject
		
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		wasHoveringGlobeLastTime = true
		
		if allowedPivotDepth < hoveredGlobe.pivotDepth:
			Input.set_default_cursor_shape(Input.CURSOR_WAIT)
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("New pivot object: ", hoveredGlobe.name)
			set_new_pivot(hoveredGlobe)
		
	elif wasHoveringGlobeLastTime:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		wasHoveringGlobeLastTime = false


func _orbit_pivot_(delta: float) -> void:
	# Apply Orbit Movement 
	dampingProgress += delta * dampingSpeed
	position += transform.basis.x.normalized() * rotationVelocity.x * ease(1-dampingProgress, 0.8) * orbitDistance
	position -= transform.basis.y.normalized() * rotationVelocity.y * ease(1-dampingProgress, 0.8) * orbitDistance

	 # Limit Movement in height
	var heightClamp:Array[float] = _get_height_clamp_(orbitDistance)
	if position.y < heightClamp[0]:
		position.y = heightClamp[0]
	if position.y > heightClamp[1]:
		position.y = heightClamp[1]

	look_at(orbitTarget, Vector3.UP) # Does always look at (0,0,0)

	# Fix distance from target to orbitDistance
	position = orbitTarget + (position - orbitTarget).normalized() * orbitDistance


func _raycast_() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 10000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	lastRaycastResult = space_state.intersect_ray(query)


func get_last_raycast_object() -> Node3D:
	if not lastRaycastResult or not isRaycastActive:
		return null
	return lastRaycastResult["collider"].get_parent()


func _process(delta):
	_orbit_pivot_(delta)
	_raycast_()
