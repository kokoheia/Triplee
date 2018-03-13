//
//  HomeViewController.swift
//  Set
//
//  Created by Kohei Arai on 2018/03/12.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var singlePlayButton: UIButton!
    @IBOutlet weak var doublePlayButton: UIButton!
    @IBOutlet weak var introductionButton: UIButton!
    
    var game = Set()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeGradientTitle()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        singlePlayButton.layer.cornerRadius = 25
        doublePlayButton.layer.cornerRadius = 25
        introductionButton.layer.cornerRadius = 25
        introductionButton.layer.borderWidth = 1
        introductionButton.layer.borderColor = hexStringToUIColor(hex: "402C6E").cgColor
        introductionButton.layer.backgroundColor = UIColor.clear.cgColor
        GradientMaker.makeBackgroundGradient(view: view)
        GradientMaker.makeOrangeGradient(view: singlePlayButton)
        GradientMaker.makePurpleGradient(view: doublePlayButton)

    }
    
    
    private func makeGradientTitle() {
        //make a gradient mask
        let attributedText = NSMutableAttributedString(string: titleHeader.text!)
        let customLetterSpacing = 10
        attributedText.addAttribute(NSAttributedStringKey.kern, value: customLetterSpacing, range: NSMakeRange(0, attributedText.length))
        titleHeader.attributedText = attributedText
        titleHeader.textColor = UIColor.init(patternImage: UIImage(named: "homeTitleGradient")!)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playGame" {
            if let gameVC = segue.destination as? ViewController {
                gameVC.game = self.game
            }
        }
    }
    

}

extension UIViewController {
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
