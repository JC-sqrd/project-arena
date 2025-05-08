class_name ItemCard
extends Control

@export var item_texture_rect : TextureRect
@export var item_name_label : RichTextLabel
@export var item_detail_label : RichTextLabel
signal item_card_picked(item : Item)
var item : Item

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pass

func initialize(item : Item):
	self.item = item
	item_name_label.text = item.item_name
	item_texture_rect.texture = item.item_icon
	item_detail_label.text = item.item_detail
	pass

func _on_mouse_entered():
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.15)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	modulate = Color.AQUAMARINE
	pass

func _on_mouse_exited():
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	modulate = Color.WHITE
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			modulate = Color.DIM_GRAY
			var tween : Tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_ELASTIC)
			tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.15)
			if item != null:
				item_card_picked.emit(item)
				pass
			pass
		elif !event.pressed:
			modulate = Color.AQUAMARINE
			var tween : Tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ONE, 0.1)
			pass
	pass
