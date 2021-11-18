//
//  LaunchViewController.swift
//  TriviaGame
//
//  Created by Jacob Alspaw on 4/4/19.
//  Copyright © 2019 EECS 345 Group. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        loadAppData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    private func setupView() {
        setupErrorLabel()
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.text = ""
        errorLabel.textColor = UIColor.white
        errorLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        errorLabel.textAlignment = .center
        errorLabel.baselineAdjustment = .alignCenters
        errorLabel.numberOfLines = 3
        
        errorLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(retryTapped))
        tap.numberOfTapsRequired = 1
        errorLabel.addGestureRecognizer(tap)
    }
    
    @objc private func retryTapped() {
        setErrorText(msg: "")
        errorLabel.isHidden = true
        loadAppData()
    }
    
    private func loadAppData() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        TriviaData.singleton.update(onNetworkError: onNetworkError, onDataError: onDataError, onSuccess: onLoadSuccess)
    }
    
    private func onNetworkError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.setErrorText(msg: "The server could not be reached at this time.")
            self.errorLabel.isHidden = false
        })
    }
    
    private func onDataError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.setErrorText(msg: "The server encountered an error.")
            self.errorLabel.isHidden = false
        })
    }
    
    private func onLoadSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.setErrorText(msg: "")
            self.errorLabel.isHidden = true
            self.performSegue(withIdentifier: "toGame", sender: nil)
        })
    }
    
    private func setErrorText(msg: String) {
        if (!msg.isEmpty) {
            let text = NSMutableAttributedString(string: msg + " Would you like to ")
            let toUnderLineText = NSAttributedString(string: "try again?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            text.append(toUnderLineText)
            errorLabel.attributedText = text
        }
        else {
            errorLabel.text = ""
        }
        errorLabel.isHidden = false
    }

}

