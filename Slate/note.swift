//
//  myView.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 12/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class note: UIView, UITextViewDelegate{

    //Mark: Variables
    var lastLocation:CGPoint = CGPoint(0,0)
    var vc = MainController()
    
    
    var thisID: Int64 = 0
    var thisText: String = ""
    var thisPosition: String = ""
    var thisColor: UIColor = UIColor()
    
    let textField:UITextView = UITextView()
    
    
    //Mark: Initiation
    override init(frame: CGRect){
        super.init(frame: frame)

        let panRecoqnizer = UIPanGestureRecognizer(target: self, action:#selector(self.detectPan(_:)))
        self.addGestureRecognizer(panRecoqnizer)
        
        let tapRecoqnizer = UITapGestureRecognizer(target: self, action:#selector(self.detectTap(_:)))
        self.addGestureRecognizer(tapRecoqnizer)
        
        textField.delegate = self
        
        //Create Textfield
        textField.frame = CGRect(0,0,self.bounds.maxX, self.bounds.maxY)
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = UIColor.clear
        self.addSubview(textField)
        self.layer.shadowOpacity = 0
        //self.transform = CGAffineTransform(rotationAngle: 45)   
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: Functions
    func textViewDidEndEditing(_ textView: UITextView) {
        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        Update()
    }
    
    func detectPan(_ sender: UIPanGestureRecognizer? = nil)
    {
        textField.isUserInteractionEnabled = false;
        let translation = sender?.translation(in: self.superview)
        self.center = CGPoint(lastLocation.x + (translation?.x)!, lastLocation.y + (translation?.y)!)
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(0,10.0)
       // self.layer.shouldRasterize = true;
            if(sender?.state == UIGestureRecognizerState.ended)
            {
            //If moved outside of the slates area will be deleted
            if(self.center.x > 0 && self.center.x < (superview?.frame.width)! && self.center.y > 0 && self.center.y < (superview?.frame.height)!)
            {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layer.shadowOpacity = 0
                Update()
            }
            else
            {
                Remove()
            }
            }
    }
    
    func detectTap(_ sender: UITapGestureRecognizer? = nil)
    {
        print("TAP NOTE")
        textField.isUserInteractionEnabled = true;
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        //vc.NextView()
    }
    
    func Update()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "id == %i", (self.thisID))
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count == 1)
            {
                let managedObject = data[0]
                
                let newLocation: CGPoint = CGPoint(self.center.x - (self.frame.width/2),self.center.y - (self.frame.height/2))
                managedObject.setValue(NSStringFromCGPoint(newLocation), forKey: "position")
                managedObject.setValue(textField.text, forKey: "text")
            }
            try managedContext.save()
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
        print("UPDATE: \(self.thisID) at pos \(self.center)")
    }
    
    //Remove from both view and Core Data
    func Remove()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let noteFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        noteFetchRequest.predicate = NSPredicate(format: "id == %i", (self.thisID))
        do{
            let data = try managedContext.fetch(noteFetchRequest)
            if(data.count > 0)
            {
                for datas in data
                {
                    managedContext.delete(datas)
                }
            }
            try managedContext.save()
        } catch _ as NSError
        {
            print("ISSUE deleting")
        }
        
        let index = vc.noteList.index(of: self)
        vc.noteList.remove(at: index!)
        self.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        lastLocation = self.center
        print("\(self.thisID): \(self.thisPosition)")
    }
}
