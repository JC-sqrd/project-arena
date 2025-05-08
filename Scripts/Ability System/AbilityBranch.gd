class_name AbilityBranch
extends Node

enum InvokeTime {INVOKE, START, ACTIVE, END}

@export var ability : Ability
@export var next_ability : Ability
@export var invoke_next_on : InvokeTime = InvokeTime.START
@export var next_branch : AbilityBranch

signal branch_ability_invoked
signal branch_ability_canceled
signal branch_start
signal branch_end

func _ready():
	if invoke_next_on == InvokeTime.INVOKE:
		ability.ability_invoked.connect(on_ability_invoke)
		ability.ability_end.connect(on_branch_ability_invoked)
	elif invoke_next_on == InvokeTime.START:
		ability.ability_start.connect(on_ability_start)
		ability.ability_end.connect(on_branch_ability_invoked)
	elif invoke_next_on == InvokeTime.ACTIVE:
		ability.ability_active.connect(on_ability_active)
		ability.ability_end.connect(on_branch_ability_invoked)
	elif invoke_next_on == InvokeTime.END:
		ability.ability_end.connect(on_ability_end)
		ability.ability_end.connect(on_branch_ability_invoked)
	if ability != null:
		ability.ability_canceled.connect(_on_ability_canceled)
		ability.initialize_ability()
		ability.ability_start.connect(func(): branch_start.emit())
		pass
	if next_ability != null:
		next_ability.ability_canceled.connect(_on_ability_canceled)
		next_ability.ability_end.connect(_on_next_ability_end)
		next_ability.initialize_ability()
		next_ability.ability_end.connect(func(): branch_end.emit())
		pass
	else:
		ability.ability_start.connect(func(): branch_end.emit())

func cast_ability():
	ability.invoke_ability()

func on_ability_invoke():
	if next_ability != null:
		next_ability.invoke_ability()
	if next_branch != null and next_ability == null:
		next_branch.cast_ability()
	pass
	
func on_ability_start():
	if next_ability != null:
		next_ability.invoke_ability()
	if next_branch != null and next_ability == null:
		next_branch.cast_ability()
		pass
	pass

func on_ability_active():
	if next_ability != null:
		next_ability.invoke_ability()
	if next_branch != null and next_ability == null:
		next_branch.cast_ability()
	pass

func on_ability_end():
	if next_ability != null:
		next_ability.invoke_ability()
	if next_branch != null and next_ability == null:
		next_branch.cast_ability()
	pass

func _on_next_ability_end():
	if next_branch != null:
		next_branch.cast_ability()
	pass
	
func on_branch_ability_invoked():
	branch_ability_invoked.emit()
	pass

func _on_ability_canceled():
	branch_ability_canceled.emit()
	pass
