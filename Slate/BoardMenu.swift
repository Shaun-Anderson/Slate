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
        
        //Create buttons
        let homeButton = UIButton(frame: CGRect(0,129,64,64))
        homeButton.backgroundColor = UIColor.red
        homeButton.addTarget(vc, action: #selector(self.ReturnHome), for: .touchUpInside)
        homeButton.setTitle("Home", for: .normal)
        homeButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(homeButton)
        
        let clearButton = UIButton(frame: CGRect(0,208,64,64))
        clearButton.backgroundColor = UIColor.red
        clearButton.addTarget(vc, action: #selector(self.ClearBoard), for: .touchUpInside)
        clearButton.setTitle("Clear", for: .normal)
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
        
        //Get note for this board
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
    }

}
