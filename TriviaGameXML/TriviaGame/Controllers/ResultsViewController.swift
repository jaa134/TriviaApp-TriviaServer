//
//  ResultsViewController.swift
//  TriviaGame
//
//  Created by Jacob Alspaw on 4/7/19.
//  Copyright © 2019 EECS 345 Group. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var scoreLabelContainer: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    public var numCorrectlyAnswered: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        setScore()
        setPlayAgainButton()
    }
    
    private func setScore() {
        scoreLabelContainer.layer.cornerRadius = 5
        scoreLabelContainer.clipsToBounds = true
        scoreLabel.text = String(numCorrectlyAnswered) + " / " + String(TriviaData.singleton.response.results.count)
    }
    
    private func setPlayAgainButton() {
        playAgainButton.layer.cornerRadius = 5
        playAgainButton.clipsToBounds = true
    }
    
    @IBAction func onPlayAgainTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLaunch", sender: nil)
    }
}
