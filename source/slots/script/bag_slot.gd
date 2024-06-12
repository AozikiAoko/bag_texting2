extends MarginContainer
class_name B_Slot

@onready var item_tile:MarginContainer=$Item_till
@onready var color_rect = %ColorRect

##背包插槽
var item:Items=null:set=item_setter

signal mouse_left_pressed
signal mouse_hold

func _ready():
	gui_input.connect(on_gui_input)

##选中当前道具槽
func selected():
	color_rect.show()
	

##取消选中当前道具槽
func disselected():
	color_rect.hide()


##鼠标按下时触发的方法
func on_gui_input(event:InputEvent):
	mouse_hold.emit()
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index==MOUSE_BUTTON_LEFT:
			mouse_left_pressed.emit()



##更新背包格子的方法
func item_setter(value:Items):
	item=value
	if item!=null:
		item_tile.update_display(item)
		item_tile.show()
	else:
		item_tile.hide()
		
