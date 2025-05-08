class_name PickupableStreamPlayer2D
extends AudioStreamPlayer2D


@export var pickup_manager : PickupableManager
var pitch_reset_timer : Timer

func _ready():
	pickup_manager.play_pickup_sound.connect(_play_pickup_sound)
	pitch_reset_timer = Timer.new()
	add_child(pitch_reset_timer)
	pitch_reset_timer.wait_time = 1
	pitch_reset_timer.timeout.connect(func(): pitch_scale = 1)
	pass
	
func _play_pickup_sound(audio : AudioStream):
	stream = audio
	pitch_scale += 0.01
	play()
	#get_tree().create_timer(1, false, false, false).timeout.connect(func() : pitch_scale = 1)
	pitch_reset_timer.start()
	pass
