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
    
    //Mark: Variables
    //Lists of the different objects that are on the board
    var noteList = [note]()
    var numNotes = Int()
    var imageList = [image]()
    var numImages = Int()
    var drawList = [drawing]()
    
    var lastLocation:CGPoint = CGPoint(0,0)
    
    
    var menuOpen = false
    var boardMenuOpen = false
    
    //References to the menus
    var controlview = UIView()
    var boardMenu = UIView()
    
    var board = UIView()
    var currentBoardName = "My Slate"
    
    var newImage = UIImageView()
    var selectedImage = UIImage()
    var selectedImageView = UIImageView()
    
    var selectedDrawing = UIImageView()
    
    //Mark: Functions
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
        
        //Buttons
        let addMenuButton = UIButton(frame: CGRect(self.view.frame.width - 70,50,52,52))
        addMenuButton.tintColor = UIColor.white
        let img = UIImage(named: "Add")
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        addMenuButton.backgroundColor = UIColor.gray
        addMenuButton.setImage(tintedImage, for: .normal)
        addMenuButton.layer.cornerRadius = 0.5 * addMenuButton.bounds.size.width
        addMenuButton.clipsToBounds = true
        addMenuButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        addMenuButton.addTarget(self, action: #selector(self.OpenAddMenu), for: .touchUpInside)
        self.view.addSubview(addMenuButton)
        
        let menuButton = UIButton(frame: CGRect(20,50,52,52))
        menuButton.backgroundColor = UIColor.gray
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.layer.cornerRadius = 0.5 * menuButton.bounds.size.width
        menuButton.clipsToBounds = true
        menuButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        menuButton.addTarget(self, action: #selector(self.OpenBoardMenu), for: .touchUpInside)
        self.view.addSubview(menuButton)
        
        //Create Menus
        let newBoardMenu = BoardMenu(frame: CGRect(-52, 125,52,1000))
        newBoardMenu.vc = self
        newBoardMenu.autoresizingMask = [ .flexibleLeftMargin,.flexibleBottomMargin]
        newBoardMenu.autoresizesSubviews = true
        boardMenu = newBoardMenu
        self.view.addSubview(boardMenu)
        boardMenu.layer.zPosition = CGFloat.greatestFiniteMagnitude
        
        let newControl = controlView(frame: CGRect(self.view.frame.width, 125,52,1000))
        newControl.vc = self
        newControl.autoresizingMask = [ .flexibleLeftMargin,.flexibleBottomMargin]
        newControl.autoresizesSubviews = true
        controlview = newControl
        self.view.addSubview(controlview)
        controlview.layer.zPosition = CGFloat.greatestFiniteMagnitude
        
        //Load all objects onto the board
        LoadNote()
        LoadImage()
    }
    
    func OpenAddMenu()
    {
        menuOpen = !menuOpen
        print(menuOpen)
        if(menuOpen)
        {
            UIView.animate(withDuration: 0.25, animations: {self.controlview.frame = CGRect(self.view.frame.width - 70,125,52,1000)}, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.25, animations: {self.controlview.frame = CGRect(self.view.frame.width,125,52,1000)}, completion: nil)
        }
    }
    
    func OpenBoardMenu()
    {
        boardMenuOpen = !boardMenuOpen
        if(boardMenuOpen)
        {
            UIView.animate(withDuration: 0.25, animations: {self.boardMenu.frame = CGRect(20,125,52,1000)}, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.25, animations: {self.boardMenu.frame = CGRect(-52,125,52,1000)}, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func LoadNote()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        
        let noteFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        noteFetchRequest.predicate = NSPredicate(format: "boardName == %@", (currentBoardName))
        
        do{
            let data = try managedContext.fetch(noteFetchRequest)
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
                    newView.textField.text = datas.value(forKey: "text") as! String
                    newView.thisID = datas.value(forKey: "id") as! Int64
                    newView.backgroundColor = UIColor(hex: datas.value(forKey: "color") as! String)
                    
                    board.addSubview(newView)
                    noteList.append(newView)
                    print("LOADED: \(newView.thisID) at pos: \(location) from \(currentBoardName)")
                }
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }
    
    func LoadImage()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "boardName == %@", (currentBoardName))
        
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
                    let newView = image(frame: CGRect(location.x, location.y,200,150))
                    newView.vc = self
                    let img : UIImage = UIImage(data: datas.value(forKey: "imageData") as! Data)!
                    newView.image = img
                    newView.thisID = datas.value(forKey: "id") as! Int64
                    newView.layer.zPosition = 0
                    newView.layer.borderWidth = 2
                    newView.layer.borderColor = UIColor.white.cgColor
                    
                    board.addSubview(newView)
                    imageList.append(newView)
                    print("LOADED: IMAGE:\(newView.thisID) at pos: \(location)")
                }
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
        
        print("Images loaded (\(imageList.count))")
    }
    
    //Grabs numNotes from board data and then adds its as the notes id to ensure its always unique and makes it easy to grab the specifc note from Core Data.
    func AddNote()
    {
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentBoardName)
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            if(data.count > 0)
            {
                //Get unique id from numNotes value of Board enitity
                numNotes = data[0].value(forKey: "numNotes") as! Int
                data[0].setValue((numNotes) + 1, forKey: "numNotes")
 
                //Create note
                let newView = note(frame: CGRect(450,300,100,100))
                newView.vc = self
                newView.layer.zPosition = 0
                newView.thisID = numNotes + 1
                newView.backgroundColor = UIColor.white
                
                let color = newView.backgroundColor
                let hexColor = color?.toHexString
                
                //Add note as subview and to list of notes
                board.addSubview(newView)
                noteList.append(newView)
                
                //Save new note
                let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)
                let newNote = NSManagedObject(entity: entity!, insertInto: managedContext)
                //Values
                newNote.setValue(currentBoardName, forKey: "boardName")
                newNote.setValue(NSStringFromCGPoint(newView.center), forKey: "position")
                newNote.setValue(numNotes + 1, forKey: "id")
                newNote.setValue(hexColor!, forKey: "color")
                newNote.setValue("", forKey: "text")
                do{ try managedContext.save() } catch _ as NSError { print("Error saving") }
                
                print("Created Note")
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }
    
    func AddImage()
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
                numImages = data[0].value(forKey: "numImages") as! Int
                data[0].setValue((numImages) + 1, forKey: "numImages")
                
                let newView = image(frame: CGRect(450,300,200,150))
                
                newView.vc = self
                newView.thisID = numImages + 1
                newView.layer.zPosition = 0
                newView.layer.borderWidth = 2
                newView.layer.borderColor = UIColor.white.cgColor
                newImage = newView
                imageList.append(newView)
                OpenImagePicker(delegate: self, camera: false)
                
                print("Created Image")
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
    }
    
    func AddDrawing()
    {
        let newView = drawing(frame: CGRect(450,300,200,150))
        newView.vc = self
        newView.layer.zPosition = 0
        drawList.append(newView)
        newView.backgroundColor = UIColor.white
        board.addSubview(newView)
    }
    
    func OpenImagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, camera: Bool)
    {
        let image = UIImagePickerController()
        image.modalPresentationStyle = .overCurrentContext
        image.delegate = delegate
        
        if camera == true {
            image.sourceType = UIImagePickerControllerSourceType.camera
        }
        else {
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if let foundImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //Get image
            selectedImage = foundImage
            newImage.image = selectedImage
            board.addSubview(newImage)
            
            //Save
            guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = AppDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Image", in: managedContext)
            let imageEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
            //Values
            let imageData = UIImagePNGRepresentation(foundImage);
            imageEntity.setValue(currentBoardName, forKey: "boardName")
            imageEntity.setValue(NSStringFromCGPoint(newImage.center), forKey: "position")
            imageEntity.setValue(imageData, forKey: "imageData")
            imageEntity.setValue(numImages + 1, forKey: "id")
            do{ try managedContext.save() } catch _ as NSError { print("Error saving") }
        }
        else
        {
            selectedImage = UIImage()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
