//
//  ThemeButton.swift
//  TanTaxi-Driver
//
//  Created by Excelent iMac on 11/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {
    
    @IBInspectable public var isSubmitButton: Bool = false
    @IBInspectable public var isHalfRounded: Bool = false

    override func awakeFromNib() {
        self.titleLabel?.font = UIFont.init(name: CustomeFontProximaNovaSemibold, size: 15)
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        
        if isSubmitButton == true
        {
            self.backgroundColor = ThemeAppMainColor
            setTitleColor(UIColor.black, for: .normal)
            
        }
        else
        {
            self.backgroundColor = UIColor(red: 114.0/255.0, green: 114.0/255.0, blue: 114.0/255.0, alpha: 1.0)
            setTitleColor(UIColor.black, for: .normal)
        }
        
        
        if isHalfRounded == true
        {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
        }
        
    }
}


