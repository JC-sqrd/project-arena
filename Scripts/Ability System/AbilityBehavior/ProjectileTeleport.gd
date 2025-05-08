extends AbilityBehavior

class_name ProjectileTeleport

@export var projectile : PackedScene


func start_behavior():
	var test : TestSub = TestSub.create("Hello World")
	test.sub_test()
	
class Test:
	var test_var : String = "test var"
	
class TestSub extends Test:
	static func create(arg : String) -> TestSub:
		var new_instance = TestSub.new()
		new_instance.test_var = arg
		return new_instance
