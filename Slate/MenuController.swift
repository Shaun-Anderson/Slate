//
//  ViewController.swift
//  Slate
//
//  Created by Shaun Anderson on 29/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var boardCollection: UICollectionView!
    var boards = [Board]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ReloadBoards()
        self.boardCollection.delegate = self
        self.boardCollection.dataSource = self;
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
    
    func MoveToMain(boardName: String)
    {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainController
        newVC.currentBoardName = boardName
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
    }


}

