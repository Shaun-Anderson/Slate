//
//  MenuController.swift
//  Slate
//
//  Created by Shaun Anderson on 29/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Mark: Variables
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var boardCollection: UICollectionView!
    
    var boards = [Board]()
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    var spacing:CGFloat = 12
    var numberOfColumns:CGFloat = 2
    var soundPlayer : AVAudioPlayer!
    
    //Mark: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CreateBoard(name: "My Slate")
        ReloadBoards()
        self.boardCollection.delegate = self
        self.boardCollection.dataSource = self;
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(self.handleLongPress))
        boardCollection.addGestureRecognizer(lpgr)
        cellWidth = ((boardCollection.frame.width) - (numberOfColumns + 1) * spacing)/numberOfColumns
        cellHeight = cellWidth
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Deletes a slate if a long press is detected on it
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state != UIGestureRecognizerState.ended
        {
            //Put feedback to show possible deletion of slate
            return
        }
        
        let p = gestureRecognizer.location(in: self.boardCollection)
        
        if let indexPath : NSIndexPath = (self.boardCollection.indexPathForItem(at: p)) as NSIndexPath?
        {
            print("HIT STUFF + \(indexPath)")
            let cell = boardCollection.cellForItem(at: indexPath as IndexPath) as! BoardCollectionViewCell
            guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = AppDelegate.persistentContainer.viewContext
            
            //Get note for this board
            let noteFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
            noteFetchRequest.predicate = NSPredicate(format: "name == %@", (cell.boardNameLabel.text)!)
            
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
            
            ReloadBoards()
        }
        print("LONG PRESS + \(p)")
    }

    //Used to create an initial slate called "My Slate"
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
    
    //Deletes the data in [boards] and then loads it again and calls reload data on the collectionView
    func ReloadBoards()
    {
        
        boards.removeAll()
        guard  let AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        
        do{
            let data = try managedContext.fetch(fetchRequest)
            print(data.count)
            if(data.count > 0)
            {
                for datas in data
                {
                    boards.append(datas as! Board)
                }
            }
        } catch _ as NSError
        {
            print("ISSUE LOADING")
        }
        
        boardCollection.reloadData()
        
    }
    
    //Mark: Stroyboard Functions
    func MoveToMain(boardName: String)
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainController
        newVC.currentBoardName = boardName
        present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func MoveToNew()
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "add") as! AddController
        present(newVC, animated: true, completion: nil)
    }
    
    //Mark: CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = boardCollection.dequeueReusableCell(withReuseIdentifier: "BoardCell", for: indexPath) as! BoardCollectionViewCell
        cell.boardNameLabel.text = boards[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = boardCollection.cellForItem(at: indexPath) as! BoardCollectionViewCell
        MoveToMain(boardName: cell.boardNameLabel.text!)
        
        //Play Sound
        if let path = Bundle.main.path(forResource: "SelectSound", ofType: "mp3")
        {
            let url = URL(fileURLWithPath: path)
            
            do{
                try soundPlayer = AVAudioPlayer(contentsOf: url)
                soundPlayer.play()
                print("Audio played")
            } catch{print ("file not found")}
        }
        else
        {
            print("path not found")
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
