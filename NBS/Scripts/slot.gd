extends Panel

var index := 0

@onready var display = $Display
@onready var inv = get_parent().get_parent().get_parent()

func update(slot : Slot):
	if slot.item != null:
		if slot.quantity > 1:
			$Label.text = str(slot.quantity)
		else:
			$Label.text = ""
		display.texture = slot.item.texture
	else:
		display.texture = null
		$Label.text = ""


func _on_choose_pressed():
	if !inv.opened: return
	
	if inv.currentItem.item == null:
		inv.currentItem.item = inv.inventory[index].item
		inv.inventory[index].item = null
		inv.currentItem.quantity = inv.inventory[index].quantity
		inv.inventory[index].quantity = 0
	else:
		if inv.inventory[index].item == null:
			inv.inventory[index].item = inv.currentItem.item
			inv.inventory[index].quantity = inv.currentItem.quantity
			inv.currentItem.item = null
			inv.currentItem.quantity = 0
		else:
			if inv.inventory[index].item == inv.currentItem.item:
				if inv.currentItem.quantity > inv.inventory[index].item.max_quantity - inv.inventory[index].quantity:
					var c = inv.currentItem.quantity - inv.inventory[index].quantity
					inv.currentItem.quantity -= c
					inv.inventory[index].quantity += c
				else:
					inv.inventory[index].quantity += inv.currentItem.quantity
					inv.currentItem.quantity = 0
					inv.currentItem.item = null
			else:
				var ti = inv.inventory[index].item
				var tq = inv.inventory[index].quantity
				inv.inventory[index].quantity = inv.currentItem.quantity
				inv.inventory[index].item = inv.currentItem.item
				inv.currentItem.item = ti
				inv.currentItem.quantity = tq
		
