extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msec
	
	if time >= 7.0:
		stop()
	
func stop() -> void:
	set_process(false)	 
	get_tree().reload_current_scene() # reloading current scene if we exceed 7 seconds
	
	
func get_time_formateed() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
