//
//  ChatImageViewVC.swift
//  Book A Ride
//
//  Created by Yagnik on 25/08/22.
//  Copyright © 2022 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class ChatImageViewVC: UIViewController {
    
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    var strUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgChat.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: "iconPicture"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
            if (error == nil) {
                self.imgChat.image = image
            }
        })
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
