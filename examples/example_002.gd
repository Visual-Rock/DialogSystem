extends Node2D

var dialog_manager : DialogManager
var dialog : Dialog = null

@onready var NameLabel : Label = self.get_node("CanvasLayer/VBoxContainer/name")
@onready var TextLabel : RichTextLabel = self.get_node("CanvasLayer/VBoxContainer/text_panel/text")
@onready var Branches  : VBoxContainer = self.get_node("CanvasLayer/VBoxContainer/branches")
@onready var NextButton : Button = self.get_node("CanvasLayer/VBoxContainer/HBoxContainer/next")
@onready var BackButton : Button = self.get_node("CanvasLayer/VBoxContainer/HBoxContainer/back")
@onready var SelectedDialog : OptionButton = self.get_node("CanvasLayer/VBoxContainer2/Dialog")

@onready var PlayerNameEdit : LineEdit = self.get_node("CanvasLayer/VBoxContainer2/PlayerName")

func _ready():
	dialog_manager = DialogManager.new()
	dialog_manager.load_dialogs("res://examples/bakes/")
	var i : int = 0
	for dialog in dialog_manager.dialogs:
		SelectedDialog.add_item(dialog.name, i)
		i += 1
	update()

func update() -> void:
	if dialog == null:
		NextButton.disabled = true
		BackButton.disabled = true
		return
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

func _on_dialog_item_selected(index):
	dialog = dialog_manager.get_dialog(SelectedDialog.get_item_text(index))
	dialog.restart()
	update()

func _on_player_name_text_submitted(new_text):
	dialog_manager.injection_data["player_name"] = PlayerNameEdit.text
	if dialog != null:
		dialog.injection_data["player_name"] = PlayerNameEdit.text
