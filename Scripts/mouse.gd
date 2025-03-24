extends StaticBody2D

#region Variables
@export var BOARD_SIZE = 64*15
var GRID_SIZE = BOARD_SIZE/15
const DOUBLE_CLICK_THRESHOLD = 0.2
@export var counter_radius_factor = 2.25
@export var allow_over_five = true
var counter_radius = GRID_SIZE/counter_radius_factor

var is_black = true
var last_click_time = 0.0
var row = 0
var column = 0
var game = []
var x_position = 0
var y_position = 0
var counters = []
var ended = false
@onready var couners_node = $"../Counters"
var finished = false
#endregion

signal game_ended

func create_2d_array(r, c, v):
	var a = []
	for i in range(c):
		a.append([])
	for row in range(r):
		for col in range(c):
			a[row].append(v)
	return a

func check_win():
	var length = 0
	var colour = 0
	ended = false
	
	if is_black:
		colour = 1
	else:
		colour = 2
	
#region Horizontal
	# Horizontal left
	for i in range(column - 4, column):
		if i < 0:
			pass
		else:
			if game[row][i] == colour:
				length += 1
			else:
				length = 0
	
	# Horizontal right
	for i in range(column + 1, column + 5):
		if i > 14:
			pass
		else:
			if game[row][i] == colour:
				length += 1
			else:
				break
	
	# Horizontal
	if not ended:
		is_five(length)
#endregion
	
	length = 0
	
#region Vertical
	# Vertical up
	for i in range(row - 4, row):
		if i < 0:
			pass
		else:
			if game[i][column] == colour:
				length += 1
			else:
				length = 0
	
	# Vertical down
	for i in range(row + 1, row + 5):
		if i > 14:
			pass
		else:
			if game[i][column] == colour:
				length += 1
			else:
				break
	
	# Vertical
	if not ended:
		is_five(length)
#endregion
		
	length = 0
		
#region Diagonal left-up - right-down
	# Diagonal left-up
	for i in range(1, 5):
		if column - i < 0 or row - i < 0:
			pass
		else:
			if game[row - i][column - i] == colour:
				length += 1
			else:
				break
	
	# Diagonal right-down
	for i in range(1, 5):
		if column + i > 14 or row + i > 14:
			pass
		else:
			if game[row + i][column + i] == colour:
				length += 1
			else:
				break
	
	# Diagonal left-up - right-down
	if not ended:
		is_five(length)
#endregion
		
	length = 0
		
#region Diagonal right-up - left-down
	# Diagonal right-up
	for i in range(1, 5):
		if column + i > 14 or row - i < 0:
			pass
		else:
			if game[row - i][column + i] == colour:
				length += 1
			else:
				break
	
	# Diagonal left-down
	for i in range(1, 5):
		if column - i < 0 or row + i > 14:
			pass
		else:
			if game[row + i][column - i] == colour:
				length += 1
			else:
				break
	
	# Diagonal right-up - left-down
	if not ended:
		is_five(length)
#endregion

func is_five(l):
	if allow_over_five:
		if l >= 4:
			end_game()
			ended = true
	else:
		if l == 4:
			end_game()
			ended = true

func end_game():
	emit_signal("game_ended", is_black)
	finished = true

func place_counter():
	if row < 15 and column < 15:
		if game[row][column] == 0:
			counters.append([Vector2(x_position, y_position), is_black])
			check_win()
			if is_black == true:
				game[row][column] = 1
				is_black = false
			else:
				game[row][column] = 2
				is_black = true

func _ready():
	game = create_2d_array(15, 15, 0)

func _process(_delta):
	var mouse_position_x = get_viewport().get_mouse_position()[0]+GRID_SIZE/2
	var mouse_position_y = get_viewport().get_mouse_position()[1]+GRID_SIZE/2
	
	if (0 < mouse_position_x and mouse_position_x < 16 * GRID_SIZE) and (0 < mouse_position_y and mouse_position_y < 16 * GRID_SIZE):
		x_position = snapped(mouse_position_x, GRID_SIZE)-GRID_SIZE/2
		y_position = snapped(mouse_position_y, GRID_SIZE)-GRID_SIZE/2
		position.x = x_position
		position.y = y_position
		column = x_position/GRID_SIZE
		row = y_position/GRID_SIZE
		queue_redraw()

func _draw():
	if not finished:
		if row < 15 and column < 15 and game[row][column] == 0:
			if is_black == true:
				draw_circle(Vector2(0, 0), counter_radius, Color(0, 0, 0, 0.85))
			else:
				draw_circle(Vector2(0, 0), counter_radius, Color(255, 255, 255, 0.95))
		else:
			if is_black == true:
				draw_circle(Vector2(0, 0), counter_radius, Color(0, 0, 0, 0.2))
			else:
				draw_circle(Vector2(0, 0), counter_radius, Color(255, 255, 255, 0.2))

func _input(event):
	if not finished:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				var current_click_time = Time.get_ticks_msec()
				if current_click_time - last_click_time > DOUBLE_CLICK_THRESHOLD * 1000:
					place_counter()
				last_click_time = current_click_time
				queue_redraw()
				couners_node.queue_redraw()

func _on_play_again_pressed():
	game = create_2d_array(15, 15, 0)
	is_black = true
	last_click_time = 0.0
	row = 0
	column = 0
	x_position = 0
	y_position = 0
	counters = []
	ended = false
	finished = false
	couners_node.queue_redraw()
