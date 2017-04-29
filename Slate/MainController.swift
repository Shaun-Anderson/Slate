//
//  ViewController.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 12/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var noteList = [note]()
    var imageList = [image]()
    var drawList = [drawing]()
    
    var lastLocation:CGPoint = CGPoint(0,0)
    var menuOpen = false
    
    var controlview = UIView()
    var board = UIView()
    var currentBoardName = "My Slate"
    
    var newImage = UIImageView()
    var selectedImage = UIImage()
    var selectedImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Board
        let newboard = boardView(frame: CGRect(self.view.center.x - 500, self.view.center.y - 400,1000,700))
        newboard.vc = self
        newboard.backgroundColor = UIColor.lightGray
        newboard.autoresizesSubviews = true
        board = newboard
        board.center = self.view.center
        self.view.addSubview(board)
        CreateBoard(name: "My Slate")
        
        //Create Add Menu
        let newControl = controlView(frame: CGRect(self.view.frame.width, 0,64,1000))
        newControl.vc = self
        newControl.autoresizingMask = [ .flexibleLeftMargin,.flexibleBottomMargin]
        newControl.autoresizesSubviews = true
        controlview = newControl
        self.view.addSubview(controlview)
        controlview.layer.zPosition = CGFloat.greatestFiniteMagnitude
        LoadNote()
 
        
        //Create Add Menu Button
        let addMenuButton = UIButton(frame: CGRect(self.view.frame.width - 100,50,64,64))
        addMenuButton.backgroundColor = UIColor.blue
        addMenuButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        addMenuButton.addTarget(self, action: #selector(self.OpenMenu), for: .touchUpInside)
        self.view.addSubview(addMenuButton)
        
        
        
        //Create Menu Button
        let menuButton = UIButton(frame: CGRect(self.view.frame.width - 100,50,64,64))
        menuButton.backgroundColor = UIColor.blue
        menuButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        menuButton.addTarget(self, action: #selector(self.OpenMenu), for: .touchUpInside)
        self.view.addSubview(menuButton)
        
        //Create Menu
        
        
        /*let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames
        {
            print("---------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
        */
        
        let hi = drawing(frame: CGRect(self.view.frame.midX,500,200,200))
        drawList.append(hi)
        hi.backgroundColor = UIColor.white
        board.addSubview(hi)
    }
    
    func OpenMenu()
    {
        menuOpen = !menuOpen
        if(menuOpen)
        {
           UIView.animate(withDuration: 0.25, animations: {self.controlview.frame = CGRect(self.view.frame.width - 100,0,64,1000)}, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.25, animations: {self.controlview.frame = CGRect(self.view.frame.width,0,64,1000)}, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Will check through current data to ensure you do not create a board with the same name
    func CreateBoard(name: String)
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
    
    func SaveImage(data: String, width: Double, height: Double)
    {
        
    }
    
    
    func save(name: String, backColor: String, text: String)
    {
        print("SAVING: \(name)")
        guard let AppDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContext = AppDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)
        let note = NSManagedObject(entity: entity!, insertInto: managedContext)
        note.setValue(name, forKey: "position")
        note.setValue(noteList.count, forKey: "id")
        note.setValue(backColor, forKey: "color")
        note.setValue(text, forKey: "text")
        do{ try managedContext.save() } catch _ as NSError { print("Error saving") }
    }
    
    func LoadNote()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count > 0)
            {
                for datas in data
                {
                    //Get data
                    let location = CGPointFromString(datas.value(forKey: "position") as! String)
                    
                    //Create Notes From Data
                    let newView = note(frame: CGRect(location.x, location.y,100,100))
                    newView.vc = self
                    
                    newView.thisID = datas.value(forKey: "id") as! Int64
                    newView.backgroundColor = UIColor(hex: datas.value(forKey: "color") as! String)
                    
                    board.addSubview(newView)
                    noteList.append(newView)
                    print("LOADED: \(newView.thisID) at pos: \(location)")
                }
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }
    
    //Grabs numNotes from board data and then adds its as the notes id to ensure its always unique and makes it easy to grab the specifc note from Core Data.
    func AddNote()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentBoardName)
        //ADD PREDICATION FOR OTHER BOARDS
        do{
            let data = try managedContext.fetch(fetchRequest)
            if(data.count > 0)
            {
                //Get note amount
                let noteID = data[0].value(forKey: "numNotes") as! Int
                data[0].setValue((noteID) + 1, forKey: "numNotes")
 
                let newView = note(frame: CGRect(450,300,100,100))
                newView.vc = self
                newView.layer.zPosition = 0
                newView.thisID = Int64(noteID)
                
                newView.backgroundColor = UIColor.white
                
                let color = newView.backgroundColor
                let hexColor = color?.toHexString
                
                
                //Add view as subview and to list of notes
                board.addSubview(newView)
                noteList.append(newView)
                save(name: NSStringFromCGPoint(newView.center), backColor: hexColor!, text: "")
                print("Created Note")
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }
    
    func AddImage()
    {
        let newView = image(frame: CGRect(450,300,200,150))
        newView.vc = self
        newView.layer.zPosition = 0
        newView.layer.borderWidth = 2
        newView.layer.borderColor = UIColor.white.cgColor
        newImage = newView
        imageList.append(newView)
        OpenImagePicker(delegate: self)
    }
    
    func OpenImagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    {
        let image = UIImagePickerController()
        image.modalPresentationStyle = .overCurrentContext
        image.delegate = delegate
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    func ImageSelected()
    {
        
    }
 
    
    public func NextView()
    {
        print("NEXT SCENE")
        performSegue(withIdentifier: "editSeg", sender: nil)
    }
    
    //Clears the data from history
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            if(data.count > 0)
            {
                for datas in data
                {
                    managedContext.delete(datas)
                }
            }
        } catch _ as NSError
        {
            print("ISSUE deleting")
        }
        
        do{
            try managedContext.save()
        } catch _ as NSError
        {
            print("Error saving")
        }
        
        for note in noteList
        {
            noteList.removeAll()
            note.removeFromSuperview()
        }
    }
    
    
    //Rebuild the control parts if device is rotated
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil)
        { _ in
            
            self.board.center = self.view.center
        }
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if let foundImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImage = foundImage
            newImage.image = selectedImage
            board.addSubview(newImage)
            
        }
        else
        {
            selectedImage = UIImage()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
