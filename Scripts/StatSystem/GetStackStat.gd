class_name GetStackStat
extends Stat

enum MethodName {STACK}
@export var method_name : MethodName = MethodName.STACK

func _ready():
	super()
	if method_name == MethodName.STACK:
		if owner.has_method("get_stack"):
			stat_value = owner.get_stack() as float
			
		pass
	pass
