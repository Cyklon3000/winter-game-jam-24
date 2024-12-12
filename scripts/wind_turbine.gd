extends Node

@export var turnSpeed: float
var isTurning = false
@onready var turbineNob:MeshInstance3D = $WindTurbine_Nob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not isTurning: return
	turbineNob.rotate_z(delta * turnSpeed)


func start_action() -> void:
	isTurning = true
