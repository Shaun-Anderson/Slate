//
//  ViewController.swift
//  Slate
//
//  Created by Shaun Anderson on 29/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var boardCollection: UICollectionView!
    var boards = [Board]()
    
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    var spacing:CGFloat = 12
    var numberOfColumns:CGFloat = 2
    
    var soundPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CreateBoard(name: "My Slate")
        ReloadBoards()
        self.boardCollection.delegate = self
        self.boardCollection.dataSource = self;
        
        cellWidth = ((boardCollection.frame.width) - (numberOfColumns + 1) * spacing)/numberOfColumns
        cellHeight = cellWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    //CAN BE USED TO ENSURE AN ITNITAL BOARD
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
    
    func ReloadBoards()
    {
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //SEGUE FUNCTIONS
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
            } catch{print ("file not found")}
        }
        else
        {
            print("path not found")
        }
        
    }

   
}
