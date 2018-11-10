##Helper stuff to understand the engine coding somewhat in a gist
#
#extends Node  # write the NodeType 
#
## GDScript is a python like language with dynamic typing
## and this is also the easiest language to learn to program games
#
#func _enter_tree():
#	# constructor
#	pass
#
#func _ready():
#	# start method from unity
#	# runs once at start of the instance
#	pass
#
#func _process(delta):
#	# update method from unity
#	# process the stuff per frame
#	pass
#
#func _exit_tree():
#	# destructor
#	pass

extends Sprite

var size_x = 32
var size_y = 32

export(PackedScene) var bullet

var SCREEN_X_MAX = OS.window_size.x - size_x
var SCREEN_Y_MAX = OS.window_size.y - size_y

enum TODO {
	NONE,
	ATTACK,
	DEFEND
}

enum DIR {
	UP,
	DOWN
}

var dirSelected = false

var dir = DIR.UP

var energy = 0

var selectWhatToDo = TODO.NONE

signal executed
var execute = false
var shott = 0

var rateOfFire = 0.1

func _ready():
	pass

func execute_commands():
	execute = true
	# start the movement tween and shooting tween or defense tween
	var mov = 0
	if dir == DIR.UP:
		mov = -100
	else:
		mov = 100
	get_node("tween").interpolate_property(self, "position", position, position + Vector2(0, mov), 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	if selectWhatToDo == TODO.ATTACK:
		get_node("tween").interpolate_method(self, "shoot", 0, 1, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		# put up a shield
		get_node("shield").visible = true
	get_node("tween").start()
	return self

func shoot(arbitary = 0):
	if shott < rateOfFire:
		print(shott)
		return
	shott = 0
	var inst = bullet.instance()
	inst.position = position + Vector2(size_x,0)
	get_parent().add_child(inst)

func _process(delta):
	if dir == DIR.UP:
		get_node("arrowup").visible = true
		get_node("arrowdown").visible = false
	if dir == DIR.DOWN:
		get_node("arrowup").visible = false
		get_node("arrowdown").visible = true
	
	
	if selectWhatToDo == TODO.ATTACK:
		get_node("todo").text = "A"
	else:
		get_node("todo").text = "D"
	
	shott += delta
	if Input.is_action_just_pressed("ui_up"):
		dir = DIR.UP
		dirSelected = true
	if Input.is_action_just_pressed("ui_down"):
		dir = DIR.DOWN
		dirSelected = true
	
	if Input.is_action_just_pressed("ui_q"):
		selectWhatToDo += 1
		if selectWhatToDo > TODO.DEFEND:
			selectWhatToDo = TODO.ATTACK
		print(selectWhatToDo)
	
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().endTurn()
	
	if dirSelected:
		select_dir()
		
	if execute:
		execute = false
		yield(get_tree().create_timer(2.0), "timeout")
		get_node("shield").visible = false
		emit_signal("executed")


func select_dir():
	dirSelected = false
	pass

func _physics_process(delta):
	pass
