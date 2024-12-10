class_name Globe
extends Node3D

@export var orbitPivot:Vector3 = Vector3.ZERO
@export var orbitDistance:float = 7.0
var heightClamp:Array[float] = [0.1, 0.8]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
