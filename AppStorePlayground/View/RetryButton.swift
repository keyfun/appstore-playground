//
//  RetryButton.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/18/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import UIKit

final class RetryButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        setTitle(locale("retry"), for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.lightGray, for: .highlighted)
    }
    
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                layer.borderColor = UIColor.lightGray.cgColor
            case false:
                layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
}

