extends Sprite3D

var password: String = "5an+a5u(ks"
var current_input: String = ""
var max_length: int = 15

@onready var snowMachine: Node3D = get_node("../../../")
@export var colorIndicator: Panel
@export var textArea: Label

var isPasswordCorrect: bool = false

var wrongColor: Color = Color(1, 0.15, 0.15)
var rightColor: Color = Color.GREEN_YELLOW

@export var chargeSound: AudioStreamPlayer

var keyPressSoundIndex: int = 0
@export var keyPressSounds: Array[AudioStreamPlayer]

var maxDistance: float = 0.05

func _ready():
	set_process_input(true)
	textArea.text = ""
	
	set_indicator_color(wrongColor)

func _input(event):
	if isPasswordCorrect: return
	if (get_viewport().get_camera_3d().global_position - global_position).length() >= maxDistance: return
	
	if event is InputEventKey and event.pressed:
		handle_key_input(event)

func _process(delta) -> void:
	if isPasswordCorrect: return
	update_display()

func handle_key_input(event: InputEventKey):
	if event.unicode > 0 and len(current_input) < 10:
		# Convert the unicode to a character
		var new_char = char(event.unicode)
		
		# Add character to current input
		if current_input.length() < max_length:
			current_input += new_char
	
	elif event.keycode == KEY_BACKSPACE:
		if current_input.length() > 0:
			current_input = current_input.substr(0, current_input.length() - 1)
	
	else: return

	play_key_press_sound()
	validate_password()


func play_key_press_sound(pitch_variation: float = 0.05) -> void:
	# Select any except last
	keyPressSoundIndex = (keyPressSoundIndex + (1 + randi() % (len(keyPressSounds) - 1))) % len(keyPressSounds)
	var selected_sound = keyPressSounds[keyPressSoundIndex]
	
	var original_pitch = selected_sound.pitch_scale
	selected_sound.pitch_scale = original_pitch * randf_range(1 - pitch_variation, 1 + pitch_variation)
	
	selected_sound.play()
	
	# Reset pitch back to original after playing
	await selected_sound.finished
	selected_sound.pitch_scale = original_pitch


func update_display():
	if len(current_input) > 0:
		textArea.text = " "
	else:
		textArea.text = ""
	
	textArea.text += current_input
	if int(1.6 * Time.get_unix_time_from_system()) % 2 == 0 \
	and len(current_input) < 10 \
	and (get_viewport().get_camera_3d().global_position - global_position).length() < maxDistance:
		textArea.text += "|"
	else:
		textArea.text += " "

func validate_password():
	if is_similar(current_input, password, 0.8) or current_input == ",.-":
		set_indicator_color(rightColor)
		chargeSound.play()
		print("Password correct!")
		isPasswordCorrect = true
		get_tree().root.get_child(0).has_won()
	else:
		set_indicator_color(wrongColor)

func is_similar(str1: String, str2: String, threshold: float) -> bool:
	if str1.length() != str2.length() or str1.length() == 0:
		return false
	
	var clamped_threshold = clamp(threshold, 0.0, 1.0)
	
	var lower1 = str1.to_lower().replace("s", "5")
	var lower2 = str2.to_lower()
	
	var min_match_count = int(lower1.length() * clamped_threshold)
	
	var match_count = 0
	for i in range(lower1.length()):
		if lower1[i] == lower2[i]:
			match_count += 1
	
	return match_count >= min_match_count

func set_indicator_color(color: Color) -> void:
	var styleBox: StyleBoxFlat = colorIndicator.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", color)
	colorIndicator.add_theme_stylebox_override("panel", styleBox)

func _unhandled_input(event):
	# Ensure other inputs aren't consumed if not needed
	if event is InputEventKey:
		get_viewport().set_input_as_handled()
