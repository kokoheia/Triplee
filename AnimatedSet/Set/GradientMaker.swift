//
//  BackgroundMaker.swift
//  Set
//
//  Created by Kohei Arai on 2018/03/12.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import Foundation
import UIKit

class GradientMaker {
    
    static func makeBackgroundGradient(view: UIView) {
        makeGradient(color1: UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0).cgColor, color2: UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0).cgColor, point1:  CGPoint(x: 0.2, y: 0.2), point2: CGPoint(x: 1.2, y: 1.2), view: view)
    }
    
    
    
    static func makeOrangeGradient(view: UIView) {
        makeGradient(color1: hexStringToUIColor(hex: "F8F5F4").cgColor, color2: hexStringToUIColor(hex: "72562C").cgColor, point1: CGPoint(x: -0.8, y: 0.7), point2: CGPoint(x: 0.6, y: 0.7), view: view)
    }
    
    static func makePurpleGradient(view: UIView) {
        makeGradient(color1: hexStringToUIColor(hex: "F8F5F4").cgColor, color2: hexStringToUIColor(hex: "382660").cgColor, point1: CGPoint(x: -0.8, y: 0.7), point2: CGPoint(x: 0.6, y: 0.7), view: view)
    }
    
    static func makeGradient(color1: CGColor, color2: CGColor, point1: CGPoint, point2: CGPoint, view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = point1
        gradientLayer.endPoint = point2
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.clipsToBounds = true
    }
}


extension GradientMaker {
    //https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
    static func hexStringToUIColor (hex:String) -> UIColor {
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
