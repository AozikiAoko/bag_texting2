extends MarginContainer

##道具名
@onready var prop_name_text = %prop_name_text
##道具介绍
@onready var text = %text
##属性标题
@onready var attribute_title = %attribute_title
##属性介绍
@onready var attribute_1 = %attribute1

##描述栏位更新
func update_display(item:Items):
	await ready#ready调用后继续执行
	if item.itemType!=Items.ITEM_TYPE.EQUITMENT:
		attribute_title.hide()
		attribute_1.hide()#不是装备就没有描述
	prop_name_text.text=item.name
	text.text=item.discription
	var attributes:String=""
	for key in item.attributes:
		var value=item.attributes[key]
		attributes+=key+":"+str(value)+"\n"
	attribute_1.text=attributes
		
