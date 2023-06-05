extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
#can also use regular Texture for texture var
@export var texture: AtlasTexture
