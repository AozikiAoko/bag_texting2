extends Node
class_name C_Inventory

##这个节点存放玩家获取的物品，同时也拥有管理玩家持有物品的方法
@export var item_slot_count:int=20

var items:Array[Items]=[]

signal items_changed

##准备20大小可扩张的数组
func _ready():
	items.resize(item_slot_count)

##添加道具方法
func add_items(item:Items):
	var empty_slot=get_null_bag_slots()
	if empty_slot==-1:return
	items[empty_slot]=item
	items_changed.emit()

##获取背包的空格子（如果不使用这个方法就会扩充数组进行添加道具）
func get_null_bag_slots()->int:#
	var index:int=0
	for slot in items:
		if slot==null:
			return index
		index+=1
	return -1	
