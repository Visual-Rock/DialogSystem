extends Resource
## A wraper class around the json format produced by baking a graph
class_name Dialog

## All currently supported Node types
enum DialogNodeTypes {
	Start,  ## Start node
	Text,   ## Text Node
	Branch, ## Branch Node (needs extra handling)
	End     ## End Node (the last node on the current branch)
}

## all nodes from the dialog
var nodes : Array[ Dictionary ]
## the start Node
var start : Dictionary
## name of the dialog
var name : String
## current node
var current : Dictionary

## array containing the id of the previously visited nodes
var history : Array[ int ]

## loads the dialog from a json file
func load_from_json( path: String) -> void:
	var dict : Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var file = path.get_file()
	name = file.substr(0, file.length() - 5)
	nodes = dict["nodes"]
	start = nodes[dict["start"]]
	history = [dict["start"]]
	current = start

## advances the dialog to the next node
##
## takes [param option] for selecting a branch on a branch node
##
## [codeblock]
## if dialog.current_node_type() == DialogNodeTypes.Branch:
##	    # select the branch you want to take
##	    dialog.advance(1)
##	else:
##	    dialog.advance()
## [/codeblock] 
func advance( option : int = 0 ) -> void:
	if current_node_type() == DialogNodeTypes.Branch:
		if current["branches"].size() > option:
			current = find_node(current["branches"][option]["next"])
	else:
		current = find_node(current["next"])

## finds a node by it's ID
func find_node(id: int) -> Dictionary:
	for node in nodes:
		if node["id"] == id:
			return node
	return { }

## returns the current nodes type
func current_node_type() -> DialogNodeTypes:
	if current == {}:
		return DialogNodeTypes.End
	return current["type"]
