extends Node
class_name InputController

signal moveEvent(point:Vector2i)

var _hor:Repeater = Repeater.new('move_left', 'move_right')
var _ver:Repeater = Repeater.new('move_up', 'move_down')

signal fireEvent(button:int)
signal quitEvent()

var buttons = ['fire_1','fire_2','fire_3','fire_4']

func _process(delta):
	var x = _hor.Update()
	var y = _ver.Update()
	
	if x != 0 || y != 0:
		moveEvent.emit(Vector2i(x,y))
	
	for i in range(buttons.size()):
		if Input.is_action_just_pressed(buttons[i]):
			fireEvent.emit(i)
	
	if Input.is_action_just_pressed('quit'):
		quitEvent.emit()
