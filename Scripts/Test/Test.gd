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
	_owner.inputController.fireEvent.connect(OnFire)
	_owner.inputController.quitEvent.connect(OnQuit)
	
func RemoveListeners():
	_owner.inputController.moveEvent.disconnect(OnMove)
	_owner.inputController.fireEvent.disconnect(OnFire)
	_owner.inputController.quitEvent.disconnect(OnQuit)
	
func OnMove(e:Vector2i):
	_owner.board.pos += e
	
func OnFire(e:int):
	print("Fire: " + str(e))
	
func OnQuit():
	get_tree().quit()
