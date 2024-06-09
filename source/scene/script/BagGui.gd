extends MarginContainer
class_name w_Inventory

var c_inventory:C_Inventory=null
@onready var Bag_Slots:GridContainer=%BagSlots
@onready var tab_bar = %TabBar

const bag_slot=preload("res://source/slots/bag_slot.tscn")
##状态
var CATEGORY:int=0

func _ready():
	CATEGORY=tab_bar.current_tab

##初始化方法
func Init():
	c_inventory.items_changed.connect(_on_item_changed)
	#删除所有原先的格子并创建新格子
	for item_slots in Bag_Slots.get_children():
		item_slots.queue_free()
	for i in c_inventory.item_slot_count:
		var item_slot:B_Slot=bag_slot.instantiate()
		Bag_Slots.add_child(item_slot)

##获取玩家持有道具的方法		
func get_all_items()->Array[Items]:
	var items:Array[Items]=c_inventory.items
	if CATEGORY==0:
		#全部道具
		return items
	#筛选之后的道具
	var filter_items:Array[Items]=items.filter(
		#每个元素都调用匿名函数，之后返回符合条件的数组元素组成一个新数组
		func(item)->bool:
			if item==null:
				return false
			#返回获取的item里所有与目前所想展示的物品类型里相同的所有元素
			return item.itemType==CATEGORY
	)
	filter_items.resize(c_inventory.item_slot_count)#调整数组大小等于背包格子数
	return filter_items

##更新道具显示
func update_items_display():
	var items:Array[Items]=get_all_items()
	var index=0
	for item in items:
		var slot=Bag_Slots.get_child(index)#通过int类型的索引来获取到子节点，也就是每个背包格子
		slot.item=item#slot里的item会有相应的方法使其更新
		index+=1
	
##背包内容更新时调用的方法	
func _on_item_changed():
	update_items_display()


##退出方法
func _on_exit_pressed():
	get_tree().quit()

##TabBar的标签筛选方法
func _on_tab_bar_tab_changed(tab):
	CATEGORY=tab
	update_items_display()
