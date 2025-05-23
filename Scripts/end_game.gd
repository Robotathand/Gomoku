extends Control

@onready var black_win = $"Black win"
@onready var white_win = $"White win"
@onready var play_again_button = $"Play again"
@onready var end_request_box = $"End request"

func _on_mouse_game_ended(winner):
	if winner:
		black_win.visible = true
	else:
		white_win.visible = true
	play_again_button.visible = true

func _on_play_again_pressed():
	black_win.visible = false
	white_win.visible = false
	play_again_button.visible = false


func _on_button_restart_pressed():
	end_request_box.visible = true

func _on_yes_pressed():
	end_request_box.visible = false

func _on_no_pressed():
	end_request_box.visible = false
