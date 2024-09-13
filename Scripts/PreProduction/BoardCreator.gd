@tool
class_name BoardCreator
extends Node

@export var width: int = 10
@export var depth: int = 10
@export var height: int = 8
@export var pos: Vector2i
var _oldPos: Vector2i
var tiles = {}
var tileViewPrefab = preload("res://Prefabs/Tile.tscn")
var tileSelectionIndicatorPrefab = preload("res://Materials/Tile_Selection_Indicator.tscn")
var marker

var _random = RandomNumberGenerator.new()

var savePath = "res://Data/Levels/"
@export var fileName = "testMap.JSON"

func _ready():
	#Instantiate the cursor
	marker = tileSelectionIndicatorPrefab.instantiate()
	add_child(marker)
	#Set cursor position to origin
	pos = Vector2i(0,0)
	_oldPos = pos
	#set a seed in the RNG
	_random.randomize()
	
func _process(_delta):
	InputMap.load_from_project_settings() #breaks if this is outside process
	if Input.is_action_just_pressed("move_up"):
		pos.x += 1
		
	if Input.is_action_just_pressed("move_down"):
		pos.x -= 1
		
	if Input.is_action_just_pressed("move_left"):
		pos.y -= 1
		
	if Input.is_action_just_pressed("move_right"):
		pos.y += 1
		
	if Input.is_action_just_pressed("grow"):
		Grow()
		
	if Input.is_action_just_pressed("shrink"):
		Shrink()
	
	if pos != _oldPos:
		_oldPos = pos
		_UpdateMarker()
	
func _UpdateMarker():
	if tiles.has(pos):
		var t: Tile = tiles[pos]
		marker.position = t.center()
	else:
		marker.position = Vector3(pos.x, 0, pos.y)

func Clear():
	for key in tiles:
		tiles[key].free()
	tiles.clear()
	pos = Vector2i(0,0)
	
func Grow():
	_GrowSingle(pos)
	
func Shrink():
	_ShrinkSingle(pos)
	
func GrowArea():
	var r: Rect2i = _RandomRect()
	_GrowRect(r)
	
func ShrinkArea():
	var r: Rect2i = _RandomRect()
	_ShrinkRect(r)
	
func SaveJSON():
	var saveFile = savePath + fileName
	SaveMap(saveFile)
	
func LoadJSON():
	var saveFile = savePath + fileName
	LoadMap(saveFile)
	
func SaveMap(saveFile):
	var main_dict = {
		"version": "Alpha",
		"tiles": []
	}
	
	for key in tiles: 
		var save_dict = {
			"pos_x" : tiles[key].pos.x,
			"pos_z" : tiles[key].pos.y,
			"height" : tiles[key].height
		}
		main_dict["tiles"].append(save_dict)
		
	var save_game = FileAccess.open(saveFile, FileAccess.WRITE)
	
	var json_string = JSON.stringify(main_dict, "\t", false)
	save_game.store_line(json_string)
	
func LoadMap(saveFile):
	if not FileAccess.file_exists(saveFile):
		print("Error! We don't have a save to load")
		return
	
	var save_game = FileAccess.open(saveFile, FileAccess.READ)
	
	var json_text = save_game.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		print("Error %s reading json file." % parse_result)
		return
	
	#We don't want to have any left over stray blocks when loading
	Clear()
	
	var data = {}
	data = json.get_data()
	
	for mtile in data["tiles"]:
		var t: Tile = _Create()
		t.Load(Vector2(mtile["pos_x"], mtile["pos_z"]), mtile["height"])
		tiles[Vector2i(t.pos.x, t.pos.y)] = t
	
	save_game.close()
	_UpdateMarker()	
	
func _GrowSingle(p: Vector2i):
	var t: Tile = _GetOrCreate(p)
	if t.height < height:
		t.Grow()
		_UpdateMarker()
		
func _ShrinkSingle(p: Vector2i):
	if not tiles.has(p):
		return
	
	var t: Tile = tiles[p]
	t.Shrink()
	_UpdateMarker()
	
	if t.height <= 0:
		tiles.erase(p)
		t.free()
		
func _GetOrCreate(p: Vector2i):
	if tiles.has(p):
		return tiles[p]
	
	var t: Tile = _Create()
	t.Load(p, 0)
	tiles[p] = t
	
	return t
	
func _Create():
	var instance = tileViewPrefab.instantiate()
	add_child(instance)
	return instance
	
func _RandomRect():
	var x = _random.randi_range(0, width-1)
	var y = _random.randi_range(0, depth-1)
	var w = _random.randi_range(1, width-x)
	var h = _random.randi_range(1, depth-y)
	return Rect2i(x, y, w, h)
	
func _GrowRect(rect: Rect2i):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var p = Vector2i(x, y)
			_GrowSingle(p)

func _ShrinkRect(rect: Rect2i):
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var p = Vector2i(x, y)
			_ShrinkSingle(p)
