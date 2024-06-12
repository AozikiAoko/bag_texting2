extends MarginContainer

@onready var label = $Label
@onready var texture_rect = $TextureRect

const TIPS = preload("res://source/slots/tips.tscn")

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

##显示tips的方法，重写了godot原本提供的虚方法		
func _make_custom_tooltip(for_text:String)->Object:
	var item_tips=TIPS.instantiate()
	item_tips.update_display(item)
	return item_tips
	

	
