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

    //SEGUE FUNCTIONS
    func MoveToMain(boardName: String)
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddToMain") as! MainController
        newVC.currentBoardName = boardName
        present(newVC, animated: true, completion: nil)
    }
    
    func MoveToMenu()
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddToMenu") as! MainController
        present(newVC, animated: true, completion: nil)
    }

}
