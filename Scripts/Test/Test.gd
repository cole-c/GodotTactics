extends Node

var _owner: BattleController

# Called when the node enters the scene tree for the first time.
func _ready():
	_owner = get_node("../")
	
	var saveFile = _owner.board.savePath + _owner.board.fileName
	_owner.board.LoadMap(saveFile)
	
	AddListeners()

func _exit_tree():
	RemoveListeners()

func AddListeners():
	_owner.inputController.moveEvent.connect(OnMove)
	
func RemoveListeners():
	_owner.inputController.moveEvent.disconnect(OnMove)
	
func OnMove(e:Vector2i):
	_owner.board.pos += e
