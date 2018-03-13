//
//  Deck.swift
//  Set
//
//  Created by 新井康平 on 2018/01/25.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import Foundation

struct Deck {
    private(set) var cards = [Card]()
    
    init() {
        for suit in Card.SetSuit.all {
            for shading in Card.SetShading.all {
                for color in Card.SetColor.all {
                    for number in Card.NumberOfSetSuit.all {
                        cards.append(Card(setSuit: suit, setShading: shading, setColor: color, numberOfSetSuit: number))
                    } 
                }
            }
        }
    }
    
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    func count() -> Int {
        return cards.count
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
