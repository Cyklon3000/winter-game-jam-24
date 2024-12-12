extends Node3D

@export var materialOptions: Array[StandardMaterial3D]
@onready var paper: MeshInstance3D = $Present_Paper
@onready var ribbon: MeshInstance3D = $Present_Ribbon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_parent().name)
	var index: Array[int] = [0, 1, 2, 3, 4]
	
	print("paper: " + str(paper))
	print("ribbon: " + str(ribbon))
	print(materialOptions)

	paper.set_surface_override_material(
		0, 
		materialOptions[index.pop_at(randi() % 5)]
	)
	ribbon.set_surface_override_material(
		0, 
		materialOptions[index.pop_at(randi() % 5)]
	)
