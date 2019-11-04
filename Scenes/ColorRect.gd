extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spawnPoint = $"Control"

var leading = true
var direction = 0
var leftX = rect_position.x
var rightX = rect_position.x + rect_size.x
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_direction(d):
	direction = d
	rect_rotation = rect_rotation - 45*direction
	print(rect_rotation)
	if direction == 0:
		disableColliders()
	
func _process(delta):
	update_length(delta)
	
	
func update_length(delta):
	var pixelsToMove
	var speed = Global.speed
	
	pixelsToMove = (speed * (delta))
	#pixelsToMove = 1
	
	
	
	if direction == 0 && leading:
		rect_size.y += pixelsToMove
	
	
	if direction != 0 && leading:
		rect_position.x -= pixelsToMove * direction
		rect_size.y += pixelsToMove * 1.4
		
	if !leading:
		rect_position.y += pixelsToMove
		
func straighten(xPos):
	if direction == 0: return
	leading = false
	disableColliders()
	
	var seg = Global.segment.instance()
	seg.disableColliders()
	get_parent().add_child(seg)
	
	seg.rect_position = spawnPoint.get_global_position()
	
	seg.rect_position.y += 2
	
	if direction < 0:			
		seg.rect_position.x -= (rect_size.x / 2) +2
		
		
	if direction > 0:			
		seg.rect_position.x -= (rect_size.x / 2) - 1
		
	if xPos != -1:
		seg.rect_position.x = xPos
		
func split():
	if direction != 0: return
	
	leading = false
	disableColliders()
	
	var seg1 = Global.segment.instance()
	var seg2 = Global.segment.instance()
	
	get_parent().add_child(seg1)
	get_parent().add_child(seg2)
	
	seg1.rect_position = spawnPoint.get_global_position()
	seg2.rect_position = spawnPoint.get_global_position()
	
	seg1.rect_position.x -= rect_size.x / 2
	seg2.rect_position.x -= rect_size.x / 2
	
	seg1.rect_position.y += 4
	seg2.rect_position.y += 4
	
	seg1.set_direction(-1)
	seg2.set_direction(1)
		
func combine(hitXPos):	
	
	var thisXPos = $"Control".get_global_transform().origin.x	
	var xPos = ((thisXPos + hitXPos) / 2) - rect_size.x/2
	
	straighten(xPos)


func _on_AreaLeft_area_entered(area):
	if direction == -1:return
	if direction == 0:return
	
	
		
	
	disableColliders()
	leading = false


func _on_AreaRight_area_entered(area):
	if direction == 1:return
	if direction == 0:return
	if leading == false:return
	
	disableColliders()
	leading = false
	
	if area.is_in_group("Barrier"): return
	
	var xPos = area.get_parent().get_global_transform().origin.x
	print(xPos)
	
	combine(xPos)
	
func disableColliders():
	$"Control/AreaLeft/CollisionShape2D".disabled = true
	$"Control/AreaRight/CollisionShape2D".disabled = true
