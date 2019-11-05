extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spawnPoint = $"Control"

var leading = true
var direction = 0
var leftX = rect_position.x
var rightX = rect_position.x + rect_size.x
var twin = self
var seg1 = self
var seg2 = self

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_direction(d):
	direction = d
	
	if direction != 0:		
		rect_rotation = rect_rotation - 45*direction
		call_deferred("disableAreaCenter")
		
	if direction == 0:
		call_deferred("disableAreaFront")
	
func _process(delta):
	update_length(delta)
	
	
func update_length(delta):
	var pixelsToMove
	var speed = Global.speed
	
	pixelsToMove = (speed * (delta))
	
	if direction == 0 && leading:
		rect_size.y += pixelsToMove
	
	
	if direction != 0 && leading:
		rect_position.x -= pixelsToMove * direction
		rect_size.y += pixelsToMove * 1.4
		
	if !leading:
		rect_position.y += pixelsToMove
		
	if rect_position.y > $"../Garbage".rect_position.y:
		queue_free()
		
func straighten(xPos):
	if direction == 0: return
	leading = false
	call_deferred("disableAreaFront")
	
	var seg = Global.segment.instance()
	get_parent().add_child(seg)
	
	seg.rect_position = spawnPoint.get_global_position()
	
	seg.rect_position.y = Global.segY
	
	if direction < 0:			
		seg.rect_position.x -= (rect_size.x / 2) +2		
		
	if direction > 0:			
		seg.rect_position.x -= (rect_size.x / 2) - 1
		
	if xPos != -1:
		seg.rect_position.x = xPos
		
func split():
	if direction != 0: return
	
	leading = false
	call_deferred("disableAreaFront")
	
	seg1 = Global.segment.instance()
	seg2 = Global.segment.instance()
	
	seg1.twin = seg2
	seg2.twin = seg1
	
	get_parent().add_child(seg1)
	get_parent().add_child(seg2)
	
	seg1.rect_position = spawnPoint.get_global_position()
	seg2.rect_position = spawnPoint.get_global_position()
	
	seg1.rect_position.x -= rect_size.x / 2
	seg2.rect_position.x -= rect_size.x / 2
	
	seg1.rect_position.y = Global.segY
	seg2.rect_position.y = Global.segY
	
	seg1.set_direction(-1)
	seg2.set_direction(1)
	
	
	
	
		
func combine(hitXPos):	
	
	var thisXPos = $"Control".get_global_transform().origin.x	
	var xPos = ((thisXPos + hitXPos) / 2) - rect_size.x/2
	
	straighten(xPos)

	
func disableAreaFront():
	$"Control/AreaFront/CollisionShape2D".disabled = true
	
func disableAreaCenter():
	$"Control/AreaCenter/CollisionShape2D".disabled = true
	


func _on_AreaFront_area_entered(area):
	if area.name == "AreaCenter":return
	if direction == 0:return
	if leading == false:return
	if area.get_twin() == self: return
	leading = false
	
	if area.is_in_group("Barrier"): return
	if get_index() < area.get_seg().get_index(): return
	
	
	var xPos = area.get_parent().get_global_transform().origin.x
	#print(xPos)
	
	combine(xPos)


func _on_AreaCenter_area_entered(area):
	if leading == false: return
	if area.name != "AreaFront": return
	if area == $"Control/AreaFront": return
	if area.get_seg() == self: return
	if area.get_seg() == seg1: return
	if area.get_seg() == seg2: return
	
	area.get_seg().leading = false
