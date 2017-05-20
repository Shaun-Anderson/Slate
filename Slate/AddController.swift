//
//  AddController.swift
//  Slate
//
//  Created by Shaun Anderson on 10/05/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class AddController: UIViewController {
    @IBOutlet weak var boardNameTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CheckSave()
    {
        //check if name is empty
        
        if(boardNameTextfield.text != "")
        {
            SaveBoard(name: boardNameTextfield.text!)
        }
    }
    
    @IBAction func Cancel()
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "menu") as! MenuController
        present(newVC, animated: true, completion: nil)
    }
    
    func SaveBoard(name: String)
    {
        guard let AppDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count == 0)
            {
                let entity = NSEntityDescription.entity(forEntityName: "Board", in: managedContext)
                let slate = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                slate.setValue(name, forKey: "name")
                slate.setValue(0, forKey: "numNotes")
                
                do{
                    try managedContext.save()
                } catch _ as NSError
                {
                    print("Error saving")
                }
                print("CREATED SLATE NAMED: \(name)")
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainController
                newVC.currentBoardName = name
                present(newVC, animated: true, completion: nil)
            }
            else
            {
                print("Slate already exists")
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }

}
