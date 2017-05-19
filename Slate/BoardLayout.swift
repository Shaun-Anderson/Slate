//
//  BoardLayout.swift
//  Slate
//
//  Created by Shaun Anderson on 19/05/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit

class BoardLayout: UICollectionViewLayout {
    
    
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    var spacing:CGFloat = 12
    var numberOfColumns:CGFloat = 2
    
    override func prepare() {
        super.prepare()

        cellWidth = ((self.collectionView?.frame.width)! - (numberOfColumns + 1) * spacing)/numberOfColumns
        cellHeight = cellWidth
        print(cellWidth)
        
    }
}
