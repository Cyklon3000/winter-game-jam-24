extends MeshInstance3D

var camera:Camera3D
var globeSize:float
var materialInstance:StandardMaterial3D

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	globeSize = get_parent_node_3d().orbitDistance
	
	materialInstance = mesh.surface_get_material(0)


func _process(delta: float) -> void:
	# Make glass fade away when camera is getting closer
	var distance = (camera.position - position).length()
	materialInstance.albedo_color.a = clampf(lerpf(0.1, 0, inverse_lerp(2*globeSize, globeSize, distance)), 0, 1)
