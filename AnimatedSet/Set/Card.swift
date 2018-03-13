//
//  Card.swift
//  Set
//
//  Created by 新井康平 on 2018/01/22.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import Foundation
import UIKit

struct Card: CustomStringConvertible, Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        if lhs.setSuit == rhs.setSuit,
            lhs.setColor == rhs.setColor,
            lhs.setShading == rhs.setShading,
            lhs.numberOfSetSuit == rhs.numberOfSetSuit {
            return true
        }
        return false
    }
    
    var description: String {
        return "\(setSuit), \(setShading), \(setColor), \(numberOfSetSuit)"
    }
    
    var setSuit: SetSuit
    var setShading: SetShading
    var setColor: SetColor
    var numberOfSetSuit: NumberOfSetSuit

    
    init() {
        self.setSuit = .oval
        self.setShading = .filled
        self.setColor = .red
        self.numberOfSetSuit = .one
    }
    
    init(setSuit: SetSuit, setShading: SetShading, setColor: SetColor, numberOfSetSuit: NumberOfSetSuit) {
        self.setSuit = setSuit
        self.setShading = setShading
        self.setColor = setColor
        self.numberOfSetSuit = numberOfSetSuit
    }
    
    
    enum SetSuit: String, CustomStringConvertible, Equatable {
        static func == (lhs: SetSuit, rhs: SetSuit) -> Bool {
            if lhs.rawValue == rhs.rawValue {
                return true
            }
            return false
        }
        
        var description: String {
            return self.rawValue
        }
        
        case oval
        case dia
        case squiggle
        
       static var all = [SetSuit.oval, .dia, .squiggle]
    }
    
    enum SetShading: String, CustomStringConvertible, Equatable {
        static func ==(lhs: SetShading, rhs: SetShading) -> Bool {
            if lhs.rawValue == rhs.rawValue {
                return true
            }
            return false
        }
        
        var description: String {
            return self.rawValue
        }
        
        case filled
        case stripe
        case empty
        
        static var all = [SetShading.filled, .stripe, .empty]
    }
    
    enum SetColor: String , CustomStringConvertible, Equatable {
//        typealias RawValue = UIColor
        
        var description: String {
            return self.rawValue
        }
        static func ==(lhs: SetColor, rhs: SetColor) -> Bool {
            if lhs.rawValue == rhs.rawValue {
                return true
            }
            return false
        }
        
        case red
        case green
        case blue
//
//        init?(rawValue: RawValue) {
//            switch rawValue {
//            case UIColor.red: self = .red
//            case UIColor.green: self = .green
//            case UIColor.blue: self = .blue
//            default: return nil
//            }
//        }
//
//        var rawValue: RawValue {
//            switch self {
//            case .red: return UIColor.red
//            case .green: return UIColor.green
//            case .blue: return UIColor.blue
//            }
//        }
        
        static var all = [SetColor.red, SetColor.green, SetColor.blue]
    }
    
    enum NumberOfSetSuit: Int, CustomStringConvertible, Equatable {
        var description: String {
            return "\(self.rawValue)"
        }
        static func ==(lhs: NumberOfSetSuit, rhs: NumberOfSetSuit) -> Bool {
            if lhs.rawValue == rhs.rawValue {
                return true
            }
            return false
        }
        
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [NumberOfSetSuit.one, NumberOfSetSuit.two, NumberOfSetSuit.three]
    }


}


