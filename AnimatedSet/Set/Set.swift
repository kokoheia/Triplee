//
//  Set.swift
//  Set
//
//  Created by 新井康平 on 2018/01/22.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import Foundation

struct Set {
    var cardsInDeck = Deck()
    var cardsOnField = [Card]()
    var score = 0
    var bestScore = -1
    

    
    mutating func drawNewCard(_ number: Int) {
        if cardsInDeck.count() >= number {
            for _ in 0..<number {
                if let drawnCard = cardsInDeck.draw() {
                    cardsOnField.append(drawnCard)
                }
            }
        }
    }
    
    mutating func shuffleCard() {
        var originalCardList = cardsOnField
        var newCardList = [Card]()
        for _ in 0..<cardsOnField.count {
            let removeIndex = originalCardList.count.arc4randomInt
            newCardList.append(originalCardList.remove(at: removeIndex))
            
        }
        cardsOnField = newCardList
    }
    
    func isMatched(cards: [Card]) -> Bool {
        if cards.count != 3 {
            return false
        }

        let card1 = cards[0]
        let card2 = cards[1]
        let card3 = cards[2]
        
        if !(card1.setColor == card2.setColor && card2.setColor == card3.setColor) &&
            !(card1.setColor != card2.setColor && card2.setColor != card3.setColor && card3.setColor != card1.setColor) {
            return false
        } else if !(card1.setSuit == card2.setSuit && card2.setSuit == card3.setSuit) &&
            !(card1.setSuit != card2.setSuit && card2.setSuit != card3.setSuit && card3.setSuit != card1.setSuit) {
            return false
        } else if !(card1.setShading == card2.setShading && card2.setShading == card3.setShading) &&
            !(card1.setShading != card2.setShading && card2.setShading != card3.setShading && card3.setShading != card1.setShading)  {
            return false
        } else if !(card1.numberOfSetSuit == card2.numberOfSetSuit && card2.numberOfSetSuit == card3.numberOfSetSuit) &&
            !(card1.numberOfSetSuit != card2.numberOfSetSuit && card2.numberOfSetSuit != card3.numberOfSetSuit && card3.numberOfSetSuit != card1.numberOfSetSuit) {
            return false
        }
        return true
    }
}

extension Int {
    var arc4randomInt: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


