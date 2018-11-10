extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var sptspeed = 20

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#var randval = (randi() % 7) + 1
	#sptspeed *= randval
	pass

func _process(delta):
	position.x += delta * 20 * sptspeed
	pass
