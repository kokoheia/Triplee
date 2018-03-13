//
//  CardBehavior.swift
//  Set
//
//  Created by Kohei Arai on 2018/03/10.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 2.0
        behavior.resistance = 0
        return behavior
    }()
    
    lazy var collision : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(2.5)
        addChildBehavior(push)
    }
    
    func snap(_ item: UIDynamicItem, toItem: UIView) {
        let snap = UISnapBehavior(item: item, snapTo: CGPoint(x: toItem.frame.center.x, y: toItem.frame.center.y))
        snap.damping =  2
        snap.action = {
           
            if let itemView = item as? UIView {
                 print((itemView.bounds, toItem.bounds))
                 itemView.bounds = toItem.bounds
            }
        }
        addChildBehavior(snap)
    }
    
    func addItem(item: UIDynamicItem) {
        collision.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(item: UIDynamicItem) {
        collision.removeItem(item)
    }
    
    func removeAllBehavior(from item: UIDynamicItem) {
        collision.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    
    override init(){
        super.init()
        addChildBehavior(collision)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
   
}
