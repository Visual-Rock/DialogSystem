extends Node2D

var dialog : Dialog

@onready var NameLabel : Label = self.get_node("CanvasLayer/VBoxContainer/name")
@onready var TextLabel : RichTextLabel = self.get_node("CanvasLayer/VBoxContainer/text_panel/text")
@onready var Branches  : VBoxContainer = self.get_node("CanvasLayer/VBoxContainer/branches")
@onready var NextButton : Button = self.get_node("CanvasLayer/VBoxContainer/HBoxContainer/next")
@onready var BackButton : Button = self.get_node("CanvasLayer/VBoxContainer/HBoxContainer/back")

func _ready():
	dialog = Dialog.new()
	dialog.load_from_json("res://examples/bakes/Example_001.json")
	update()

func update() -> void:
	for branch in Branches.get_children():
		branch.queue_free()
	if dialog.current_node_type() == Dialog.DialogNodeTypes.Branch:
		var branches = dialog.get_branches()
		for branch in range(0, dialog.get_branches_count()):
			var btn = Button.new()
			btn.text = dialog.get_branch_value(branch, "Option Name")
			btn.connect("pressed", _on_dialog_branch_pressed)
			Branches.add_child(btn)
	
	NextButton.disabled = dialog.current_node_type() == Dialog.DialogNodeTypes.Branch
	BackButton.disabled = dialog.history.size() <= 1
	
	NameLabel.text = dialog.get_value("Name")
	TextLabel.text = dialog.get_value("Text")

func _on_next_pressed():
	if dialog.current_node_type() != Dialog.DialogNodeTypes.End:
		dialog.advance()
	else:
		dialog.restart(false)
	update()

func _on_back_pressed():
	dialog.back()
	update()

func _on_dialog_branch_pressed() -> void:
	var i : int = 0
	for branch in Branches.get_children():
		if branch.button_pressed:
			break
		i += 1
	dialog.advance(i)
	update()
