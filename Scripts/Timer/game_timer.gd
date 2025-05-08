extends Panel

@onready var msec_label : Label = $Milliseconds
@onready var sec_label : Label = $Seconds
@onready var mins_label : Label = $Minutes

func _process(delta: float) -> void:
	msec_label.text = "%03d" % GameState.msec
	sec_label.text = "%02d:" % GameState.sec
	mins_label.text = "%02d:" % GameState.mins
