extends Control

signal transitionEvent

func transition(appear, time):
	var nodeSize = size.x
	var translucentSize = (nodeSize*0.1)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	if appear == true:
		global_position = Vector2(nodeSize,0)
		visible = true
		tween.tween_property(
			self,
			"global_position",
			Vector2(0-translucentSize,0),
			time
		)
	else:
		global_position = Vector2(0-translucentSize,0)
		visible = true
		tween.tween_property(
			self,
			"global_position",
			Vector2(-nodeSize,0),
			time
		)
	await get_tree().create_timer(time).timeout
	transitionEvent.emit()

func _ready():
	pass # Replace with function body.


