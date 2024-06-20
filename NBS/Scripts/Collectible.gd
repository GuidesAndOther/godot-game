extends Area2D

@export var item : Item
@export var radius : int
@export var quantity : int

var canPickUp = false

@onready var display = $Sprite2D

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _ready():
	$Label.hide()
	display.material = ShaderMaterial.new()
	display.material.shader = load("res://outline.gdshader")
	display.material.set("shader_param/outlinecolor", Color.WHITE)
	$CollisionShape2D.shape.radius = radius
	$Sprite2D.texture = item.texture

func _physics_process(delta):
	if Input.is_action_just_pressed("_pickup") and canPickUp:
		quantity = player.get_node("CanvasLayer/Inventory").insert(item, quantity)
	
	$Label.text = str(quantity)
	
	if quantity == 0:
		queue_free()

func _on_body_entered(body):
	canPickUp = true
	display.material.set("shader_param/outline", true)
	$Label.show()


func _on_body_exited(body):
	canPickUp = false
	$Label.hide()
	display.material.set("shader_param/outline", false)
