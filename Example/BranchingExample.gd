extends Node2D

onready var DialogButton  : Button        = self.get_node("CanvasLayer/Control/VBoxContainer/Panel/DialogBox/HBoxContainer/Button")
onready var Name          : Label         = self.get_node("CanvasLayer/Control/VBoxContainer/Panel/DialogBox/Name")
onready var Text          : RichTextLabel = self.get_node("CanvasLayer/Control/VBoxContainer/Panel/DialogBox/RichTextLabel")
onready var SelectButtons : VBoxContainer = self.get_node("CanvasLayer/Control/VBoxContainer/Options")

var d : Dialog

func _on_Button_pressed():
	if DialogButton.text == "Restart Dialog":
		d.back_to_start()
		set_ui(d.get_values())
		DialogButton.text = "Next"
		return
	if DialogButton.text == "Start Dialog":
		d = Dialog.new()
		d.load_from_file("res://Example/Bakes/en/Example_002.json")
		d.data["selected"] = false
		set_ui(d.get_values(), d.branched_dialog())
		DialogButton.text = "Next"
		return
	elif DialogButton.text == "Next":
		d.next()
		set_ui(d.get_values(), d.branched_dialog())
		if d.branched_dialog():
			if d.get_branch_type() == 0:
				DialogButton.disabled = true
		if d.get_next_id() == 99:
			DialogButton.text = "Restart Dialog"
		return

func set_ui(data : Dictionary, is_branched : bool = false) -> void:
	if data.has("Names"):
		Name.text = data["Names"]
		Text.text = data["text"]
		if is_branched == true:
			var options : Array = d.get_options()
			var btn : Button
			for option in options:
				btn = Button.new()
				btn.connect("pressed", self, "option_pressed")
				btn.text = option
				SelectButtons.add_child(btn)

func option_pressed() -> void:
	for btn in SelectButtons.get_children():
		if btn.pressed == true:
			d.next(btn.text)
			DialogButton.disabled = false
			set_ui(d.get_values(), d.branched_dialog())
			for child in SelectButtons.get_children():
				child.queue_free()
			break

func _on_CheckBox_toggled(button_pressed):
	if d:
		d.data["selected"] = button_pressed
