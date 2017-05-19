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
        let button = UIButton(frame: CGRect(0,0,52,52))
        button.backgroundColor = UIColor.gray
        button.addTarget(vc, action: #selector(vc.AddNote), for: .touchUpInside)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Speech"), for: .normal)
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(button)
        
        let imageButton = UIButton(frame: CGRect(0,72,52,52))
        imageButton.backgroundColor = UIColor.red
        imageButton.layer.cornerRadius = 0.5 * imageButton.bounds.size.width
        imageButton.clipsToBounds = true
        imageButton.addTarget(vc, action: #selector(vc.AddImage), for: .touchUpInside)
        imageButton.setImage(UIImage(named: "Image"), for: .normal)
        imageButton.setTitle("Image", for: .normal)
        imageButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(imageButton)
        
        let drawButton = UIButton(frame: CGRect(0,144,52,52))
        drawButton.backgroundColor = UIColor.white
        drawButton.layer.borderWidth = 2
        drawButton.layer.borderColor = UIColor.darkGray.cgColor
        drawButton.addTarget(vc, action: #selector(vc.AddDrawing), for: .touchUpInside)
        let img = UIImage(named: "Drawing")
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        drawButton.setTitle("Drawing", for: .normal)
        drawButton.layer.cornerRadius = 0.5 * imageButton.bounds.size.width
        drawButton.clipsToBounds = true
        drawButton.tintColor = UIColor.darkGray
        drawButton.setImage(tintedImage, for: .normal)
        drawButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(drawButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
