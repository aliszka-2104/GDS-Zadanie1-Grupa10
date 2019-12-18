extends TileMap

var node_PlaceholderReplacer = preload("res://Scenes/Prefabs/Hole.tscn")
export var placeholderTileName = "Hole"

func _ready():
	var tm = self
	var sizex = tm.get_cell_size().x
	var sizey = tm.get_cell_size().y
	var ts = tm.get_tileset()
	var uc = tm.get_used_cells()
	for pos in uc :
		var id = tm.get_cell(pos.x, pos.y)
		var name = ts.tile_get_name(id)
		
		if name in Global.placeholdersDictionary:
			var node = Global.placeholdersDictionary[name].instance()
			node.position= (Vector2( pos.x * sizex + (0.5*sizex), pos.y * sizey + (0.5*sizey)))
			add_child(node)
			tm.set_cell(pos.x, pos.y, -1) #this line remove the tile in TileMap
		
#		if name == placeholderTileName:
#			var node = node_PlaceholderReplacer.instance()
#			node.position= (Vector2( pos.x * sizex + (0.5*sizex), pos.y * sizey + (0.5*sizey)))
#			add_child(node)
#			tm.set_cell(pos.x, pos.y, -1) #this line remove the tile in TileMap