tool
extends HBoxContainer

onready var Lineedit : LineEdit = self.get_node("LineEdit")
onready var Delete   : Button   = self.get_node("Button")

func _ready() -> void:
	if Delete:
		Delete.connect("pressed", self, "delete")

func delete() -> void:
	self.queue_free()
