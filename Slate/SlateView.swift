//
//  AndoSignatureView.swift
//  AndoSignature
//
//  Created by Shaun Anderson on 29/12/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit


@objc
public protocol SlateDelegate: class {
    func didStart(_ view : SlateView)
    func didFinish(_ view : SlateView)
}

public class SlateView: UIView {
    
    // MARK: - Public properties
    
    public weak var delegate: AndoSignatureDelegate?
    
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
    
    // MARK: - Initilisation
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        path.lineWidth = strokeWidth;
        path.lineJoinStyle = .round;
        path.lineCapStyle = .round;
        
        // Create clear button
        let button = UIButton(frame: CGRect(x: self.frame.width - 100, y: 0, width: 100, height: 50))
        button.backgroundColor = UIColor.red;
        self.addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path.lineWidth = strokeWidth;
        path.lineJoinStyle = .round;
        path.lineCapStyle = .round;
    }
    
    // MARK: - Draw
    override public func draw(_ rect: CGRect) {
        self.strokeColor.setStroke()
        self.path.stroke()
    }
    
    // MARK: - Functions
    
    public func clear()
    {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    // MARK: - Gesture overrides
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            controlPoint = 0
            points[0] = touchPoint
        }
        
        if let delegate = delegate {
            delegate.didStart(self)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            controlPoint += 1
            points[controlPoint] = touchPoint
            if (controlPoint == 4) {
                points[3] = CGPoint(x: (points[2].x + points[4].x)/2.0, y: (points[2].y + points[4].y)/2.0)
                path.move(to: points[0])
                path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
                
                setNeedsDisplay()
                points[0] = points[3]
                points[1] = points[4]
                controlPoint = 1
            }
            
            setNeedsDisplay()
        }
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if controlPoint < 4 {
            let touchPoint = points[0]
            path.move(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
            path.addLine(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
            setNeedsDisplay()
        } else {
            controlPoint = 0
        }
        
        if let delegate = delegate {
            delegate.didFinish(self)
        }    }
    
}

extension AndoSignatureDelegate {
    func didStart(_ view : AndoSignatureView) {}
    func didFinish(_ view : AndoSignatureView) {}
}
