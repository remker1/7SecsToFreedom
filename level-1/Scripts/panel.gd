extends Panel

var time: float = 7.0  # Start the countdown from 7 seconds
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta: float) -> void:
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
		stop()

func stop() -> void:
	set_process(false)
	# Perform any action when the countdown ends
	get_tree().reload_current_scene()  # Example action: Reload current scene

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
