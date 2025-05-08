class_name AbilityAudioListener
extends AudioStreamPlayer2D

@export var ability : Ability
@export var invoke_stream : AudioStream
@export var start_stream : AudioStream
@export var active_stream : AudioStream
@export var end_stream : AudioStream
@export var canceled_stream : AudioStream
@export var hit_stream : AudioStream

func _ready():
	ability.ability_invoked.connect(_play_invoke_stream)
	ability.ability_start.connect(_play_start_stream)
	ability.ability_active.connect(_play_active_stream)
	ability.ability_end.connect(_play_end_stream)
	ability.ability_canceled.connect(_play_canceled_stream)
	ability.ability_hit.connect(_play_hit_stream)
	


func _play_invoke_stream():
	if invoke_stream != null:
		stream = invoke_stream
		play()
	pass

	
func _play_start_stream():
	if start_stream != null:
		stream = start_stream
		play()
	pass
	
func _play_active_stream():
	if active_stream != null:
		stream = active_stream
		play()
	pass
	
func _play_end_stream():
	if end_stream != null:
		stream = end_stream
		play()
	pass
	
func _play_canceled_stream():
	if canceled_stream != null:
		stream = canceled_stream
		play()
	pass
	
func _play_hit_stream(hit_data : HitData):
	if hit_stream != null:
		stream = hit_stream
		play()
	pass
