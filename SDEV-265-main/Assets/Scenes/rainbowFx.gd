extends Label

var hue = 0
var speed = 10

func _process(delta):
	hue += (delta*speed)
	if hue > 100:
		hue -= 100
	self_modulate = Color.from_hsv(hue/100,0.5,1)
