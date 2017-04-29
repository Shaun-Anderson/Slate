//
//  ImageView.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 15/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

//  Image with gesture recongnizers and functions to handle.

import UIKit

class drawing: UIImageView {
    
    //Mark: Variables
    var lastLocation:CGPoint = CGPoint(0,0)
    var lastPoint = CGPoint.zero
    var vc = MainController()
    var imageOptions = Edit_imageView()
    
    //  Core data related variables
    var width = CGFloat()
    var height = CGFloat()
    var active = false
    
    var scale : CGFloat = 1.0
    
    //Mark: Initiation
    override init(frame: CGRect){
        super.init(frame: frame)
        
       let panRecoqnizer = UIPanGestureRecognizer(target: self, action:#selector(self.detectPan(_:)))
        panRecoqnizer.cancelsTouchesInView = false
       self.addGestureRecognizer(panRecoqnizer)
        
        let tapRecoqnizer = UITapGestureRecognizer(target: self, action:#selector(self.detectTap(_:)))
        self.addGestureRecognizer(tapRecoqnizer)
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        lastLocation = self.center
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: Functions
    func detectPan(_ sender: UIPanGestureRecognizer? = nil)
    {
        if active == false
        {
        let translation = sender?.translation(in: self.superview)
        self.center = CGPoint(lastLocation.x + (translation?.x)!, lastLocation.y + (translation?.y)!)
        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(0,10.0)
        self.layer.shouldRasterize = true;
        
        if(sender?.state == UIGestureRecognizerState.ended)
        {
            //If moved outside of the slates area will be deleted
            if(self.center.x > 0 && self.center.x < (superview?.frame.width)! && self.center.y > 0 && self.center.y < (superview?.frame.height)!)
            {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layer.shadowOpacity = 0
                //Update()
            }
            else
            {
                //Remove()
            }
        }
        }
    }
    
    func Update()
    {
    
    }
    
    func Remove()
    {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Draw: Touch begin")
        if let touch = touches.first
        {
            lastPoint = touch.location(in: self)
        }
        lastLocation = self.center
    }
    
    func detectTap(_ sender: UITapGestureRecognizer? = nil)
    {
        print("TAP IMAGE")
        if vc.selectedImageView != self
        {
            vc.selectedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        self.center = CGPoint((self.superview?.center.x)!, (self.superview?.center.y)!)
        self.transform = CGAffineTransform(scaleX: 2, y: 2)
        scale = 2
        active = true
    }
    
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint)
    {
        UIGraphicsBeginImageContext(self.frame.size)
        self.image?.draw(in: CGRect(0,0, self.frame.width,self.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(fromPoint.x * scale, fromPoint.y * scale))
        context?.addLine(to: CGPoint(toPoint.x * scale,toPoint.y * scale))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, active == true
        {
            let currentPoint = touch.location(in: self)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
            print("Draw: TouchMoved")
        }
    }
}
