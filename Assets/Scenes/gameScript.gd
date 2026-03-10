extends Control
var cardAsset = preload("res://Assets/Scenes/card.tscn")

var cardPosCent = Vector2(500,325)



var playerCards = []
var dealerCards = []
var playerScore = 0
var dealerScore = 0

var playerChips = 1000

var shuffledDeck = []
var baseDeck = range(1,52)

var inRoundOptions
var buyInOptions 
var chipInput
var playerChipLabel
var resultsTag
var deckSprite
var baseNode

signal turn_ended
signal buy_in
signal cardDealt

func updateCardScores():
	playerScore = 0
	dealerScore = 0
	
	var countEm = func(array):
		var score = 0
		for n in array:
			if n.currentlyVisible == true:
				var aceCards = 0
				var cardVal = str(n.myValue)
				if cardVal == "K" or cardVal == "Q" or cardVal == "J":
					score += 10
				elif cardVal == "A":
					aceCards += 1
				else:
					score += int(cardVal)
					
				if aceCards > 0:
					var maxAdd = 11 + (aceCards-1) 
					if (score + maxAdd) <= 21:
						score += 11
					else:
						score += aceCards
		return score
	playerScore = countEm.call(playerCards)
	dealerScore = countEm.call(dealerCards)
	
	$YouPts.text = "You - " + str(playerScore)
	$DealerPts.text = "Dealer - " + str(dealerScore)

func move_card(card, target_pos, time, removeAfter = false):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		card,
		"global_position",
		target_pos,
		time
	)
	if removeAfter == true:
		tween.tween_property(
			card,
			"scale",
			Vector2(0.5,0.5),
			time
		)
		
		await get_tree().create_timer(time).timeout
		card.queue_free()

func dealCard(deck, plr, vis):
	var NewCard = cardAsset.instantiate()
	
	var raw = deck.pick_random()
	deck.erase(raw) # removes value
	var horizontalOffset = 0
	var finalPos = Vector2(0,0)
	
	if (plr == "Dealer"):
		horizontalOffset = dealerCards.size()*80
		finalPos = cardPosCent + Vector2(-200+horizontalOffset,-175)
		dealerCards.append(NewCard)
		
	elif (plr == "Player"):
		horizontalOffset = playerCards.size()*80
		finalPos = cardPosCent + Vector2(-200+horizontalOffset,175)
		playerCards.append(NewCard)
		
		
	NewCard.global_position = deckSprite.global_position
	$Cards.add_child(NewCard)
	NewCard.setCard(null,null,raw)
	await NewCard.SetVisibility(vis)
	NewCard.playAnim()
	
	
	NewCard.get_node("FlipSfx").play()
	move_card(NewCard,finalPos,0.35)
	
	await updateCardScores()

func reset():
	buyInOptions.visible = false
	inRoundOptions.visible = false
	resultsTag.visible = false
	
	if playerCards.size() > 0 or dealerCards.size() > 0:
		$ShuffleSfx.play()
	for n in playerCards:
		move_card(n, deckSprite.global_position,0.35,true)
		await get_tree().create_timer(0.05).timeout
	for n in dealerCards:
		move_card(n, deckSprite.global_position,0.35,true)
		await get_tree().create_timer(0.05).timeout
	shuffledDeck = baseDeck.duplicate()
	playerCards = []
	dealerCards = []
	
	updateCardScores()
	chipInput.max_value = playerChips

func playRound(chipsBet):
	reset()
	
	playerChips -= chipsBet
	updateChipLabel()
	#Initial Deal
	dealCard(shuffledDeck, "Player", true)
	await get_tree().create_timer(0.3).timeout
	dealCard(shuffledDeck, "Dealer", true)
	await get_tree().create_timer(0.3).timeout
	dealCard(shuffledDeck, "Player", true)
	await get_tree().create_timer(0.3).timeout
	dealCard(shuffledDeck, "Dealer", false)
	await get_tree().create_timer(0.3).timeout
	
	#Player turn
	var endTurn = false
	var hit_button = inRoundOptions.get_node("Hit")
	var stand_button = inRoundOptions.get_node("Stand")
	var hit_handler: Callable
	var stand_handler: Callable
	
	hit_handler = func():
		if playerScore < 21:
			await dealCard(shuffledDeck, "Player", true)
			if playerScore >= 21:
				hit_button.visible = false
				turn_ended.emit()

	stand_handler = func():
		turn_ended.emit()
		
	hit_button.pressed.connect(hit_handler)
	stand_button.pressed.connect(stand_handler)
	
	if playerScore < 21:
		hit_button.visible = true
	else:
		hit_button.visible = false
	inRoundOptions.visible = true
	
	await turn_ended
	
	hit_button.pressed.disconnect(hit_handler)
	stand_button.pressed.disconnect(stand_handler)
	
	inRoundOptions.visible = false
	
	#Dealer turn
	await get_tree().create_timer(0.5).timeout
	for n in dealerCards:
		if n.currentlyVisible == false:
			n.SetVisibility(true, true)
	updateCardScores()
	await get_tree().create_timer(0.5).timeout
	if dealerScore < 17:
		while dealerScore < 17:
			dealCard(shuffledDeck, "Dealer", true)
			await get_tree().create_timer(0.5).timeout
			
	await get_tree().create_timer(1.5).timeout
	
	#Results
	var Reward = 0
	if playerScore > 21:
		playerScore = -1
	if dealerScore > 21:
		dealerScore = 0
		

	if playerScore > dealerScore:
		resultsTag.text = "You win!"
		Reward = chipsBet*2
	elif playerScore == dealerScore:
		resultsTag.text = "Push!"
		Reward = chipsBet
	else:
		resultsTag.text = "Dealer Wins!"
		
	resultsTag.visible = true
	playerChips += Reward
	if Reward > chipsBet:
		$coins2sfx.play()
	elif Reward > 0:
		$coins1sfx.play()
	updateChipLabel()
	await get_tree().create_timer(1).timeout
	await reset()
	
	
	if playerChips <= 0:
		resultsTag.text = "Bankrupt..."
		$bankrupt.play()
		resultsTag.visible = true
		await get_tree().create_timer(4).timeout
		baseNode.loadScene("MainMenu")
	else:
		await get_tree().create_timer(.5).timeout
		buyInOptions.visible = true

	
func updateChipLabel():
	playerChipLabel.text = str(playerChips)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	resultsTag = $Results
	inRoundOptions = $HitStandBtns
	buyInOptions = $BuyInOps
	playerChipLabel = $ChipCounter.get_node("Label")
	deckSprite = $Deck
	updateChipLabel()
	
	chipInput = buyInOptions.get_node("ChipInput").get_node("SpinBox")
	var buyinBtn = buyInOptions.get_node("Start")
	chipInput.max_value = playerChips
	chipInput.value = 0
	buyinBtn.visible = false
	buyInOptions.visible = true
	
	chipInput.value_changed.connect(func(newval):	
		$coins1sfx.play()
		if chipInput.value > 0:
			buyinBtn.visible = true
		else:
			buyinBtn.visible = false
	)

	buyinBtn.pressed.connect(func():
		if chipInput.value > 0:
			$coins2sfx.play()
			playRound(chipInput.value)
			chipInput.value = 0
			buyinBtn.visible = false
			
	)
	baseNode = get_parent().get_parent()
	$ReturnToMenu.pressed.connect(func():
		baseNode.loadScene("MainMenu")
	)

