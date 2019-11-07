extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spawnPoint = $"Control"
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
	
func _process(delta):
	checkCombineCollisions()
	update_length(delta)
	
	
func update_length(delta):
	var pixelsToMove
	var speed = Global.speed
	
	pixelsToMove = (speed * (delta))
	
	if direction == 0 && is_in_group("Leading"):
		rect_size.y += pixelsToMove
	
	
	if direction != 0 && is_in_group("Leading"):
		rect_position.x -= pixelsToMove * direction
		rect_size.y += pixelsToMove * 1.4
		
	if !is_in_group("Leading"):
		rect_position.y += pixelsToMove
		
	if rect_position.y > $"../Garbage".rect_position.y:
		queue_free()
		
func straighten():
	if direction == 0: return
	remove_from_group("Leading")
	
	var seg = Global.segment.instance()
	get_parent().add_child(seg)
	
	seg.rect_position = spawnPoint.get_global_position()
	
	seg.rect_position.y = Global.segY
	
	if direction < 0:			
		seg.rect_position.x -= (rect_size.x / 2) + 1.5		
		
	if direction > 0:			
		seg.rect_position.x -= (rect_size.x / 2) - 1.5
		
func split():
	if direction != 0: return
	
	remove_from_group("Leading")
	
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
	
func checkCombineCollisions():
	if !is_in_group("Leading"): return
	if direction == 0: return
	
	for s in get_tree().get_nodes_in_group("Leading"):
		if s == self: continue
		if s == twin: continue
		var left = s.rect_position.x - s.rect_size.x/8
		var right = s.rect_position.x + s.rect_size.x/8
		
		if rect_position.x < right && rect_position.x > left:
			if s.direction == 0:
				remove_from_group("Leading")
				return
			
			s.remove_from_group("Leading")
			remove_from_group("Leading")
				
			var xPos = (s.rect_position.x + rect_position.x) / 2	
			var seg = Global.segment.instance()
			get_parent().add_child(seg)
			seg.rect_position.y = Global.segY
			seg.rect_position.x = xPos

func _on_Area2D_area_entered(area):
	if !is_in_group("Leading"): return
	if area.name == "Barrier" || area.name == "Border":
		remove_from_group("Leading")
		$"Control/Area2D/CollisionShape2D".call_deferred("disabled",true)
