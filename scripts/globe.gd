class_name Globe
extends Node3D

@onready var orbitPivot: Vector3 = $Pivot.global_position
@export var pivotDepth: int = 1
@export var orbitDistance: float = 7.0
var heightClamp: Array[float] = [0.05, 0.7]

func _ready() -> void:
	print(orbitPivot)
