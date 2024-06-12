extends MarginContainer
class_name w_Inventory

var c_inventory:C_Inventory=null
@onready var Bag_Slots:GridContainer=%BagSlots
@onready var tab_bar = %TabBar
@onready var decompose = %decompose
@onready var arrange = %arrange

const bag_slot=preload("res://source/slots/bag_slot.tscn")
const TIPS = preload("res://source/slots/tips.tscn")

##状态
var CATEGORY:int=0

##当前选择的道具槽
var current_item_slot:int=0:set=current_item_slot_setter

##鼠标选择的道具槽
var mouse_hold_slot:int=0:set=mouse_hold_slot_setter

func _ready():
	CATEGORY=tab_bar.current_tab

##初始化方法
func Init():
	c_inventory.items_changed.connect(_on_item_changed)
	#删除所有原先的格子并创建新格子
	for item_slots in Bag_Slots.get_children():
		item_slots.queue_free()
	for i in c_inventory.item_slot_count:#遍历所有格子
		var item_slot:B_Slot=bag_slot.instantiate()
		Bag_Slots.add_child(item_slot)
		
		item_slot.mouse_left_pressed.connect(_on_item_slot_mouse_pressed.bind(i))
		item_slot.mouse_hold.connect(_on_item_mouse_hold.bind(i))
		#把鼠标点击后出现选择变化的效果绑定在每一个格子里，这样就会触发了	
			
	decompose.pressed.connect(_on_decompose_pressed)
	arrange.pressed.connect(_on_arrange_pressed)

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
	
##鼠标按下时触发的方法	
func _on_item_slot_mouse_pressed(index:int):
	current_item_slot=index

##鼠标停在格子上面触发的方法
func _on_item_mouse_hold(index:int):
	mouse_hold_slot=index

##设置选择的道具槽索引的方法
func current_item_slot_setter(value:int):
	var slot=Bag_Slots.get_child(current_item_slot)
	slot.disselected()
	current_item_slot=value
	var new_slot=Bag_Slots.get_child(current_item_slot)
	new_slot.selected()

##设置鼠标悬停时显现tips索引的方法
func mouse_hold_slot_setter(value:int):
	var slot=Bag_Slots.get_child(mouse_hold_slot)
	mouse_hold_slot=value
	

##按下时触发分解的方法
func _on_decompose_pressed():
	c_inventory.remove_items(current_item_slot)
	
##按下时触发整理的方法
func _on_arrange_pressed():
	#合并相同道具、按类型排序、优化空格
	merge_similar_items()
	sort_item_by_type()
	c_inventory.items_changed.emit()

##合并相同道具	
func merge_similar_items():
	var temp_items:Array[Items]=c_inventory.items.duplicate()
	for i in range(temp_items.size()):
		var item:Items=temp_items[i]
		
		#道具为空或达到堆叠上限就跳过
		if item==null or item.is_stack_maxed():
			continue
		#不符合上述条件就向下执行
		for j in range(i+1,temp_items.size()):
			var other_item:Items=temp_items[j]
			if other_item!=null and item.can_marge_with(item):
				#合并操作
				item.merge(other_item)
				if other_item.quantity<=0:
					temp_items[j]=null
	c_inventory.items=temp_items
	
	
##按照类型排序
func sort_item_by_type():
	var temp_items:Array[Items]=c_inventory.items.filter(
		func(item:Items)->bool:
			return item!=null
	)
	temp_items.sort_custom(
		func(a:Items,b:Items)->bool:
			return a.itemType<b.itemType
	)
	c_inventory.items=temp_items
	c_inventory.items.resize(c_inventory.item_slot_count)

