//
//  controlView.swift
//  Slate
//
//  Created by Shaun Anderson on 12/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit
import CoreData

class controlView: UIView{

    var vc = MainController()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //CreateButtons
        let button = UIButton(frame: CGRect(0,129,64,64))
        button.backgroundColor = UIColor.red
        button.addTarget(vc, action: #selector(vc.AddNote), for: .touchUpInside)
        button.setTitle("Note", for: .normal)
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(button)
        
        let imageButton = UIButton(frame: CGRect(0,208,64,64))
        imageButton.backgroundColor = UIColor.red
        imageButton.addTarget(vc, action: #selector(vc.AddImage), for: .touchUpInside)
        imageButton.setTitle("Image", for: .normal)
        imageButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(imageButton)
        
        let drawButton = UIButton(frame: CGRect(0,282,64,64))
        drawButton.backgroundColor = UIColor.red
        drawButton.addTarget(vc, action: #selector(vc.AddDrawing), for: .touchUpInside)
        drawButton.setTitle("Drawing", for: .normal)
        drawButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(drawButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
