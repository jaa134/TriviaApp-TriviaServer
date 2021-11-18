//
//  GameViewController.swift
//  TriviaGame
//
//  Created by Jacob Alspaw on 4/4/19.
//  Copyright © 2019 EECS 345 Group. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    private var numberLabel: UILabel!
    private var questionLabel: UILabel!
    private var scrollView: UIScrollView!
    private var answerButtons: [AnswerButton]!
    
    private var numCorrectlyAnswered: Int!
    private var correctAnswerIndex: Int!
    private var currentQuestionIndex: Int!
    private var currentQuestion: Trivia {
        return TriviaData.singleton.response.results[currentQuestionIndex]
    }
    private var numAnswers: Int {
        return currentQuestion.incorrect_answers.count + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        restartGame()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        setControllerStyles()
        createNumberLabel()
        createQuestionLabel()
        createScrollView()
    }
    
    private func restartGame() {
        numCorrectlyAnswered = 0
        currentQuestionIndex = -1
        nextTrivia()
    }
    
    private func setControllerStyles() {
        view.backgroundColor = UIColor.gray
    }
    
    private func createNumberLabel() {
        numberLabel = UILabel()
        numberLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        numberLabel.textColor = UIColor.white
        numberLabel.numberOfLines = 1
        numberLabel.textAlignment = .center
        numberLabel.baselineAdjustment = .alignCenters
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(numberLabel)
        
        view.addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 15))
        numberLabel.addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35))
    }
    
    private func createQuestionLabel() {
        questionLabel = UILabel()
        questionLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        questionLabel.textColor = UIColor.white
        questionLabel.numberOfLines = 5
        questionLabel.textAlignment = .center
        questionLabel.baselineAdjustment = .alignCenters
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionLabel)
        
        view.addConstraint(NSLayoutConstraint(item: questionLabel, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: questionLabel, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: questionLabel, attribute: .top, relatedBy: .equal, toItem: numberLabel, attribute: .bottom, multiplier: 1, constant: 0))
        questionLabel.addConstraint(NSLayoutConstraint(item: questionLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
    
    private func createScrollView() {
        scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .white
        scrollView.backgroundColor = UIColor.darkGray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: questionLabel, attribute: .bottom, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    private func createAnswerButtons() {
        if (answerButtons != nil) {
            answerButtons.forEach({ $0.removeFromSuperview() })
        }
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 50)
        answerButtons = [AnswerButton]()
        for _ in 0..<numAnswers {
            let button = AnswerButton(frame: rect)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            answerButtons.append(button)
            scrollView.addSubview(button)
            scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 10))
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width - 20))
        }
        
        scrollView.addConstraint(NSLayoutConstraint(item: answerButtons[0], attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 10))
        for i in 1..<answerButtons.count {
            scrollView.addConstraint(NSLayoutConstraint(item: answerButtons[i], attribute: .top, relatedBy: .equal, toItem: answerButtons[i - 1], attribute: .bottom, multiplier: 1, constant: 10))
        }
    }
    
    @objc func buttonPressed(sender: AnswerButton) {
        guard let selectedAnswerIndex = answerButtons.firstIndex(of: sender) else { return }
        
        answerButtons.forEach({
            $0.removeTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            $0.hlColor = $0.bgColor
        })
        
        let isCorrect = selectedAnswerIndex == correctAnswerIndex
        if isCorrect {
            numCorrectlyAnswered += 1
            sender.bgColor = UIColor(red: 119/255.0, green: 221/255.0, blue: 119/255.0, alpha: 1)
        }
        else {
            sender.bgColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 97/255.0, alpha: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.nextTrivia()
        })
    }
    
    private func setQuestionText() {
        numberLabel.text = "QUESTION " + String(currentQuestionIndex + 1)
        questionLabel.text = TriviaData.singleton.response.results[currentQuestionIndex].question.html2String
        questionLabel.sizeToFit()
    }
    
    private func setAnswerText() {
        var options = [String]()
        options.append(currentQuestion.correct_answer)
        options.append(contentsOf: currentQuestion.incorrect_answers)
        options.shuffle()
        
        correctAnswerIndex = options.firstIndex(of: currentQuestion.correct_answer)
        for i in 0..<numAnswers {
            answerButtons[i].setTitle(options[i].html2String, for: .normal)
        }
    }
    
    private func updateScrollHeight() {
        var height: CGFloat = 0
        answerButtons.forEach({ height += $0.bounds.height })
        let padding: CGFloat = CGFloat((numAnswers + 1) * 10)
        scrollView.contentSize = CGSize(width: 0, height: height + padding)
    }
    
    private func nextTrivia() {
        currentQuestionIndex += 1
        
        if (currentQuestionIndex >= TriviaData.singleton.response.results.count) {
            performSegue(withIdentifier: "toResults", sender: nil)
            return
        }
        
        setQuestionText()
        createAnswerButtons()
        setAnswerText()
        updateScrollHeight()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResults" {
            guard let resultsViewController = segue.destination as? ResultsViewController else { return }
            resultsViewController.numCorrectlyAnswered = numCorrectlyAnswered
        }
    }
    
}


