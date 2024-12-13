extends Node3D

@export var materialOptions: Array[StandardMaterial3D]
@onready var paper: MeshInstance3D = $Present_Paper
@onready var ribbon: MeshInstance3D = $Present_Ribbon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index: Array[int] = [0, 1, 2, 3, 4]
	
	var randomIndex: int = randi() % 5
	var paperMaterial: StandardMaterial3D = materialOptions[randomIndex]
	
	randomIndex = (randomIndex + (2 * (randi() % 2)) - 1) % 5
	var ribbonMaterial: StandardMaterial3D = materialOptions[randomIndex]

	paper.set_surface_override_material(
		0, 
		paperMaterial
	)
	ribbon.set_surface_override_material(
		0, 
		ribbonMaterial
	)
