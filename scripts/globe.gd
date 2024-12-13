class_name Globe
extends Node3D

@onready var orbitPivot: Vector3 = $Pivot.global_position
@export var pivotDepth: int = 1
@export var orbitDistance: float = 7.0
var heightClamp: Array[float] = [0.05, 0.7]

@onready var particles:GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	# Scale Snow According to own size	
	var processMaterial: ParticleProcessMaterial = particles.process_material.duplicate()
	
	var globeScale: float = get_global_transform().basis.get_scale().x
	processMaterial.scale_min = (globeScale / 1.15) / 10
	processMaterial.scale_max = (globeScale * 1.15) / 10
	processMaterial.gravity *= globeScale * Vector3.DOWN
	
	particles.process_material = processMaterial

func start_snow() -> void:
	particles.emitting = true
