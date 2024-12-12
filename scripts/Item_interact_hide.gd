extends Node3D

var wasHoveredLastTime: bool = false
var hasInteracted: bool = false

@export var hideObject: Node3D
@export var actionObjects: Array[Node3D]
@export var soundOnAction: AudioStreamPlayer

@export var hoverCursorShape: Input.CursorShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if not _is_hovered_(): return
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	
	if hideObject:
		hideObject.visible = false
	for actionObject: Node3D in actionObjects:
		actionObject.start_action()
	
	if soundOnAction:
		play_sound()
		
	hasInteracted = true


func play_sound() -> void:
	soundOnAction.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_hovered_():
		if hasInteracted: return
		Input.set_default_cursor_shape(hoverCursorShape)
		wasHoveredLastTime = true
	elif wasHoveredLastTime:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		wasHoveredLastTime = false


func _is_hovered_() -> bool:
	var hovered_object: Node3D = get_viewport().get_camera_3d().get_last_raycast_object()
	return hovered_object == self
