extends Node3D

@onready var coil:MeshInstance3D = $Heater_Coil
var materialInstance:StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	materialInstance = coil.mesh.surface_get_material(0).duplicate()
	coil.set_surface_override_material(0, materialInstance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_action() -> void:
	materialInstance.emission_energy_multiplier = 1
