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
        
        var img = UIImage()
        var tintedImg = UIImage()
        //
        //CreateButtons
        let noteButton = UIButton(frame: CGRect(0,0,52,52))
        noteButton.backgroundColor = UIColor.white
        noteButton.tintColor = UIColor.darkGray
        img = UIImage(named: "Speech")!
        tintedImg = img.withRenderingMode(.alwaysTemplate)
        noteButton.addTarget(vc, action: #selector(vc.AddNote), for: .touchUpInside)
        noteButton.layer.cornerRadius = 0.5 * noteButton.bounds.size.width
        noteButton.clipsToBounds = true
        noteButton.layer.borderWidth = 2
        noteButton.layer.borderColor = UIColor.darkGray.cgColor
        noteButton.setImage(tintedImg, for: .normal)
        noteButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(noteButton)
        
        let imageButton = UIButton(frame: CGRect(0,72,52,52))
        imageButton.backgroundColor = UIColor.white
        imageButton.layer.cornerRadius = 0.5 * imageButton.bounds.size.width
        imageButton.clipsToBounds = true
        imageButton.layer.borderWidth = 2
        imageButton.tintColor = UIColor.darkGray
        img = UIImage(named: "Image")!
        tintedImg = img.withRenderingMode(.alwaysTemplate)
        imageButton.layer.borderColor = UIColor.darkGray.cgColor
        imageButton.addTarget(vc, action: #selector(vc.AddImage), for: .touchUpInside)
        imageButton.setImage(tintedImg, for: .normal)
        imageButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(imageButton)
        
        let drawButton = UIButton(frame: CGRect(0,144,52,52))
        drawButton.backgroundColor = UIColor.white
        img = UIImage(named: "Drawing")!
        tintedImg = img.withRenderingMode(.alwaysTemplate)
        drawButton.layer.borderWidth = 2
        drawButton.layer.borderColor = UIColor.darkGray.cgColor
        drawButton.addTarget(vc, action: #selector(vc.AddDrawing), for: .touchUpInside)
        drawButton.setTitle("Drawing", for: .normal)
        drawButton.layer.cornerRadius = 0.5 * imageButton.bounds.size.width
        drawButton.clipsToBounds = true
        drawButton.tintColor = UIColor.darkGray
        drawButton.setImage(tintedImg, for: .normal)
        drawButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(drawButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
