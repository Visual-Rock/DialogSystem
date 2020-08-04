tool
extends HBoxContainer

onready var ValueName : Label = self.get_node("Label")
onready var NameMenu  : OptionButton = self.get_node("OptionButton")

func get_value() -> int:
	return NameMenu.selected

func load_from_data(data : Dictionary, default_value : Array) -> void:
	ValueName.text = data["name"]
	
