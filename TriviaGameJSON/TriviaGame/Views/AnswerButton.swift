//
//  AnswerButton.swift
//  TriviaGame
//
//  Created by Jacob Alspaw on 4/4/19.
//  Copyright © 2019 EECS 345 Group. All rights reserved.
//

import Foundation
import UIKit

class AnswerButton: UIButton {
    
    var hlColor = UIColor.lightGray
    var bgColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }
    
    override open var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1, animations: {
                self.backgroundColor = self.isHighlighted
                    ? self.hlColor
                    : self.bgColor
            })
        }
    }
    
    private func setupView() {
        titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.darkGray, for: .highlighted)
        titleLabel?.numberOfLines = 5
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = bgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
}
