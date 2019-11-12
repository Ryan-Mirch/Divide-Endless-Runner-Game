extends Node

var speed = 100

var splitDelay = 0.1
var lastSplit = 0
var time = 0
onready var segY = get_viewport().size.y - 250
onready var botY = get_viewport().size.y
onready var centerX = get_viewport().size.x / 2

onready var borderLimit_LeftOuter = centerX - 300
onready var borderLimit_LeftInner = centerX - 20
onready var borderLimit_RightOuter = centerX + 300
onready var borderLimit_RightInner = centerX + 20


var segment = preload("res://Scenes/Segment.tscn")
var barrier = preload("res://Scenes/Barrier.tscn")
var border = preload("res://Scenes/Border.tscn")
var hazard = preload("res://Scenes/Hazard.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lastSplit +=delta
	time += delta
	
	
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
			
			
func getCurrentBorderBounds():
	
	var rightBorder
	var leftBorder
	
	for b in get_tree().get_nodes_in_group("Leading Border"):
		if b.side == -1: leftBorder = b
		if b.side == 1: rightBorder = b
		
	var LP1 = leftBorder.get_point_position(0) + leftBorder.position
	var LP2 = leftBorder.get_point_position(1) + leftBorder.position
	
	var RP1 = rightBorder.get_point_position(0) + rightBorder.position
	var RP2 = rightBorder.get_point_position(1) + rightBorder.position
	
	
	
	var leftBound = calculateXIntercept(LP1, calculateSlope(LP1,LP2))
	var rightBound = calculateXIntercept(RP1, calculateSlope(RP1,RP2))
	
	print([leftBound, rightBound])
	
	return [leftBound, rightBound]
	
func calculateSlope(P1, P2):
	var x1 = P1.x
	var y1 = P1.y
	var x2 = P2.x
	var y2 = P2.y
	
	if x2-x1 == 0:
		return 0
	
	return (y2-y1)/(x2-x1)
	
func calculateXIntercept(P1, m):
	if m == 0:
		return P1.x
		
	var b = P1.y - m*P1.x
	return (0 - b)/m
	
	