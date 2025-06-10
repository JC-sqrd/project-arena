class_name HeadGear
extends Equipment

@export var ability : Ability


func _ready():
	equipped.connect(on_equipped)
	unequipped.connect(on_unequipped)

func on_equipped(actor : Entity):
	if ability != null:
		#ability.process_mode = Node.PROCESS_MODE_INHERIT
		ability.actor = actor
		ability.ready.emit()
	ready.emit()
	print("WEAPON EQUIPPED: " + str(actor))
	pass

func on_unequipped():
	if ability != null:
		ability.actor = null
		#ability.process_mode = Node.PROCESS_MODE_DISABLED
	pass
