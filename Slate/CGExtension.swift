//
//  UIColor+Extensions.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 19/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import Foundation
import UIKit


extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat)
    {
        self.init(width:width,height:height)
    }
}
