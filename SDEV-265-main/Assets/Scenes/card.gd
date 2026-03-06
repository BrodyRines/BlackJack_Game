# NOTE: 0 is back of card. All other cards are 1-13 (CLUBS), 14-26 (SPADES), 27-39 (DIAMONDS), 40-52 (HEARTS). K-Q-J-10, so on.
extends Node2D
var possibleSuits = ["Clubs","Spades","Diamonds","Hearts"]
var possibleValues = ["K","Q","J",10,9,8,7,6,5,4,3,2,"A"]
var mySuit = 0
var myValue = "K"
var currentlyVisible = false
var DisplayName = true
var myRawValue = 0
var myHoverLabelText = " "
var didAlready = false
var animStartTime = float(0)
var loopCount = 0
const ctr1 = "[center]"
const ctr2 = "[/center]"

signal midFlip


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playAnim():
	$WobblePlayer.play("InGameWobble")
	$WobblePlayer.seek(animStartTime)

func mainMenu():
	if didAlready == false:
		$WobblePlayer.play("menu")
		$WobblePlayer.seek(animStartTime)
		didAlready = true
	var valRNG = randi_range(1,13)
	var suitRNG = randi_range(0,3)
	setCard(possibleSuits[suitRNG],valRNG)
	
func mainMenuAnimLooped():
	loopCount += 1
	if loopCount > 1: 
		mainMenu()
		loopCount = 0

func setMidFlip():
	midFlip.emit()


func setSprite(val):
	$AnimatedSprite2D.frame = val

func SetVisibility(vis, playflip = false):
	
	if currentlyVisible != vis and playflip == true:
		currentlyVisible = vis
		$FlipPlayer.play("flip")
		$FlipPlayer.seek(0)
		$FlipSfx.play()
		await midFlip
	else:
		currentlyVisible = vis
	
	if currentlyVisible == true:
		setSprite(myRawValue)
	else:
		setSprite(0)

func setCard(suit="Clubs",val=-1,raw=-1):
	# Raw option exists in case our card system just pulls a number 0-51 / 1-52. We check it first to get it out of the way.
	# Remember: Order is Clubs, Spades, Diamonds, Hearts in the sprite sheet.
	# Can be passed raw 0-3 for the Suit assignment or the appropriate name.
	if raw == -1:
		match suit:
			"Clubs":
				$AnimatedSprite2D.frame = val
				mySuit = "Clubs"
				myValue = possibleValues[val-1]
				changeMyHoverText()
			0:
				$AnimatedSprite2D.frame = val
				mySuit = possibleSuits[0]
				myValue = possibleValues[val-1]
				changeMyHoverText()
				
			"Spades":
				val = val + 13
				$AnimatedSprite2D.frame = val
				mySuit = "Spades"
				myValue = possibleValues[val-14]
				changeMyHoverText()
			1:
				val = val + 13
				$AnimatedSprite2D.frame = val
				mySuit = possibleSuits[1]
				myValue = possibleValues[val-14]
				changeMyHoverText()
			"Diamonds":
				val = val + 26
				$AnimatedSprite2D.frame = val
				mySuit = "Diamonds"
				myValue = possibleValues[val-27]
				changeMyHoverText()
			2:
				val = val + 26
				$AnimatedSprite2D.frame = val
				mySuit = possibleSuits[2]
				myValue = possibleValues[val-27]
				changeMyHoverText()
			"Hearts":
				val = val + 39
				$AnimatedSprite2D.frame = val
				mySuit = "Hearts"
				myValue = possibleValues[val-40]
				changeMyHoverText()
			3:	
				val = val + 39
				$AnimatedSprite2D.frame = val
				mySuit = possibleSuits[3]
				myValue = possibleValues[val-40]
				changeMyHoverText()
	else:
		myRawValue = raw
		
		if raw <= 13:
			mySuit = "Clubs"
			myValue = possibleValues[raw-1]
		elif raw <= 26:
			mySuit = "Spades"
			myValue = possibleValues[raw-14]
		elif raw <= 39:
			mySuit = "Diamonds"
			myValue = possibleValues[raw-27]
		else:
			mySuit = "Hearts"
			myValue = possibleValues[raw-40]
			
		changeMyHoverText()
	#print(self.get_name(), " ", mySuit, " ", myValue)

func changeMyHoverText():
	match myValue:
		"K":
			myHoverLabelText = str(ctr1, myValue, "ing", " of ", mySuit, ctr2)
		"Q":
			myHoverLabelText = str(ctr1, myValue, "ueen", " of ", mySuit, ctr2)
		"J":
			myHoverLabelText = str(ctr1, myValue, "ack", " of ", mySuit, ctr2)
		"A":
			myHoverLabelText = str(ctr1, myValue, "ce", " of ", mySuit, ctr2)
		_:
			myHoverLabelText = str(ctr1, myValue, " of ", mySuit, ctr2)
	$AnimatedSprite2D/Control/HoverTextLabel.set_text(myHoverLabelText)
	
func _on_control_mouse_entered():
	if $AnimatedSprite2D.frame > 0 and DisplayName == true :
		$AnimatedSprite2D/Control/HoverTextLabel.visible = true
func _on_control_mouse_exited():
	$AnimatedSprite2D/Control/HoverTextLabel.visible = false
