extends Node2D

@onready var player:Node2D = %Player
@onready var bag:MarginContainer = %Bag


@onready var line_edit:LineEdit=%LineEdit
@onready var BS:Button=%bin_submit


func _ready():
	bag.c_inventory=player.get_node("C_Inventory")
	bag.Init()

##提交文本时调用的方法
func _on_line_edit_text_submitted(new_text):
	process_command(new_text)

##按下按钮时触发的方法
func _on_bin_submit_pressed():
	var new_text=line_edit.text
	process_command(new_text)

##将输入栏的字符串转化为指令
func process_command(command:StringName):
	var part:PackedStringArray=command.split(" ")
	#简单地说就是用来分割字符串用的，这里只要是空格就分割为子字符串，组成字符串数组
	if part.size()<=0:return
	var cmd:String=part[0]#最开始的部分是命令名
	var args:PackedStringArray=part.slice(1,part.size())#后面的部分是命令的参数
	if not has_method(cmd):
		push_error("没有找到匹配的方法：",cmd)
		return
	callv(cmd,args)#执行命令,前面是调用的方法名，后面是参数（比如添加道具就是调用下面的add_items）

##添加道具方法
func add_items(item_name:String,count:String):
	var item_count=int(count)
	var item:Items=create_items(item_name,item_count)
	if item==null:
		push_error("找不到对应的item：",item_name)
		return
	var CInventory:C_Inventory=player.get_node("C_Inventory")
	CInventory.add_items(item)
	print_debug("添加道具:",item_name,"添加数量:",min(item_count,item.max_stack),"指令执行完成")
	

##创建道具方法
func create_items(item_name:String,count:int)->Items:
	var item_path="res://source/items/"+item_name+".tres"
	if not ResourceLoader.exists(item_path):
		push_error("未找到资源路径：",item_path)
		return
	var item:Items=load(item_path).duplicate()#加载资源并复制一份
	item.quantity=min(count,item.max_stack)
	return item

