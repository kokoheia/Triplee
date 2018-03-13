//
//  ViewController.swift
//  Set
//
//  Created by 新井康平 on 2018/01/22.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LayoutViews, UIDynamicAnimatorDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        containerView.delegate = self
        animator.delegate = self
        drawCards(12)
        runTimer()
    }
    
    private func setUpView() {
//        discardPile.layer.cornerRadius = discardPile.bounds.width / 10
//        deck.layer.cornerRadius = deck.bounds.width / 10
        discardPile.layer.borderWidth = 1
        discardPile.layer.borderColor = UIColor.white.cgColor
        deck.layer.borderWidth = 1
        deck.layer.borderColor = UIColor.white.cgColor
        GradientMaker.makeBackgroundGradient(view: view)


    }
    
    @IBOutlet weak var gestureRecognizingView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addCard(sender:)))
            swipe.direction = [.down]
            gestureRecognizingView.addGestureRecognizer(swipe)
            
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCard(sender:)))
            gestureRecognizingView.addGestureRecognizer(rotation)
        }
    }
    
    @IBOutlet weak var containerView: ContainerView! {
        didSet{
            containerView.setNeedsLayout()
            containerView.setNeedsDisplay()
        }
    }
    var cardButtons: [SetCardView] = []
    var tempCards: [Card] = []
    var tempCardButtons: [SetCardView] = []
    var viewsOnDiscardPile = [SetCardView]()
    var hiddenOriginalSelectedCards = [SetCardView]()
    
    lazy var animator = UIDynamicAnimator(referenceView: self.view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBOutlet weak var countLabel: UILabel!
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        countLabel.text = "\(timeFormatted(seconds))"
        if seconds == 0 {
            endTimer()
        } else {
            seconds -= 1
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        return String(format: "%d", seconds)
    }
    
    private func endTimer() {
        timer.invalidate()
        performSegue(withIdentifier: "gameOver", sender: self)
    }
    
    //draw views from initialized SetCardViews
    func updateViewFromModel() {
        let grid = aspectRatioGrid(for: containerView.bounds, withNoOfFrames: game.cardsOnField.count)
        var dealingIndex = 0
        discardPile.setTitle("score: \(game.score)", for: .normal)
        for index in self.cardButtons.indices {
            let cardButton = self.cardButtons[index]
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.touchCard(sender:)))
            cardButton.addGestureRecognizer(tapGestureRecognizer)
            // if the card is dealt for the first time
            if !tempCards.contains(cardButton.card!) {
                let deckFrame = self.deck.frame
                let containerViewFrame = self.containerView.frame
                cardButton.frame =  CGRect(x: deckFrame.minX-containerViewFrame.minX,
                                           y: deckFrame.minY-containerViewFrame.minY,
                                           width: deckFrame.width,
                                           height: deckFrame.height)
                

                let duration = 0.1

                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: duration * Double(dealingIndex), options: [.curveEaseOut], animations: {
                    cardButton.frame = grid[index]?.insetBy(dx: 6, dy: 6) ?? CGRect.zero

                    dealingIndex += 1
                }, completion: { finished in
                    UIView.transition(with: cardButton, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                        cardButton.isFaceUp = true
                    })
                })
                containerView.layoutIfNeeded()
                // if the card is already dealt
            } else {
                cardButton.isFaceUp = true
                let cardButton = self.cardButtons[index]
                cardButton.frame = tempCardButtons[index].frame
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
                    cardButton.frame = grid[index]?.insetBy(dx: 6, dy: 6) ?? CGRect.zero
                }, completion: nil)
                cardButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
    }
    
   

    @IBOutlet weak var hint: UIButton!
    var game = Set()
    var selectedCardButtons : [SetCardView] {
        get {
             return cardButtons.filter{ $0.setCardState == .selected || $0.setCardState == .selectedAndMatched}
        }
        set {}
    }
    
    
    var isThreeCardsMatching :Bool {
        if selectedCardButtons.count == 3 {
            var cardsToCheck: [Card] = []
            for cardButton in selectedCardButtons {
                if let card = cardButton.card {
                    cardsToCheck.append(card)
                }
            }
            return game.isMatched(cards: cardsToCheck)
        }
        return false
    }

