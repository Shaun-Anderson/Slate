

//
//  AndoSignatureView.swift
//  AndoSignature
//
//  Created by Shaun Anderson on 29/12/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

public class Slate {
    
    // MARK: - Public properties
    @IBInspectable public var strokeWidth : CGFloat = 2.0 {
        didSet {
            path.lineWidth = strokeWidth
        }
    }
    
    @IBInspectable public var strokeColor : UIColor = .black {
        didSet {
            strokeColor.setStroke()
        }
    }
    
    public var containsSignature: Bool {
        get {
            if path.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    // MARK: - Private properties
    
    fileprivate var path = UIBezierPath()
    fileprivate var points = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var controlPoint = 0
    
}
