extends Node

var speed = 50

var splitDelay = 0.1
var lastSplit = 0
var split = true

onready var segment = load("res://Scenes/Segment.tscn")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastSplit +=delta
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if lastSplit > splitDelay:
			lastSplit = 0
			if split: 
				for n in get_tree().get_nodes_in_group("Segment"):
					if n.leading:
						n.split()
				
				
			else: if !split: 
				for n in get_tree().get_nodes_in_group("Segment"):
					if n.leading:
						n.straighten(-1)
						
			split = !split
			
			