//    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var discardPile: UIButton!
    
    @IBOutlet weak var deck: UIButton!

    @IBAction func showHint(_ sender: UIButton) {
        for card1Index in 0..<game.cardsOnField.count-2 {
            for card2Index in card1Index+1..<game.cardsOnField.count-1 {
                for card3Index in card2Index+1..<game.cardsOnField.count {
                    let card1 = game.cardsOnField[card1Index]
                    let card2 = game.cardsOnField[card2Index]
                    let card3 = game.cardsOnField[card3Index]
                    if game.isMatched(cards: [card1, card2, card3]) {
                        let cardButton1 = cardButtons[game.cardsOnField.index(of: card1)!]
                        let cardButton2 = cardButtons[game.cardsOnField.index(of: card2)!]
                        let cardButton3 = cardButtons[game.cardsOnField.index(of: card3)!]
                        let resultMatchingCardButtons = [cardButton1, cardButton2, cardButton3]
                        for cardButton in resultMatchingCardButtons {
                            cardButton.setCardState = .hinted
                        }
                        return
                    }
                }
            }
        }
    }
    
    @objc func addCard(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if game.cardsInDeck.count() >= 3, game.cardsOnField.count <= cardButtons.count {
                if selectedCardButtons.count == 3, isThreeCardsMatching {
                    for card in selectedCardButtons {
                        card.card = game.cardsInDeck.draw()!
                        resetCardButtons()
                    }
                } else if game.cardsOnField.count == cardButtons.count {
                    drawCards(3)
                    return
                }
            }
        }
    }
    
    @IBAction func addCard(_ sender: UIButton) {
        if game.cardsInDeck.count() >= 3, game.cardsOnField.count <= cardButtons.count {
            if selectedCardButtons.count == 3, isThreeCardsMatching {
                for card in selectedCardButtons {
                   card.card = game.cardsInDeck.draw()!
                    resetCardButtons()
                }
            } else if game.cardsOnField.count == cardButtons.count {
                drawCards(3)
                return
            }
        }
    }
    
    @objc func shuffleCard(sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.shuffleCard()
            resetCardButtons()
        }
    }

    @objc func touchCard(sender: UITapGestureRecognizer) {
        if selectedCardButtons.count <= 3 {
            if let cardButton = sender.view as?  SetCardView {
                //select card
                //check if selected card list contains the sender card
                if !selectedCardButtons.contains(cardButton) {
                    //If there are 3 chosen cards
                    if selectedCardButtons.count == 3 {
                        if isThreeCardsMatching {
                            for cardB in self.selectedCardButtons {
                                cardB.setCardState = .unselected
                                if let cardToChangeIndex = self.game.cardsOnField.index(of: cardB.card!) {
                                    self.game.cardsOnField[cardToChangeIndex] = self.game.cardsInDeck.draw() ?? Card()
                                    cardB.subviews.forEach{$0.removeFromSuperview()}
                                    cardB.card = self.game.cardsOnField[cardToChangeIndex]
                                }
                            }
    //                        for cardButton in self.cardButtons {
    //                            let storedFrame = cardButton.frame
    //                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0, options: [], animations: {
    //                                cardButton.frame = self.deck.frame
    //                                cardButton.layer.opacity = 1
    //                            }, completion: { finished in
    //                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [], animations: {
    //                                    cardButton.frame = storedFrame
    //                                }, completion: nil)
    //                            })
    //                        }
                        } else {
                            for selectedCardButton in selectedCardButtons {
                                selectedCardButton.setCardState = .unselected
                            }
                            selectedCardButtons = []
                        }
                        cardButton.setCardState = .selected
    //                    resetCardButtons()
                    //If there is 1 or 0 chosen cards
                    } else if selectedCardButtons.count == 1 || selectedCardButtons.count == 0 {
                        cardButton.setCardState = .selected
                    } else {
                        //If there are 2 chosen cards
                        cardButton.setCardState = .selected
                        
                        if isThreeCardsMatching {
                            viewsOnDiscardPile = []
                            hiddenOriginalSelectedCards = []
                            
                            for selectedCardButton in selectedCardButtons {
                                //make the opacity of the matched cards 0
                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.01, delay: 0, options: [], animations: {
                                    selectedCardButton.alpha = 0
                                }, completion: nil)
                                hiddenOriginalSelectedCards.append(selectedCardButton)
                                
                                //make a temporary card to perform animation
                                let tempCard = SetCardView(frame: selectedCardButton.frame)
                                tempCard.card = selectedCardButton.card
                                tempCard.isFaceUp = true
                                tempCard.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                                view.addSubview(tempCard)
                                
                                //add cardBehavior to the card
                                cardBehavior.addItem(item: tempCard)
                                
                                //after pushing behavior, start snap behavior
                                var _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self] (timer) in
                                    self?.cardBehavior.removeItem(item: tempCard)
    //                                self?.cardBehavior.snap(tempCard, toItem: (self?.discardPile)!)
                                    self?.discardPile.setTitle("", for: .normal)
                                    let snap = UISnapBehavior(item: tempCard, snapTo: CGPoint(x: (self?.discardPile.center.x)!, y: (self?.discardPile.center.y)!))
                                    snap.damping = 2
                                    snap.action = {
                                        tempCard.bounds = (self?.discardPile.bounds)!
                                        tempCard.layoutIfNeeded()
                                    }
                                    self?.animator.addBehavior(snap)
                                    self?.viewsOnDiscardPile.append(tempCard)
                                })
                            }
                            game.score += 1
                        }
                    }
                } else {
                    // deselect card
                    if selectedCardButtons.count == 1 || selectedCardButtons.count == 2 {
                        cardButton.setCardState = .unselected
                    } else {
                        return
                    }
                }
            }
        }
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        //after snap behavior flip the top card
        let topCardToFlip = viewsOnDiscardPile[viewsOnDiscardPile.count-1]
        var _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {[weak self] (timer) in
            UIView.transition(with: topCardToFlip, duration: 0.2, options: [.transitionFlipFromLeft], animations: {
                topCardToFlip.isFaceUp = false
            }, completion: { [weak self] finished in
                //clean the animator
                for view in (self?.viewsOnDiscardPile)! {
                    self?.cardBehavior.removeAllBehavior(from: view)
                    view.removeFromSuperview()
                }
                //delete hidden original cards
                for hiddenCard in (self?.hiddenOriginalSelectedCards)! {
                    if let index = self?.cardButtons.index(of: hiddenCard) {
                        self?.game.cardsOnField.remove(at: index)
                        self?.cardButtons.remove(at: index)
                    }
                }
                //rearrange the view
                self?.resetCardButtons()
                self?.containerView.layoutIfNeeded()
            })
        })
    }

    func drawCards(_ number: Int) {
        game.drawNewCard(number)
        if game.cardsInDeck.count() == 0 {
            deck.setTitle("no card", for: UIControlState.normal)
            deck.isEnabled = false
        }
        resetCardButtons()
    }

    //initialize set view(cardButton)
    func resetCardButtons() {
        tempCardButtons = []
        tempCards = []
        cardButtons.forEach({tempCards.append($0.card!)})
        cardButtons.forEach({tempCardButtons.append($0)})
        cardButtons = []
        containerView.subviews.forEach({$0.removeFromSuperview()})
        for index in game.cardsOnField.indices {
            let card = game.cardsOnField[index]
            let button = SetCardView()
            button.card = card
            cardButtons.append(button)
            containerView.addSubview(button)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "gameOver" {
            if let gameOverVC = segue.destination as? GameOverViewController{
                gameOverVC.game = self.game
            }
        }
    }
}


extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(Int(arc4random_uniform(UInt32(self))))
        } else if self == 0 {
            return 0
        } else {
             return -CGFloat(Int(arc4random_uniform(UInt32(self))))
        }
    }
}


