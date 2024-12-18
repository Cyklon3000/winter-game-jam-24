extends MeshInstance3D

var camera:Camera3D
var globeSize:float
var materialInstance:StandardMaterial3D
var pivot: Vector3

func _ready() -> void:
	var parent: Globe = get_parent()
	camera = get_viewport().get_camera_3d()
	globeSize = parent.orbitDistance * parent.get_global_transform().basis.get_scale().x
	pivot = parent.orbitPivot
	
	materialInstance = mesh.surface_get_material(0).duplicate()
	set_surface_override_material(0, materialInstance)


func _process(delta: float) -> void:
	# Make glass fade away when camera is getting closer
	var distance = (camera.global_position - global_position).length()
	materialInstance.albedo_color.a = 0.15 * clampf(inverse_lerp(globeSize, 2*globeSize, distance), 0, 1)
