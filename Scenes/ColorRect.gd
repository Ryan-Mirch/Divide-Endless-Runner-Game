extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spawnPoint = $"Control"

var leading = true
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_direction(d):
	direction = d
	rect_rotation = rect_rotation - 45*direction
	
func _process(delta):
	update_length(delta)
	
	
func update_length(delta):
	rect_position.y += delta * Global.speed
	
	if leading:
		if direction != 0:
			rect_size.y += delta * Global.speed * 1.43
			
		else:
			rect_size.y += delta * Global.speed
		
func split():
	leading = false
	#color = Color(1,0,0,1)
	
	if direction == 0:
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
		
	else:
		var seg = Global.segment.instance()
		
		get_parent().add_child(seg)
		
		seg.rect_position = spawnPoint.get_global_position()
		
		if direction < 0:			
			seg.rect_position.x -= (rect_size.x / 2) +2
			seg.rect_position.y += 3
			
		if direction > 0:			
			seg.rect_position.x -= (rect_size.x / 2) - 1
			seg.rect_position.y += 3			
		
		
		
	
	
	


