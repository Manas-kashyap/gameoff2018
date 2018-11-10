extends Node2D

enum TURN {
	PL1,
	PL2
}

var currentTurn = TURN.PL1

export(NodePath) var labelnp

onready var count = get_node(labelnp)

onready var player = get_node("player")

var decrementing = false

func endTurn():
	if currentTurn == TURN.PL1:
		yield(player.execute_commands(), "executed")
		currentTurn = TURN.PL2
	else:
		currentTurn = TURN.PL1

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		endTurn()
		print("END TURN")
	if currentTurn == TURN.PL1:
		# give control to the player 1
		# each turn you are limited to 2 actions one move and other decide whether to attack or defend
		# quirky thing you can't do both at once
		
		# Player will first select a direction
		# Second player will select what to do attack or defend and hit start
		
		pass
	else:
		# calculate what to do and do it
		# likely this will decide where to spawn units and if they should attack or defend
		if not decrementing:
			decrementing = true
			decrement_label_val()
	

func decrement_label_val():
	var val = int(count.text)
	while(val > 0):
		yield(get_tree().create_timer(0.2), "timeout")
		val -= 1
		count.text = str(val)
	endTurn()
	print("END TURN - ENEMY")
	yield(get_tree().create_timer(0.6), "timeout")
	count.text = "10"
	decrementing = false
	


