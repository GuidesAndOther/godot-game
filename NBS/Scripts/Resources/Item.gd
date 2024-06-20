class_name Item
extends Resource

@export var name : String
@export_multiline var description : String
@export var texture : Texture2D
@export var max_quantity : int

func use(player : Player):
	print(player)
