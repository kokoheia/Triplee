//
//  GameOverViewController.swift
//  Set
//
//  Created by Kohei Arai on 2018/03/12.
//  Copyright © 2018年 新井康平. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        replayButton.layer.cornerRadius = 25
        homeButton.image = UIImage(named: "homeicon")
       
        scoreLabel.text = "Your Score: \(game.score)"
        
        GradientMaker.makeBackgroundGradient(view: view)
        GradientMaker.makePurpleGradient(view: replayButton)
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchHomeIcon))
        homeButton.addGestureRecognizer(tap)
        if bestScore >=  newScore {

            isBestScore = false
        } else {
            game.bestScore = newScore
            isBestScore = true
        }
        writeGameOverText()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeButton: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    
    var isBestScore = true
    lazy var newScore = game.score
    lazy var bestScore = game.bestScore
    
    func writeGameOverText() {
        if isBestScore {
            titleText.text = "New Score!"
            titleText.textColor = UIColor.init(patternImage: UIImage(named: "pinkOrange")!)
        } else {
             titleText.text = "Game Over"
             titleText.textColor = UIColor.init(patternImage: UIImage(named: "purpleBlue")!)
        }
    }

    
    var game = Set() 
    
    @objc private func touchHomeIcon() {
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "replay" {
            if let gameVC = segue.destination as? ViewController {
                gameVC.game = self.game
            }
        } else if segue.identifier == "backToHome" {
                if let homeVC = segue.destination as? HomeViewController {
                    homeVC.game = self.game
                }
            }
        }
    }
