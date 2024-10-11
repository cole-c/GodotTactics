@tool
extends Node
class_name Tile

var content: Node

var prev: Tile
var distance: int

const stepHeight: float = 0.25
var pos: Vector2i
var height: int

# Convenience Func to get center of tile
func center() ->Vector3:
	return Vector3(pos.x, height * stepHeight, pos.y)

# After modifying a tile, set scale to correct height
func Match(): 
	self.scale = Vector3(1, height * stepHeight, 1)
	self.position = Vector3(pos.x, height * stepHeight / 2.0, pos.y)

# Increase height of a tile
func Grow():
	height += 1
	Match()

# Decrease height of a tile
func Shrink():
	height -= 1
	Match()

# Set specific height and position of a tile
func Load(p: Vector2i, h: int):
	pos = p
	height = h
	Match()
	
# Set specific height and position of a tile
func LoadVector(v: Vector3):
	Load(Vector2i(v.x, v.z), v.y)
