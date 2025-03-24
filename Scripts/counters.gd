extends Node2D

@onready var mouse = $"../Mouse"
@onready var GRID_SIZE = mouse.GRID_SIZE
@onready var counter_radius = mouse.counter_radius

func _draw():
	for counter in mouse.counters:
		if counter[1] == true:
			draw_circle(counter[0], counter_radius, Color.BLACK)
		else:
			draw_circle(counter[0], counter_radius, Color.WHITE)
