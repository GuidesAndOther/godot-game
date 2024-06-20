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
	if inv.opened:
		if inv.currentItem.item == null:
			inv.currentItem.item = inv.hotbar[index].item
			inv.hotbar[index].item = null
			inv.currentItem.quantity = inv.hotbar[index].quantity
			inv.hotbar[index].quantity = 0
		else:
			if inv.hotbar[index].item == null:
				inv.hotbar[index].item = inv.currentItem.item
				inv.hotbar[index].quantity = inv.currentItem.quantity
				inv.currentItem.item = null
				inv.currentItem.quantity = 0
			else:
				if inv.hotbar[index].item == inv.currentItem.item:
					if inv.currentItem.quantity > inv.hotbar[index].item.max_quantity - inv.hotbar[index].quantity:
						var c = inv.currentItem.quantity - inv.inventory[index].quantity
						inv.currentItem.quantity -= c
						inv.hotbar[index].quantity += c
					else:
						inv.hotbar[index].quantity += inv.currentItem.quantity
						inv.currentItem.quantity = 0
						inv.currentItem.item = null
				else:
					var ti = inv.hotbar[index].item
					var tq = inv.hotbar[index].quantity
					inv.hotbar[index].quantity = inv.currentItem.quantity
					inv.hotbar[index].item = inv.currentItem.item
					inv.currentItem.item = ti
					inv.currentItem.quantity = tq
	else:
		if inv.hotbar[index].item != null:
			inv.hotbar[index].item.use(inv.player)
			inv.canChange = false
			await get_tree().create_timer(2)
			inv.canChange = true
