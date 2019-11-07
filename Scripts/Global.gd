extends Node

var speed = 100

var splitDelay = 0.1
var lastSplit = 0
onready var segY = get_viewport().size.y - 250


var segment = preload("res://Scenes/Segment.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastSplit +=delta
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if lastSplit > splitDelay:
			lastSplit = 0
			var split = true
			for n in get_tree().get_nodes_in_group("Leading"):
				if n.direction != 0:
					split = false
			
			if split: 
				for n in get_tree().get_nodes_in_group("Leading"):
					n.split()
						
				
				
			else: if !split: 
				for n in get_tree().get_nodes_in_group("Leading"):
					n.straighten()
			
			