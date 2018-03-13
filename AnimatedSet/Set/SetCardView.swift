//
//  SetCardView.swift
//  Set
//
//  Created by Kohei Arai on 2018/02/23.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

protocol AnimatedSetCardView: class {
    func hide()
    func show()
}

@IBDesignable
class SetCardView: UIView {
    
    var card: Card? {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var delegate: AnimatedSetCardView?
    var mode = 2
    
    @IBInspectable
    var suit: String = "oval" { didSet {setNeedsDisplay(); setNeedsLayout()}}

    @IBInspectable
    var color: UIColor = UIColor.red{ didSet {setNeedsDisplay(); setNeedsLayout()}}

    @IBInspectable
    var shading: String = "striped"{ didSet {setNeedsDisplay(); setNeedsLayout()}}

    @IBInspectable
    var number: Int = 3{ didSet {setNeedsDisplay(); setNeedsLayout()}}

    var isFaceUp = false { didSet {setNeedsDisplay(); setNeedsLayout()}}

    
    lazy var setColor = { () -> UIColor in
            if let card = self.card {
                switch card.setColor {
                case .red :
                    return hexStringToUIColor(hex: "#AE5757")//E8556E
                case .green :
                    return hexStringToUIColor(hex:"#476920")//30A576
                case .blue:
                    return hexStringToUIColor(hex:"#4460AC")//315B8E
                }
        }
        return UIColor.black
    }()
    
    
    private func drawSquiggle(cx: CGFloat, cy: CGFloat, rect: CGRect, card: Card) {
        if isFaceUp {
            let width = rect.maxX*2/3
            let height = rect.maxY/5
            let squiggleView = SquiggleView(frame: CGRect(x: cx, y: cy, width: width, height: height), card: card)
            squiggleView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            addSubview(squiggleView)
        }
    }
    
    private func drawDia(cx: CGFloat, cy: CGFloat, rect: CGRect) {
        let path = UIBezierPath()
        let width = rect.maxX*2/3
        let height = rect.maxY/5
        path.move(to: CGPoint(x: cx, y:cy-height/2))
        path.addLine(to: CGPoint(x: cx-width/2, y: cy))
        path.addLine(to: CGPoint(x:cx, y: cy+height/2))
        path.addLine(to: CGPoint(x: cx + width/2, y: cy))
        path.addLine(to: CGPoint(x: cx, y: cy-height/2))
        path.lineWidth = 1.0
        drawShading(in: path)
    }
    
    private func drawOval(cx: CGFloat, cy: CGFloat, rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: cx*2/5, y: cy*4/5, width: rect.maxX*3/5, height: rect.maxY/5), cornerRadius: 50)
        drawShading(in: path)
    }
    private func drawCircle(cx: CGFloat, cy: CGFloat, rect: CGRect) {
        let lineLen = rect.width < rect.height ? rect.width * 1/3.5 : rect.height * 1/3.5
        let originX = cx - lineLen / 2
        let originY = cy - lineLen / 2
        let path = UIBezierPath(ovalIn: CGRect(x: originX, y: originY, width: lineLen, height: lineLen))
        drawShading(in: path)
    }
    
    private func drawTriangle(cx: CGFloat, cy: CGFloat, rect: CGRect) {
        let lineLen = rect.width < rect.height ? rect.width * 1/3.5 : rect.height * 1/3.5
        let topPoint = CGPoint(x: cx, y: cy-lineLen/2)
        let bottomRightPoint = CGPoint(x: cx+lineLen/2, y: cy+lineLen/2)
        let bottomLeftPoint = CGPoint(x: cx-lineLen/2, y: cy+lineLen/2)
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addLine(to: bottomRightPoint)
        path.addLine(to: bottomLeftPoint)
        path.addLine(to: topPoint)
        drawShading(in: path)
    }
    
    private func drawSquare(cx: CGFloat, cy: CGFloat, rect: CGRect) {
        let lineLen = rect.width < rect.height ? rect.width * 1/3.5 : rect.height * 1/3.5
        let containerRect = CGRect(x: cx-lineLen/2, y: cy-lineLen/2, width: lineLen, height: lineLen)
        let path = UIBezierPath(roundedRect: containerRect, cornerRadius: containerRect.width/5)
        drawShading(in: path)
    }
    

    private func drawShading(in path: UIBezierPath) {
        if let card = self.card {
            switch card.setShading {
            case .filled:
                setColor.setFill()
                path.fill()
            case .empty:
                path.lineWidth = bounds.width/CGFloat(75)
                setColor.setStroke()
                path.stroke()
            case .stripe:
                path.lineWidth = bounds.width/CGFloat(75)
                setColor.setStroke()
                path.stroke()
                if let context = UIGraphicsGetCurrentContext() {
                    drawStripeShading(path, with: context)
                }
            }
        }
    }
    
    private func drawStripeShading(_ path: UIBezierPath, with context: CGContext) {
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
    
    
    enum SetCardState {
        case unselected
        case selected
        case selectedAndMatched
        case hinted
    }
    
    var setCardState: SetCardState = .unselected {
        didSet {
            
            switch setCardState {
            case .selected:
                self.layer.borderWidth = 0
                self.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.49).cgColor
//                self.layer.borderColor = UIColor.blue.cgColor
            case .unselected:
                self.layer.backgroundColor = UIColor.clear.cgColor
                self.layer.borderWidth = bounds.width/100
                self.layer.borderColor = UIColor.white.cgColor
            case .hinted:
                self.layer.borderWidth = 3.0
                self.layer.borderColor = UIColor.red.cgColor
            case .selectedAndMatched:
                self.layer.borderWidth = 3.0
                self.layer.borderColor = UIColor.orange.cgColor
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
//        self.layer.cornerRadius = bounds.width / 10
//        self.layer.masksToBounds = true;
        self.layer.borderWidth = bounds.width / 100
        self.layer.borderColor = UIColor.white.cgColor
        let transparent = { () -> UIColor in
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            return  UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }()
        
        let color = isFaceUp == true ? transparent : hexStringToUIColor(hex: "#9D9D9D")
        color.setFill()
        UIRectFill(bounds)
        if let card = card {
            if isFaceUp{
//                backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                if mode == 1 {
                    switch card.setSuit {
                    case .squiggle:
                        switch card.numberOfSetSuit{
                        case .one:
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*3.2/4, rect: bounds, card: card)
                        case .two:
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*4.2/4, rect: bounds, card: card)
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*2.2/4, rect: bounds, card: card)
                        case .three:
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*1.2/4, rect: bounds, card: card)
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*3.2/4, rect: bounds, card: card)
                            drawSquiggle(cx: bounds.midX/3, cy: bounds.midY*5.2/4, rect: bounds, card: card)
                        }
                    case .dia :
                        switch card.numberOfSetSuit{
                        case .one:
                            drawDia(cx: bounds.midX, cy: bounds.midY, rect: bounds)
                        case .two:
                            drawDia(cx: bounds.midX, cy: bounds.height*1.5/4,rect: bounds)
                            drawDia(cx: bounds.midX, cy: bounds.height*2.5/4,rect: bounds)
                        case .three:
                            drawDia(cx: bounds.midX, cy: bounds.height*1.5/6,rect: bounds)
                            drawDia(cx: bounds.midX, cy: bounds.height*3/6,rect: bounds)
                            drawDia(cx: bounds.midX, cy: bounds.height*4.5/6,rect: bounds)
                        }
                    case .oval :
                        switch card.numberOfSetSuit{
                        case .one:
                            drawOval(cx: bounds.midX, cy: bounds.midY, rect: bounds)
                        case .two:
                            drawOval(cx: bounds.midX, cy: bounds.height/3, rect: bounds)
                            drawOval(cx: bounds.midX, cy: bounds.height*2/3, rect: bounds)
                        case .three:
                            drawOval(cx: bounds.midX, cy: bounds.height/6, rect: bounds)
                            drawOval(cx: bounds.midX, cy: bounds.height*3/6, rect: bounds)
                            drawOval(cx: bounds.midX, cy: bounds.height*5/6, rect: bounds)
                        }
                    }
                } else if mode == 2 {
                    //squiggle -> square, dia-> triangle, oval->circle
                    switch card.setSuit {
                    case .squiggle:
                        switch card.numberOfSetSuit{
                        case .one:
                            drawSquare(cx: bounds.midX, cy: bounds.midY, rect: bounds)
                        case .two:
                            drawSquare(cx: bounds.midX, cy: bounds.height*1.5/4,rect: bounds)
                            drawSquare(cx: bounds.midX, cy: bounds.height*2.5/4,rect: bounds)
                        case .three:
                            drawSquare(cx: bounds.midX, cy: bounds.height*1.5/6,rect: bounds)
                            drawSquare(cx: bounds.midX, cy: bounds.height*3/6,rect: bounds)
                            drawSquare(cx: bounds.midX, cy: bounds.height*4.5/6,rect: bounds)
                        }
                    case .dia :
                        switch card.numberOfSetSuit{
                        case .one:
                            drawTriangle(cx: bounds.midX, cy: bounds.midY, rect: bounds)
                            
                        case .two:
                            drawTriangle(cx: bounds.midX, cy: bounds.height*1.5/4,rect: bounds)
                            drawTriangle(cx: bounds.midX, cy: bounds.height*2.5/4,rect: bounds)
                        case .three:
                            drawTriangle(cx: bounds.midX, cy: bounds.height*1.5/6,rect: bounds)
                            drawTriangle(cx: bounds.midX, cy: bounds.height*3/6,rect: bounds)
                            drawTriangle(cx: bounds.midX, cy: bounds.height*4.5/6,rect: bounds)
                        }
                    case .oval :
                        switch card.numberOfSetSuit{
                        case .one:
                            drawCircle(cx: bounds.midX, cy: bounds.midY, rect: bounds)
                        case .two:
                            drawCircle(cx: bounds.midX, cy: bounds.height * 1.05/3, rect: bounds)
                            drawCircle(cx: bounds.midX, cy: bounds.height * 1.95/3, rect: bounds)
                        case .three:
                            drawCircle(cx: bounds.midX, cy:  bounds.height * 1.45/6, rect: bounds)
                            drawCircle(cx: bounds.midX, cy: bounds.height * 3/6, rect: bounds)
                            drawCircle(cx: bounds.midX, cy: bounds.height * 4.55/6, rect: bounds)
                        }
                    }
                }
            }
        }
    }
}

extension UIView {
    //https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
    



