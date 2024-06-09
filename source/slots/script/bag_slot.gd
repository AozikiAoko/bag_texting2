extends MarginContainer
class_name B_Slot

@onready var item_tile:MarginContainer=$Item_till

var item:Items=null:set=item_setter

##更新背包格子的方法
func item_setter(value:Items):
	item=value
	if item!=null:
		item_tile.update_display(item)
		item_tile.show()
	else:
		item_tile.hide()
		
