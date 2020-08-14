# DialogSystem
 A Dialog System for Godot
 
## Getting Started

Download the newest version under the Releases tab
choose between Example(includes an Example Project) or Addon(just the plugin)

### Create your own Dialog

1. Go to Dialog Editor (in the top mid of the Screen)
2. Press on the Left plus symbol 
3. enter a Name and ID and Choose your [Node Template](https://github.com/Clon135/DialogSystem/wiki/Node-Templates)  
4. Open your dialog by pressing the Play Button on your Dialog
5. Go to Graph Editor and add your Nodes

### Bake your Dialog

after making a Graph you have to bake the Dialog baking is very easy 

- Press the Dialog Dropdown and select Bake thats all
- or in the Dialog Manager press the oven symbol 

### Using your Dialog

for easier use of the Baked Dialogs you can use the Dialog class
create one like this 

```
var dialog : Dialog = Dialog.new()
```

load your dialog 
from file:
```
dialog.load_from_file(path_to_file)
```
or with a Dictionary:
```
dialog.load_from_dict(Dictionary)
```

Get the Current Dialog:
```
dialog.get_current_dialog()
```
returns a Dictionary with the Dialogs Values,Node ID and the Options

if you only want the values do this:
```
dialog.get_values()
```
returns an Array of all the values of the current dialog
the values are Structured like this
```
{ value_name: value }
```

if you only want the Options you can do this:
```
dialog.get_options()
```
this returns an Array of all the Options

progressing the dialog is done by calling next on the dialog like this:
```
dialog.next()
```