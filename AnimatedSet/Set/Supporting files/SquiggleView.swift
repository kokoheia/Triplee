//
//  SquiggleView.swift
//  Set
//
//  Created by Kohei Arai on 2018/02/26.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

class SquiggleView: UIView {
    
    var card: Card?

    override convenience init(frame: CGRect) {
        self.init(frame: CGRect.zero)
    }
    
    init(frame: CGRect, card: Card) {
        self.card = card
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    lazy var setColor = { () -> UIColor in
        if let card = self.card {
            switch card.setColor {
            case .red :
                return hexStringToUIColor(hex: "#E8556E")
            case .green :
                return hexStringToUIColor(hex:"#30A576")
            case .blue:
                return hexStringToUIColor(hex:"#315B8E")
            }
        }
        return UIColor.black
    }()
   
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath()
        path.move(to: CGPoint(x:104.0, y: 15.0))
        path.addCurve(to: CGPoint(x: 63.0,  y:54.0) , controlPoint1: CGPoint(x: 112.4 , y: 36.9), controlPoint2: CGPoint(x:89.7,  y:60.8))
        path.addCurve(to: CGPoint(x: 27.0,  y:53.0), controlPoint1:CGPoint(x: 52.3 , y: 51.3), controlPoint2: CGPoint(x:42.2, y:42.0) )
        path.addCurve(to:CGPoint(x:5.0,  y:40.0) , controlPoint1:CGPoint(x:9.6 , y:65.6) , controlPoint2: CGPoint(x:5.4,  y:58.3))
        path.addCurve(to: CGPoint(x: 36.0, y:12.0), controlPoint1: CGPoint(x: 4.6 , y: 22.0), controlPoint2: CGPoint(x:  19.1, y: 9.7))
        path.addCurve(to: CGPoint(x:89.0, y: 14.0), controlPoint1: CGPoint(x: 59.2 ,y: 15.2), controlPoint2: CGPoint(x: 61.9,  y: 31.5))
        path.addCurve(to: CGPoint(x: 104.0,  y:15.0), controlPoint1: CGPoint(x: 95.3 , y: 10.0), controlPoint2: CGPoint(x:100.9,  y: 6.9))
        path.lineWidth = 1.0
        path = path.fit(into: rect).moveCenter(to: rect.center)
        if let card = self.card {
            switch  card.setShading{
            case .filled :
                setColor.setFill()
                path.fill()
            case .empty:
                path.lineWidth = bounds.width/CGFloat(75)
                setColor.setStroke()
                path.stroke()
            case .stripe:
                setColor.setStroke()
                path.stroke()
                path.lineWidth = bounds.width/CGFloat(75)
                if let context = UIGraphicsGetCurrentContext() {
                    context.saveGState()
                    path.addClip()
                    let stripePath = UIBezierPath()
                    let lineNum = 50
                    let lineMargin = bounds.width/CGFloat(lineNum*2/3)
                    var startPoint = CGPoint(x: lineMargin, y: 0)
                    stripePath.lineWidth = bounds.width/CGFloat(200)
                    for _ in 0..<lineNum {
                        stripePath.move(to: startPoint)
                        stripePath.addLine(to: CGPoint(x: startPoint.x, y: bounds.height))
                        startPoint.x += lineMargin
                    }
                    setColor.setStroke()
                    stripePath.stroke()
                    context.restoreGState()
                }
            }
        }
    }
}
