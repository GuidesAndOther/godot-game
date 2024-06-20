class_name Player
extends CharacterBody2D

const SPEED = 100.0

@onready var hitbox := $Hitbox
@onready var itemUse := $ItemUse

@onready var holdingItem := $HoldingItem

func _physics_process(_delta):
	var dirs = get_dirs()

	velocity = dirs * SPEED

	move()

func get_dirs():
	return Input.get_vector("_left", "_right", "_up", "_down")

func move():
	move_and_slide()
