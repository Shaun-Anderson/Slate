//
//  BoardMenu.swift
//  Slate
//
//  Created by SHAUN WARD ANDERSON on 18/05/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class BoardMenu: UIView {

    var vc = MainController()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        var img = UIImage()
        var tintedImg = UIImage()
        
        //Create buttons
        let homeButton = UIButton(frame: CGRect(0,0,52,52))
        homeButton.backgroundColor = UIColor.white
        homeButton.tintColor = UIColor.gray
        img = UIImage(named: "Home")!
        tintedImg = img.withRenderingMode(.alwaysTemplate)
        
        homeButton.addTarget(vc, action: #selector(self.ReturnHome), for: .touchUpInside)
        homeButton.layer.cornerRadius = 0.5 * homeButton.bounds.size.width
        homeButton.clipsToBounds = true
        homeButton.setImage(tintedImg, for: .normal)
        homeButton.layer.borderWidth = 2
        homeButton.layer.borderColor = UIColor.darkGray.cgColor
        homeButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(homeButton)
        
        let clearButton = UIButton(frame: CGRect(0,72,52,52))
        clearButton.backgroundColor = UIColor.white
        clearButton.addTarget(vc, action: #selector(self.ClearBoard), for: .touchUpInside)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = UIColor.darkGray.cgColor
        clearButton.layer.cornerRadius = 0.5 * clearButton.bounds.size.width
        clearButton.clipsToBounds = true
        clearButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(clearButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ReturnHome()
    {
        let newVC = vc.storyboard?.instantiateViewController(withIdentifier: "menu") as! MenuController
        vc.present(newVC, animated: true, completion: nil)
    }
    
    func ClearBoard()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        
        //Get notes for this board and delete them
        let noteFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        noteFetchRequest.predicate = NSPredicate(format: "boardName == %@", (vc.currentBoardName))
        
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
        for note in vc.noteList
        {
            vc.noteList.removeAll()
            note.removeFromSuperview()
        }
        
        //Images
        let imageFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        imageFetchRequest.predicate = NSPredicate(format: "boardName == %@", (vc.currentBoardName))
        
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
        for image in vc.imageList
        {
            vc.imageList.removeAll()
            image.removeFromSuperview()
        }
    }

}
