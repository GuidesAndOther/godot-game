class_name Tool
extends Item

func use(player : Player):
	player.itemUse.play("use")
	player.hitbox.get_node("Collider").disabled = false
	await player.get_tree().create_timer(0.1).timeout
	player.hitbox.get_node("Collider").disabled = true
	player.get_node("CanvasLayer/Inventory").canChange = false
	await player.get_tree().create_timer(1).timeout
	player.get_node("CanvasLayer/Inventory").canChange = true
