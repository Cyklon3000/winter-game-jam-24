extends Node3D

var startedSince: float = 0
@onready var thanksMessage: Control = $ThanksMessage

var hasWon: bool = false
var wonSince: float = 0

@onready var camera: Camera3D = get_viewport().get_camera_3d()

var snowColor: Color = Color(0.871, 0.918, 0.937)
var snowAnimationDuration: float = 8.0 
@export var snowifyMaterials: Array[StandardMaterial3D]
var snowifyMaterialsOriginalAlbedo: Array[Color]

var zoomSpeed: float = 0.3

var lightingAnimationDuration: float = 37.5
var lightingAnimationMultplier: float = 0.25
var lightingFadeOutDuration: float = 1.75
@onready var worldEnviornment: WorldEnvironment = $WorldEnvironment
@onready var directionalLight: DirectionalLight3D = $DirectionalLight3D
@onready var welcomeMessage: Control = $WelcomeMessage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialise_cursors()
	
	initialise_animation()


func initialise_cursors() -> void:
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_open.png"),
		Input.CURSOR_ARROW,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_closed.png"),
		Input.CURSOR_MOVE,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/message_dots_round.png"),
		Input.CURSOR_HELP,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_point.png"),
		Input.CURSOR_POINTING_HAND,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/backpack.png"),
		Input.CURSOR_VSIZE,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/target_round_a.png"),
		Input.CURSOR_CROSS,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/look_b.png"),
		Input.CURSOR_CAN_DROP,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/tool_wrench.png"),
		Input.CURSOR_FORBIDDEN,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/bracket_a_vertical.png"),
		Input.CURSOR_IBEAM,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/disabled.png"),
		Input.CURSOR_WAIT,
		Vector2(16, 16)
	)
	print("Cursors instatiated")


func initialise_animation() -> void:
	camera.isRaycastActive = false
	
	for material: StandardMaterial3D in snowifyMaterials:
		snowifyMaterialsOriginalAlbedo.append(material.albedo_color)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if startedSince < 6:
		startedSince += delta
		animate_welcome_message()
	
	if hasWon:
		wonSince += delta
		
		animate_snow()
		animate_zoom(delta)
		animate_lighting()


func animate_welcome_message() -> void:
	welcomeMessage.modulate.a = clamp(inverse_lerp(6, 5, startedSince), 0, 1)
	
	if startedSince >= 6:
		camera.isRaycastActive = true


func animate_snow() -> void:	
	var snowAnimationProgress: float = clampf(inverse_lerp(0, snowAnimationDuration, wonSince), 0, 1)
	
	for index in range(len(snowifyMaterials)):
		var snowifyMaterial: StandardMaterial3D = snowifyMaterials[index]
		var initialAlbedo: Color = snowifyMaterialsOriginalAlbedo[index]
		
		snowifyMaterial.albedo_color = initialAlbedo.lerp(snowColor, snowAnimationProgress)


func animate_zoom(delta: float) -> void:
	camera.orbitDistance += camera.orbitDistance * zoomSpeed * delta

func animate_lighting() -> void:
	var lightingAnimationProgress: float = clampf(inverse_lerp(0, lightingAnimationDuration, wonSince), 0, 1)
	
	var energy: float = lerpf(1, lightingAnimationMultplier, ease(lightingAnimationProgress, .8))
	worldEnviornment.environment.set("background_energy_multiplier", energy)
	worldEnviornment.environment.set("ambient_light_energy", energy)
	directionalLight.light_energy = energy
	
	if lightingAnimationProgress < 1: return
	# Fade out
	lightingAnimationProgress = clampf(
		inverse_lerp(lightingAnimationDuration, lightingAnimationDuration + lightingFadeOutDuration, wonSince),
		0, 1)
		
	energy = lerpf(lightingAnimationMultplier, 0, lightingAnimationProgress)
	worldEnviornment.environment.set("background_energy_multiplier", energy)
	worldEnviornment.environment.set("ambient_light_energy", energy)
	directionalLight.light_energy = energy
	
	thanksMessage.modulate.a = lightingAnimationProgress


func start_snow() -> void:
	var snowGlobes: Array[Node] = get_tree().get_nodes_in_group("SnowGlobe")
	
	for snowGlobe: Globe in snowGlobes:
		snowGlobe.start_snow()


func has_won() -> void:
	hasWon = true
	get_viewport().get_camera_3d().isRaycastActive = false
	
	start_snow()
	
	camera.position = Vector3(212.9792, 752.366, 291.236) # Start position
	camera.set_new_pivot(%SnowGlobe5)
