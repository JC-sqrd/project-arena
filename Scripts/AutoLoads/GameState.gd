extends Node


var time_elapsed : float = 0

var msec : float
var sec : float
var mins : float


func reset_game_timer():
	time_elapsed = 0
	msec = 0
	sec = 0
	mins = 0
	pass

func start_game_timer():
	
	pass

func _process(delta: float) -> void:
	time_elapsed += delta
	msec = fmod(time_elapsed, 1) * 100
	sec = fmod(time_elapsed, 60) 
	mins = fmod(time_elapsed, 3600) / 60
