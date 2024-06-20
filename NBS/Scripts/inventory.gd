class_name Inventory
extends Control

var currentItem : Slot = Slot.new()

var collectible = preload("res://Scenes/Collectible.tscn")

@onready var curItemDisplay = $"NinePatchRect/Panel/Holding item"

@onready var slots = $NinePatchRect/GridContainer.get_children()
@onready var hotBarSlots = $HotBar/HBoxContainer.get_children()
@onready var invSize = slots.size()

var hotIndex = 0

var canChange = true

@onready var hotbarSize = hotBarSlots.size()

@export var inventory : Array[Slot]
@export var hotbar : Array[Slot]

@onready var player : Player = get_parent().get_parent()

var opened = false

var inInventory = false

@onready var Pos1 = Vector2(13, 97)
@onready var Pos2 = Vector2(-200, 97)

@onready var HPos1 = Vector2(227, 276)
@onready var HPos2 = Vector2(13, 71)

@onready var curPos = Pos1
@onready var HCurPos = HPos1


func close():
	opened = false
	for slot in slots: slot.get_node("Choose").release_focus()
	if currentItem.item != null:
		insert(currentItem.item, currentItem.quantity)
		currentItem = null
	curPos = Pos2
	HCurPos = HPos1

func open():
	opened = true
	slots[0].get_node("Choose").grab_focus()
	curPos = Pos1
	HCurPos = HPos2

func _ready():
	hotbar.resize(hotbarSize)
	inventory.resize(invSize)
	for i in range(inventory.size()):
		inventory[i] = Slot.new()
		slots[i].index = i
	for i in range(hotbar.size()):
		hotbar[i] = Slot.new()
		hotBarSlots[i].index = i
	
	update_slots()
	
	close()

func _physics_process(delta):
	if !opened:
		if hotbar[hotIndex].item != null:
			player.holdingItem.texture = hotbar[hotIndex].item.texture
		else:
			player.holdingItem.texture = null
		hotBarSlots[hotIndex].get_node("Choose").grab_focus()
	else:
		if currentItem.item != null:
			player.holdingItem.texture = currentItem.item.texture
		else:
			player.holdingItem.texture = null
	
	if Input.is_action_just_pressed("_throw") and currentItem.item != null:
		drop(currentItem.item, currentItem.quantity)
		currentItem.item = null
		currentItem.quantity = 0
	
	$NinePatchRect.global_position = lerp($NinePatchRect.global_position, curPos, 0.2)
	$HotBar.global_position = lerp($HotBar.global_position, HCurPos, 0.2)
	
	if Input.is_action_just_pressed("_inventory"):
		close() if opened else open()
	
	if currentItem.item != null:
		curItemDisplay.texture = currentItem.item.texture
		if currentItem.quantity > 1:
			$NinePatchRect/Panel/Label2.text = str(currentItem.quantity)
		else:
			$NinePatchRect/Panel/Label2.text = ""
	else:
		if opened:
			player.get_node("HoldingItem").texture = null
		curItemDisplay.texture = null
		$NinePatchRect/Panel/Label2.text = ""
	
	update_slots()
	update_hotbar()

func _input(event):
	if !opened and canChange:
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if hotIndex > 0:
					hotIndex -= 1
				else:
					hotIndex = hotbarSize-1
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if hotIndex < hotbarSize-1:
					hotIndex += 1
				else:
					hotIndex = 0
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if hotbar[hotIndex].item != null:
					hotbar[hotIndex].item.use(player)
		if event is InputEventJoypadButton and event.is_pressed():
			if event.button_index == JOY_BUTTON_DPAD_LEFT:
				if hotIndex > 0:
					hotIndex -= 1
				else:
					hotIndex = hotbarSize-1
			elif event.button_index == JOY_BUTTON_DPAD_RIGHT:
				if hotIndex < hotbarSize-1:
					hotIndex += 1
				else:
					hotIndex = 0

func update_slots():
	for i in range(invSize):
		slots[i].update(inventory[i])

func insert(item : Item, quantity : int) -> int:
	var c : int
	for i in range(inventory.size()):
		if inventory[i].item == item and item != null:
			c = inventory[i].quantity + quantity
			if c > item.max_quantity:
				quantity = c - item.max_quantity
				inventory[i].quantity = item.max_quantity
			else:
				inventory[i].quantity = c
				return 0
	
	for i in range(inventory.size()):
		if inventory[i].item == null:
			if quantity > item.max_quantity:
				inventory[i].item = item
				inventory[i].quantity = item.max_quantity
				quantity -= item.max_quantity
			else:
				inventory[i].item = item
				inventory[i].quantity = quantity
				return 0
	
	return quantity

func drop(item : Item, quantity : int):
	var col = collectible.instantiate()
	col.global_position = player.global_position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
	col.item = item
	col.quantity = quantity
	player.get_parent().add_child(col)

func update_hotbar():
	for i in range(hotbarSize):
		hotBarSlots[i].update(hotbar[i])

