extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_open.png"),
		Input.CURSOR_ARROW,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_closed.png"),
		Input.CURSOR_MOVE,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/message_dots_round.png"),
		Input.CURSOR_HELP,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/hand_point.png"),
		Input.CURSOR_POINTING_HAND,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/backpack.png"),
		Input.CURSOR_VSIZE,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/target_round_a.png"),
		Input.CURSOR_CROSS,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/look_b.png"),
		Input.CURSOR_CAN_DROP,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/tool_wrench.png"),
		Input.CURSOR_FORBIDDEN,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/bracket_a_vertical.png"),
		Input.CURSOR_IBEAM,
		Vector2(16, 16)
	)
	Input.set_custom_mouse_cursor(
		load("res://textures/cursors/disabled.png"),
		Input.CURSOR_WAIT,
		Vector2(16, 16)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
