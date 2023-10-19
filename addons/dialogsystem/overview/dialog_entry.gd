@tool
extends HBoxContainer

signal open_dialog(dialog: InternalDialog)
signal delete_dialog(dialog: InternalDialog)
signal bake_dialog(dialog: InternalDialog)

var dialog : InternalDialog

@onready var id_label : Label = self.get_node( "ID" )
@onready var name_label : Label = self.get_node( "Name" )
@onready var description_label : LineEdit = self.get_node( "Description" )
# @onready var name_label : Label = self.get_node( "Name" )

func _ready():
	if dialog:
		id_label.text = str( dialog.id )
		name_label.text = dialog.name
		name_label.tooltip_text = dialog.path
		description_label.text = dialog.description

func _on_open_pressed():
	emit_signal("open_dialog", dialog)

func _on_bake_pressed():
	emit_signal("bake_dialog", dialog)

func _on_delete_pressed():
	emit_signal("delete_dialog", dialog)
