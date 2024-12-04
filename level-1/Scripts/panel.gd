extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
<<<<<<< HEAD:level-1/Scenes/panel.gd
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msec
	
	if time >= 7.0:
=======
	time -= delta  # Decrement the time
	if time < 0:
		time = 0  # Ensure it doesn't go below 0

# Calculate minutes, seconds, and milliseconds from time
	msec = int(fmod(time, 1) * 1000)
	seconds = int(fmod(time, 60))
	minutes = int(time / 60)

# Update text labels with formatted time
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msec

# Stop the countdown when time reaches 0
	if time <= 0:
>>>>>>> c9f9b8f1e32cfa20e6a577eb8ae9dcbbe02391f4:level-1/Scripts/panel.gd
		stop()
	
func stop() -> void:
	set_process(false)	 
	get_tree().reload_current_scene() # reloading current scene if we exceed 7 seconds
	
	
func get_time_formateed() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
