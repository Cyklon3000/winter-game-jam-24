extends Node

var wasHoveredLastTime: bool = false

@export var dialoge: Array[String] = []
@export var dialogeSprite: Texture2D
@onready var dialogeManager: Control = %DialogeManager
var dialogeProgress: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if not _is_hovered_(): return
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	dialogeManager.set_portrait(dialogeSprite)
	dialogeManager.show_dialoge(dialoge, dialogeProgress)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_hovered_():
		Input.set_default_cursor_shape(Input.CURSOR_HELP)
		wasHoveredLastTime = true
	elif wasHoveredLastTime:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		wasHoveredLastTime = false
		

func _is_hovered_() -> bool:
	var hovered_object: Node3D = get_viewport().get_camera_3d().get_last_raycast_object()
	return hovered_object == self


func start_action() -> void:
	dialogeProgress = min(dialogeProgress+1, len(dialoge))
