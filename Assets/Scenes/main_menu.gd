extends Control
@export var menuCards: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var transitionNode = get_node("TransitionNode")
	var baseNode = get_parent()
	
	var mainNode = get_node("Main")
	var helpNode = get_node("Help")
	var settingsNode = get_node("Settings")
	
	var buttonList = get_node("Main/List")
	var playBtn = buttonList.get_node("PlayBtn")
	var quitBtn = buttonList.get_node("QuitBtn")
	var helpBtn = buttonList.get_node("RulesBtn")
	var settingsBtn = buttonList.get_node("SettingsBtn")
	
	var settingsBackBtn = settingsNode.get_node("BackBtn")
	var helpBackBtn = helpNode.get_node("BackBtn")
	
	playBtn.pressed.connect(func():
		baseNode.loadScene("Game")
	)
	
	quitBtn.pressed.connect(func():
		get_tree().quit()
	)
	
	helpBtn.pressed.connect(func():
		transitionNode.transition(true,0.3)
		await transitionNode.transitionEvent
		mainNode.visible = false
		helpNode.visible = true
		transitionNode.transition(false,0.3)
		
	)
	helpBackBtn.pressed.connect(func():
		transitionNode.transition(true,0.3)
		await transitionNode.transitionEvent
		mainNode.visible = true
		helpNode.visible = false
		transitionNode.transition(false,0.3)
		
	)

	settingsBtn.pressed.connect(func():
		transitionNode.transition(true,0.3)
		await transitionNode.transitionEvent
		mainNode.visible = false
		settingsNode.visible = true
		transitionNode.transition(false,0.3)
	)
	settingsBackBtn.pressed.connect(func():
		transitionNode.transition(true,0.3)
		await transitionNode.transitionEvent
		mainNode.visible = true
		settingsNode.visible = false
		transitionNode.transition(false,0.3)
	)
	animateCards()
	

func animateCards():
	var card = get_node("Main/Card")
	var card2 = get_node("Main/Card2")
	var card3 = get_node("Main/Card3")
	var card4 = get_node("Main/Card4")
	var card5 = get_node("Main/Card5")
	var card6 = get_node("Help/Card6")
	card.animStartTime = float(0.4)
	card.mainMenu()
	card2.animStartTime = float(0.3)
	card2.mainMenu()
	card3.animStartTime = float(0.2)
	card3.mainMenu()
	card4.animStartTime = float(0.1)
	card4.mainMenu()
	card5.animStartTime = float(0.0)
	card5.mainMenu()
	
	card6.setCard(null,null,26)
	card6.SetVisibility(true)
	card6.DisplayName = false
	card6.playAnim()



