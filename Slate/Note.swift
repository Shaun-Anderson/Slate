//
//  Note.swift
//  Slate
//
//  Created by Shaun Anderson on 4/1/19.
//  Copyright © 2019 Shaun Anderson. All rights reserved.
//

import Foundation
import UIKit

public class Note {
    
    // MARK: - Properties
    
    var id: Int64
    var text: String
    var color: UIColor
    
    // Transform Information
    var x: Decimal
    var y: Decimal
    var zRotation: Decimal
    
    // MARK: - Initilisers
    
    init() {
        id = 0
        text = ""
        color = UIColor()
        x = 0.0
        y = 0.0
        zRotation = 0.0
    }
    
    init(_id: Int64, _text: String, _color: UIColor, _x: Decimal, _y: Decimal, zRot: Decimal)
    {
        id = _id
        text = _text
        color = _color
        x = _x
        y = _y
        zRotation = zRot
    }
    
}
