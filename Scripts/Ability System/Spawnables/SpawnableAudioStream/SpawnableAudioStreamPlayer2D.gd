class_name SpawnableAudioStreamPlayer2D
extends AudioStreamPlayer2D


enum PLAY_STREAM_ON {READY, WINDUP_START, WINDUP_END, HIT, DESTROY}
var spawnable : Spawnable

@export var play_stream_on : PLAY_STREAM_ON = PLAY_STREAM_ON.READY

func _ready():
	if owner is Spawnable:
		spawnable = owner
	match play_stream_on:
		PLAY_STREAM_ON.READY:
			spawnable.ready.connect(play_audio_stream)
			pass
		PLAY_STREAM_ON.WINDUP_START:
			spawnable.ready.connect(play_audio_stream)
			pass
		PLAY_STREAM_ON.WINDUP_END:
			spawnable.ready.connect(play_audio_stream)
			pass
		PLAY_STREAM_ON.HIT:
			spawnable.ready.connect(play_on_hit)
			pass
		PLAY_STREAM_ON.DESTROY:
			spawnable.ready.connect(play_audio_stream)
			pass
	pass


func play_audio_stream():
	play()
	pass

func play_on_hit(hit_data : Dictionary):
	play()
	pass
