extends Control

var areaText:String = ""
@onready var textArea:Label = %TextArea
var isAnimating:bool = false
var animationProgress:float = 0
var animationDuration:float = 0
var animationFrame:int = 0

@onready var button:Button = %ContinueButton

@onready var portrait:TextureRect = %Portrait

@onready var sound1:AudioStreamPlayer = $Sounds/Plop1
@onready var sound2:AudioStreamPlayer = $Sounds/Plop2
@onready var sound3:AudioStreamPlayer = $Sounds/Plop3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_animate_dialoge_(delta)
	_unlock_button_()
	

func _unlock_button_() -> void:
	if isAnimating: return
	button.disabled = false


func _animate_dialoge_(delta: float) -> void:
	if not isAnimating: return
	animationProgress += delta
	
	var progress: float = inverse_lerp(0, animationDuration, animationProgress)
	var slowDownCount: int = max(1, int(animationDuration * 3.5))
	var textRange: int = int(len(areaText) * staircase_sin(progress, slowDownCount, 0.35))
	var newAreaText: String = areaText.substr(0, textRange)
	
	if textArea.text != newAreaText:
		textArea.text = newAreaText
		
		# Only every second frames and gap at spaces
		if is_alphanumeric(get_ending(newAreaText, 3)) and (animationFrame % 2 == 0 or animationFrame % 3 == 1):
			play_random_plop()
		
		animationFrame += 1
	
	if animationProgress >= animationDuration:
		isAnimating = false


var lastDialoge: Array[String]
var lastDialogeProgress: int 

func show_dialoge(dialoge: Array[String], dialogeProgress: int, duration: float = -1) -> void:
	lastDialoge = dialoge
	lastDialogeProgress = dialogeProgress
	
	areaText = dialoge[dialogeProgress]
	textArea.text = ""
	isAnimating = true
	animationProgress = -0.4 # Wait 0.4 seconds before letters
	
	animationDuration = duration
	if duration == -1:
		animationDuration = len(areaText) * 0.025
	
	visible = true
	get_viewport().get_camera_3d().isRaycastActive = false
	print("Raycasts diabled")
	
	button.disabled = true


func set_portrait(newPortrait:Texture2D) -> void:
	portrait.texture = newPortrait


func play_random_plop(pitch_variation: float = 0.05) -> void:
	# Create an array of sound nodes
	var sounds = [sound1, sound2, sound3]
	
	# Randomly select a sound
	var selected_sound = sounds[randi() % sounds.size()]
	
	# Randomize pitch
	var original_pitch = selected_sound.pitch_scale
	selected_sound.pitch_scale = original_pitch * randf_range(1 - pitch_variation, 1 + pitch_variation)
	
	# Reduce Volume
	selected_sound.volume_db = -18
	
	# Play the selected sound
	selected_sound.play()
	
	# Reset pitch back to original after playing
	# This ensures the next play will start with the base pitch again
	await selected_sound.finished
	selected_sound.pitch_scale = original_pitch


func staircase_sin(t:float, n:int, smooth:float=0) -> float:
	"""
	A function that aproximates return t, that has n "steps" in the interval [0, 1]
	smooth:float ([0, 1]) smooths the staircase until it equates return t
	"""
	return clamp((1-smooth) * (0.5 * (sin(2*PI*n*t) / (PI*n) + 2*t)) + smooth*t, 0, 1)


func is_alphanumeric(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]+$")
	return regex.search(text) != null


func get_ending(input_string: String, n: int) -> String:
	n = min(n, input_string.length())
	return input_string.substr(input_string.length() - n, n)


func _on_continue_button_pressed() -> void:
	visible = false
	get_viewport().get_camera_3d().isRaycastActive = true
	print("Raycasts enabled")
	
	if lastDialogeProgress == len(lastDialoge) - 1:
		print("Unlocking next Globe")
		# Unlock next Globe
		get_viewport().get_camera_3d().allowedPivotDepth += 1
