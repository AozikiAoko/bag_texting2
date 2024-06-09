extends Resource
class_name Items

##这是道具模板类，所有的道具都是一个抽象的数据

##道具类型
enum ITEM_TYPE{
	NONE,#未知
	EQUITMENT,#装备
	CONSUMABLE,#消耗品
	MATERIAL#材料
}
##道具名称
@export var name:String="道具名称"
#道具描述
@export var discription:String="道具描述"
##道具类型
@export var itemType:ITEM_TYPE=ITEM_TYPE.NONE
##道具图标
@export var icon:Texture=null
##道具最大堆叠数量
@export var max_stack:=1
##道具数量
@export var quantity:=1:
	set(value):
		quantity_changed.emit()
		quantity=value
##道具数量更新时会发出的信号
signal quantity_changed(value)
##道具属性
@export var attributes:Dictionary={
	#生命值什么的:100
}
