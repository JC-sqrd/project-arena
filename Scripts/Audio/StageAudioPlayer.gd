class_name StageAudioPlayer
extends AudioStreamPlayer

@export var audio_streams : Array[AudioStream]
var current_audio_index : int = 0

func _ready():
	#finished.connect(_on_audio_finished)
	#stream = audio_streams[current_audio_index]
	#play()
	pass
	
func _on_audio_finished():
	if current_audio_index <= audio_streams.size() - 1:
		current_audio_index += 1
		stream = audio_streams[current_audio_index]
		play()
		pass
	else:
		current_audio_index = 0
		stream = audio_streams[current_audio_index]
		play()
	pass


