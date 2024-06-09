extends MarginContainer

@onready var label = $Label
@onready var texture_rect = $TextureRect

var item=null

##实际执行更新背包的方法
func update_display(item:Items):
	self.item=item
	texture_rect.texture=item.icon
	if item.max_stack<=1:
		label.hide()
	else:
		label.show()
		label.text=str(item.quantity)
