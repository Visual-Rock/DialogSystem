extends Node2D

func _ready():
	var d : Dialog = Dialog.new()
	var err = d.load_from_file("res://Dialogs/en/NPC_001.json", false)
	print(err)
	err = d.init_dialog()
	print(err)
