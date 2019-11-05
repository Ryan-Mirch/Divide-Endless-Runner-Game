extends Node

var speed = 50

var splitDelay = 0.5 
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
			for n in get_tree().get_nodes_in_group("Segment"):
				if n.direction != 0 && n.leading:
					split = false
			
			if split: 
				for n in get_tree().get_nodes_in_group("Segment"):
					if n.leading:
						n.split()
				
				
			else: if !split: 
				for n in get_tree().get_nodes_in_group("Segment"):
					if n.leading:
						n.straighten(-1)
			
			