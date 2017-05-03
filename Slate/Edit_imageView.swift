//
//  Edit_imageView.swift
//  Slate
//
//  Created by Shaun Anderson on 29/04/2017.
//  Copyright © 2017 Shaun Anderson. All rights reserved.
//

import UIKit

class Edit_imageView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var vc = MainController()
    
    var thisImageView = UIImageView()
    var newImage = UIImage()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        let selectImageButton = UIButton(frame: CGRect(10,0,50,50))
        selectImageButton.backgroundColor = UIColor.red
        selectImageButton.addTarget(vc, action: #selector(self.ChangeImage), for: .touchUpInside)
        selectImageButton.setTitle("Image", for: .normal)
        selectImageButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(selectImageButton)
        
        let borderWidth = UITextField(frame: CGRect(70,0,40,50))
        borderWidth.placeholder = "WIDTH"
        borderWidth.delegate = self
        borderWidth.keyboardType = UIKeyboardType.numberPad
        borderWidth.textAlignment = NSTextAlignment.center
        borderWidth.tag = 1
        borderWidth.backgroundColor = UIColor.red
        self.addSubview(borderWidth)
        
        let selectBorderColor = UIButton(frame: CGRect(120,0,50,50))
        selectBorderColor.backgroundColor = UIColor.white
        //selectBorderColor.addTarget(vc, action: #selector(self.ChangeImage), for: .touchUpInside)
        selectBorderColor.setTitleColor(UIColor.black, for: .normal)
        selectBorderColor.setTitle("Color", for: .normal)
        selectBorderColor.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
        self.addSubview(selectBorderColor)
        
        let selectWidth = UITextField(frame: CGRect(300,0,100,50))
        selectWidth.placeholder = "WIDTH"
        selectWidth.delegate = self
        selectWidth.backgroundColor = UIColor.red
        self.addSubview(selectWidth)
        
        let selectHeight = UITextField(frame: CGRect(410,0,100,50))
        selectHeight.placeholder = "HEIGHT"
        selectHeight.delegate = self
        selectHeight.backgroundColor = UIColor.red
        self.addSubview(selectHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ChangeImage()
    {
        vc.OpenImagePicker(delegate: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let foundImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            newImage = foundImage
            thisImageView.image = newImage
            vc.SaveImage(image: foundImage, position: NSStringFromCGPoint(thisImageView.center),width: 200, height: 150)
            self.removeFromSuperview()
        }
        else
        {
            print("ImageNotFound")
        }
        vc.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 1
        {
            let maxLength = 1
            let t = textField.text
            textField.text = t!.safelyLimitedTo(length: maxLength)
        }
        
        let maxLength = 4
        let t = textField.text
        textField.text = t!.safelyLimitedTo(length: maxLength)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == 1)
        {
            thisImageView.layer.borderWidth = CGFloat((textField.text?.numberValue())!)
            print("board")
        }
    }
}

extension String
{
    func safelyLimitedTo(length n: Int) -> String
    {
        let c = self.characters
        if(c.count <= n) {return self}
        return String(Array(c).prefix(upTo: n))
    }
    
    func numberValue() -> Int
    {
        return Int(self)!
    }
}
