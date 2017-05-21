//
//  myView.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 12/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class boardView: UIView, UIGestureRecognizerDelegate{

    var vc = MainController()
    var lastLocation = CGPoint(0,0)
    var boardScale = CGFloat(0)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        lastLocation = self.center
        let panRecoqnizer = UIPanGestureRecognizer(target: self, action:#selector(self.detectPan(_:)))
        self.addGestureRecognizer(panRecoqnizer)
        
        let tapRecoqnizer = UITapGestureRecognizer(target: self, action:#selector(self.detectTap(_:)))
        self.addGestureRecognizer(tapRecoqnizer)
        self.isUserInteractionEnabled = true
    
        let pinchRecongnizer = UIPinchGestureRecognizer(target: self, action:#selector(self.detectPinch(_:)))
        pinchRecongnizer.delegate = self
        self.addGestureRecognizer(pinchRecongnizer)
        
        
        layer.allowsEdgeAntialiasing = true
        self.isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func detectPinch(_ sender: UIPinchGestureRecognizer? = nil)
    {
        if sender?.state == .ended
        {
            boardScale = (sender?.scale)!
            
            if boardScale > 1.5
            {
                boardScale = 1.5
            }
            
            if boardScale < 0.7
            {
                boardScale = 0.7
            }
        }
        else if sender?.state == .began && boardScale != 0.0
        {
            sender?.scale = boardScale
        }
        
        if sender?.scale != CGFloat.nan && sender?.scale != 0.0
        {
            if((sender?.scale)! >= CGFloat(0.7) && (sender?.scale)! <= CGFloat(1.5))
            {
            self.transform = CGAffineTransform(scaleX: (sender?.scale)!, y: (sender?.scale)!)
            }
        }
    }
    
    func detectPan(_ sender: UIPanGestureRecognizer? = nil)
    {
        if vc.selectedDrawing.active != true
        {
        let translation = sender?.translation(in: self.superview)
        self.center = CGPoint(lastLocation.x + (translation?.x)!, lastLocation.y + (translation?.y)!)
            if(sender?.state == UIGestureRecognizerState.ended)
            {
                vc.lastLocation = self.center
                lastLocation = self.center
            }
        }
        print("board MOVED")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for note in vc.noteList
        {
            if(note.transform.a != 1)
            {
            note.transform = CGAffineTransform(scaleX: 1, y: 1)
            note.isUserInteractionEnabled = false
            note.textField.isUserInteractionEnabled = false
            note.textField.resignFirstResponder()
            }
        }
        
        for image in vc.imageList
        {
            image.transform = CGAffineTransform(scaleX: 1, y: 1)
            image.imageOptions.removeFromSuperview()
        }
        
        for drawing in vc.drawList
        {
            drawing.transform = CGAffineTransform(scaleX: 1, y: 1)
            drawing.active = false
        }
        
        print("BOARD: Touch Begin")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for note in vc.noteList
        {
            note.isUserInteractionEnabled = true
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for note in vc.noteList
        {
            note.isUserInteractionEnabled = true
        }
        print("BOARD: END TOUCH")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for note in vc.noteList
        {
            note.isUserInteractionEnabled = true
        }
        print("BOARD: Cancel Touch")
    }
    
    func detectTap(_ sender: UITapGestureRecognizer? = nil)
    {
        print("BOARD: Tap")
        
        if(vc.menuOpen)
        {
            vc.OpenAddMenu()
        }
        
        if(vc.boardMenuOpen)
        {
            vc.OpenBoardMenu()
        }
    }
}
