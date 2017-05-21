//
//  ImageView.swift
//  LifeBoard
//
//  Created by Shaun Anderson on 15/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit

class Edit_noteView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var lastLocation:CGPoint = CGPoint(0,0)
    var vc = MainController()
    
    var thisImageView = UIImageView()
    var newImage = UIImage()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        let selectWidth = UITextField(frame: CGRect(100,0,100,50))
        selectWidth.placeholder = "WIDTH"
        selectWidth.delegate = self
        selectWidth.backgroundColor = UIColor.red
        self.addSubview(selectWidth)
        
        let selectHeight = UITextField(frame: CGRect(200,0,100,50))
        selectHeight.placeholder = "HEIGHT"
        selectHeight.delegate = self
        selectHeight.backgroundColor = UIColor.red
        self.addSubview(selectHeight)
        
        /*let fontFamilyNames = UIFont.familyNames
         for familyName in fontFamilyNames
         {
         print("---------------")
         print("Font Family Name = [\(familyName)]")
         let names = UIFont.fontNames(forFamilyName: familyName)
         print("Font Names = [\(names)]")
         }
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 4
        let t = textField.text
        textField.text = t!.safelyLimitedTo(length: maxLength)
        return true
    }
}

