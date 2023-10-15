@tool
extends Popup

signal button_pressed(idx: int)

@onready var StartButton : Button = self.get_node("Panel/VBoxContainer/Start")
@onready var TextButton : Button = self.get_node("Panel/VBoxContainer/Text")
@onready var BranchButton : Button = self.get_node("Panel/VBoxContainer/Branch")
@onready var EndButton : Button = self.get_node("Panel/VBoxContainer/End")

func _ready():
	# StartButton.connect("pressed", _on_start_pressed)
	# TextButton.connect("pressed", _on_text_pressed)
	# BranchButton.connect("pressed", _on_branch_pressed)
	# EndButton.connect("pressed", _on_end_pressed)
	pass

func _on_start_pressed():
	emit_signal("button_pressed", 0)
	hide()

func _on_text_pressed():
	emit_signal("button_pressed", 1)
	hide()

func _on_branch_pressed():
	emit_signal("button_pressed", 2)
	hide()

func _on_end_pressed():
	emit_signal("button_pressed", 3)
	hide()
