//
//  LegalViewController.swift
//  TanTaxi-Driver
//
//  Created by excellent Mac Mini on 30/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class LegalViewController: ParentViewController {
    
    @IBOutlet weak var btnPrivacyAndPolicy: UIButton!
    @IBOutlet weak var btnTermsandCondition: UIButton!
    var driverFullName = String()
    var strReferralCode = String()
    var strReferralMoney = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SetLocalazation()
        self.headerView?.lblTitle.text = "Legal".localized
        
        

    }
    func SetLocalazation()
    {
        btnPrivacyAndPolicy.setTitle("Privacy Policy".localized, for: .normal)
        btnTermsandCondition.setTitle("Terms & Conditions".localized, for: .normal)
    }
    @IBAction func btnPrivacyPolice(_ sender: UIButton)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "LegalWebPages") as! LegalWebPage
        next.headerName = "Privacy Policy".localized
        next.strURL = WebSupport.PrivacyPolicyURL
//        "https://www.tantaxitanzania.com/front/privacypolicy"
        self.navigationController?.pushViewController(next, animated: false)

    }
    
    @IBAction func btnTumsAndCondition(_ sender: UIButton)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "LegalWebPage") as! LegalWebPage
        next.headerName = "Terms & Conditions".localized
        next.strURL = WebSupport.TermsNConditionsURL
//        "https://www.tantaxitanzania.com/front/termsconditions"
        self.navigationController?.pushViewController(next, animated: false)
        
    }
    
    
    
}
