extends Node

var menuScene = preload("res://Assets/Scenes/main_menu.tscn")
var gameScene = preload("res://Assets/Scenes/game.tscn")

var currentScene: Node = null

var transitionNode
var switchingScene = false



func _ready():
	DisplayServer.window_set_size(Vector2i(1280, 720))
	transitionNode = get_node("TransitionNode")
	loadScene("MainMenu")



func loadScene(desiredSceneName):
	if switchingScene == true:
		return
		
	switchingScene = true
	var packed: PackedScene
	if desiredSceneName == "MainMenu":
		packed = menuScene
	elif desiredSceneName == "Game":
		packed = gameScene
	else:
		push_error("Scene not found: " + desiredSceneName)
		switchingScene = false
		return
	
	
	if currentScene:
		

		transitionNode.transition(true,0.5)
		await transitionNode.transitionEvent
		currentScene.queue_free()
		currentScene = null
		
		currentScene = packed.instantiate()
		add_child(currentScene,0)
		
		transitionNode.transition(false,0.5)
		
		await transitionNode.transitionEvent
		transitionNode.visible = false
	else:
		
		currentScene = packed.instantiate()
		add_child(currentScene,0)
	switchingScene = false
	
