extends Node
class_name InputController

signal moveEvent(point:Vector2i)

var _hor:Repeater = Repeater.new('move_left', 'move_right')
var _ver:Repeater = Repeater.new('move_up', 'move_down')

func _process(delta):
	var x = _hor.Update()
	var y = _ver.Update()
	
	if x != 0 || y != 0:
		moveEvent.emit(Vector2i(x,y))
