//
//  ImageView.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 15/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

//  Image with gesture recongnizers and functions to handle.

import UIKit
import CoreData

class image: UIImageView {
    
    //Mark: Variables
    var lastLocation:CGPoint = CGPoint(0,0)
    var vc = MainController()
    var imageOptions = Edit_imageView()
    
    //  Core data related variables
    var thisImage = UIImage()
    var width = CGFloat()
    var height = CGFloat()
    var boarderWidth : Int = 0
    var thisID: Int64 = 0

    //Mark: Initiation
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let panRecoqnizer = UIPanGestureRecognizer(target: self, action:#selector(self.detectPan(_:)))
        self.addGestureRecognizer(panRecoqnizer)
        
        let tapRecoqnizer = UITapGestureRecognizer(target: self, action:#selector(self.detectTap(_:)))
        self.addGestureRecognizer(tapRecoqnizer)
        self.isUserInteractionEnabled = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: Functions
    func detectPan(_ sender: UIPanGestureRecognizer? = nil)
    {
        let translation = sender?.translation(in: self.superview)
        self.center = CGPoint(lastLocation.x + (translation?.x)!, lastLocation.y + (translation?.y)!)
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(0,10.0)
        self.layer.shouldRasterize = false;
        
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
    
    func UpdateImg(imgData: Data)
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "id == %i", (self.thisID))
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count == 1)
            {
                let managedObject = data[0]
                managedObject.setValue(imgData, forKey: "imageData")
            }
            try managedContext.save()
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
        print("UPDATE: IMAGE (\(self.thisID)) IMAGE")
    }
    
    func Update()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "id == %i", (self.thisID))
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count == 1)
            {
                let managedObject = data[0]
                let newLocation: CGPoint = CGPoint(self.center.x - (self.frame.width/2),self.center.y - (self.frame.height/2))
                managedObject.setValue(NSStringFromCGPoint(newLocation), forKey: "position")
                
            }
            try managedContext.save()
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
        print("UPDATE: IMAGE (\(self.thisID)) at pos \(self.center)")
    }
    
    func Remove()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let imageFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        imageFetchRequest.predicate = NSPredicate(format: "boardName == %@", vc.currentBoardName)
        imageFetchRequest.predicate = NSPredicate(format: "id == %i", (self.thisID))
        do{
            let data = try managedContext.fetch(imageFetchRequest)
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
        
        let index = vc.imageList.index(of: self)
        vc.imageList.remove(at: index!)
        self.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Image: Touch begin")
        self.superview?.bringSubview(toFront: self)
        lastLocation = self.center
    }
    
    func detectTap(_ sender: UITapGestureRecognizer? = nil)
    {
        print("TAP IMAGE")
        if vc.selectedImageView != self
        {
            vc.selectedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        imageOptions = Edit_imageView(frame: CGRect(vc.view.frame.midX - 250 ,30,500,60))
        imageOptions.vc = vc
        imageOptions.thisImageView = self
        imageOptions.backgroundColor = UIColor.gray
        vc.view.addSubview(imageOptions)
        
        vc.selectedImageView = UIImageView()
        vc.selectedImageView = self
    }
}

