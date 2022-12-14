//
//  DriverEmailViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CountryPickerView
//import ACFloatingTextfield_Swift

class DriverEmailViewController: UIViewController, UIScrollViewDelegate, NVActivityIndicatorViewable 
{
    
    var userDefault = UserDefaults.standard
    var otpCode = Int()

    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var constrainViewOTPLeadingPosition: NSLayoutConstraint!
    
    @IBOutlet var viewOTP: UIView!
    @IBOutlet var lblHaveAccount: UILabel!
    
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var txtEmail: ThemeTextField!
    @IBOutlet var txtConPassword: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var viewEmailData: UIView!
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet weak var constraintHeightOfLogo: NSLayoutConstraint! // 80
    @IBOutlet weak var constraintHeightOfAllTextFields: NSLayoutConstraint! // 48
    let countryPicker = CountryPickerView()
//    var pickerViewCountryPicker = UIPickerView()
     var arrCountries = [Country]()
    @IBOutlet var btnCountryCode : UIButton!
    var isOTPSent:Bool = false
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewEmailData.isHidden = false
        constrainViewOTPLeadingPosition.constant = 0//self.view.frame.size.width
//        self.btnNext.setTitle("Send OTP".localized, for: .normal)
        self.lblHaveAccount.isHidden = false
        self.btnLogin.isHidden = false
        txtOTP.isEnabled = false
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPAD {
            constraintHeightOfLogo.constant = 50
            constraintHeightOfAllTextFields.constant = 30
        }
        txtMobile.delegate = self
        txtPassword.delegate = self
        txtEmail.delegate = self
        txtConPassword.delegate = self
        txtOTP.keyboardType = .numberPad
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
//        pickerViewCountryPicker.delegate = self
//        pickerViewCountryPicker.dataSource = self
//        arrCountries = countryPicker.countries
//        self.pickerViewCountryPicker.reloadAllComponents()
//        txtCountryCode.inputView = pickerViewCountryPicker
//        txtCountryCode.text = "+592"
        btnCountryCode.setTitle("+592", for: .normal)
//        print(arrCountries)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBAction func btnResendOTPClicked(_ sender: Any)
    {
         webserviceForGetOTPCode()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        setLocalization()
      
        self.title = "App Name".localized

    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization()
    {
        txtMobile.placeholder = "Mobile Number".localized
        txtEmail.placeholder = "Email".localized
        txtPassword.placeholder = "Password".localized
        txtConPassword.placeholder = "Confirm Password".localized
        btnNext.setTitle("Send OTP".localized, for: .normal)
        txtOTP.placeholder = "Enter Mobile OTP".localized
        btnResentOtp.setTitle("Resend OTP".localized, for: .normal)
    }
    
    @IBAction func btnCountryCodePicker(_ sender: Any)
    {
        
        countryPicker.showPhoneCodeInView = true
        countryPicker.showCountriesList(from: self)
    }
    
    @IBOutlet weak var lblPleaseCheckYourEmail: UILabel!
    @IBOutlet weak var btnResentOtp: UIButton!
    
    @IBAction func btnNext(_ sender: Any)
    {
        
//        performSegue(withIdentifier: "SegueToDriverPErsonelnfo", sender: self)
        
        if self.isOTPSent == true
        {
            if CompareOTP()
            {
                UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations:
                    {
                        
                }) { (done) in
                    
                    self.constrainViewOTPLeadingPosition.constant = 0//self.view.frame.size.width
                    self.btnNext.setTitle("Send OTP".localized, for: .normal)
                    self.lblHaveAccount.isHidden = false
                    self.btnLogin.isHidden = false
                    self.txtOTP.isEnabled = false
                    self.viewEmailData.isHidden = false
                    self.view.layoutIfNeeded()
                    
                }
                let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
                driverVC.viewDidLayoutSubviews()
            }
        }
        else
        {

            if(checkValidation())
            {
                webserviceForGetOTPCode()
            }


        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //        let pageNo = CGFloat(scrollView.contentOffset.x / scrollView.frame.size.width)
        //        segmentController.selectItemAt(index: Int(pageNo), animated: true)
    }
    
    func checkValidation() -> Bool {
        
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmail.text!)
        
        if txtMobile.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
        {
            UtilityClass.showAlert("App Name".localized, message: "Please enter mobile number".localized, vc: self)
            return false
        }
//        else if txtMobile.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 10
//        {
//            UtilityClass.showAlert("App Name".localized, message: "Please enter valid mobile number".localized, vc: self)
//            return false
//        }
        
        else if txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
        {
            UtilityClass.showAlert("App Name".localized, message: "Please enter email".localized, vc: self)
            return false
        }
        else if (!isEmailAddressValid)
        {
            UtilityClass.showAlert("App Name".localized, message: "Please enter a valid email".localized, vc: self)
            
            return false
        }
        else if txtPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
        {
            UtilityClass.showAlert("App Name".localized, message: "Please enter password".localized, vc: self)
            return false
        } else if (txtPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count)! < 8
        {
            UtilityClass.showAlert("App Name".localized, message: "Password must contain at least 8 characters.".localized, vc: self)
            return false
        }
        else if txtConPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
        {
            UtilityClass.showAlert("App Name".localized, message: "Please enter confirm password".localized, vc: self)
            return false
        }
        else if txtConPassword.text! != txtPassword.text
        {
            UtilityClass.showAlert("App Name".localized, message: "Password and confirm password must be same".localized, vc: self)
            return false
        }
        
        return true
    }
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Get OTP Code
    //-------------------------------------------------------------
    
    var aryOfCompany = [[String:AnyObject]]()
    
    func webserviceForGetOTPCode()
    {
        var dictData = [String:AnyObject]()
        dictData["Email"] = txtEmail.text as AnyObject
        dictData[RegistrationFinalKeys.kMobileNo] = "\(txtMobile.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")" as AnyObject
        dictData["CountryCode"] = btnCountryCode.titleLabel?.text as AnyObject
        webserviceForOTPDriverRegister(dictData as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                let otp = result.object(forKey: "otp") as! Int
                self.aryOfCompany = result.object(forKey: "company") as! [[String : AnyObject]]
                self.isOTPSent = true
                self.userDefault.set(otp, forKey: OTPCodeStruct.kOTPCode)
                //self.userDefault.set(self.aryOfCompany, forKey: OTPCodeStruct.kCompanyList)
                
                let alert = UIAlertController(title: "App Name".localized, message: result.object(forKey: GetResponseMessageKey()) as? String, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Dismiss".localized, style: .default, handler: { ACTION in
                    //
                    let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
//                    driverVC.viewDidLayoutSubviews()
                    //
                    driverVC.setData(companyData: self.aryOfCompany)
                    //
                    self.constrainViewOTPLeadingPosition.constant = -self.view.frame.size.width
                    self.viewEmailData.isHidden = true
                    self.lblHaveAccount.isHidden = true
                    self.btnLogin.isHidden = true
                    UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations:
                        {
                            self.txtOTP.isEnabled = true
                            self.view.layoutIfNeeded()
                            
                            self.btnNext.setTitle("Submit".localized, for: .normal)
                    })
                    { (done) in
                        
                    }
//                    self.userDefault.set(self.txtEmail.text, forKey: savedDataForRegistration.kKeyEmail)
                    self.userDefault.set(self.txtEmail.text, forKey: RegistrationFinalKeys.kEmail)
                    self.userDefault.set(self.txtPassword.text, forKey: RegistrationFinalKeys.kPassword)
                    self.userDefault.set(self.txtMobile.text, forKey: RegistrationFinalKeys.kMobileNo)
//                    self.userDefault.set(1, forKey: savedDataForRegistration.kPageNumber)
                    
                })
                
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print(result)
                
                if let results = result as? [String:Any]
                {
                    
                    
                    let alert = UIAlertController(title: "App Name".localized, message: (results[GetResponseMessageKey()] as? String), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Dismiss".localized, style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                else if let results = result as? String
                {
                    let alert = UIAlertController(title: "App Name".localized, message: results, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Dismiss".localized, style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            //
            //            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //
        }
    }
    
    func CompareOTP() -> Bool
    {
        
        if Utilities.isEmpty(str: txtOTP.text)
        {
            Utilities.showAlert("App Name".localized, message: "Please enter OTP".localized, vc: (UIApplication.shared.keyWindow?.rootViewController)!)
            return false
        }
        else
        {
            if userDefault.object(forKey: OTPCodeStruct.kOTPCode) == nil {
                otpCode = 0
            }
            else {
                otpCode = userDefault.object(forKey: OTPCodeStruct.kOTPCode) as! Int
            }
            
            if txtOTP.text == String(otpCode)
            {
                let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
                
                //            let personalDetailsVC = driverVC.children[2] as! DriverPersonelDetailsViewController
                
                let x = self.view.frame.size.width
                driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
                driverVC.viewTwo.backgroundColor = ThemeAppMainColor
                //            driverVC.imgDriver.image = UIImage.init(named: iconDriverSelect)
                
                //            personalDetailsVC.setDataForProfile()
                self.userDefault.set(self.txtOTP.text, forKey: savedDataForRegistration.kKeyOTP)
                self.userDefault.set(1, forKey: savedDataForRegistration.kPageNumber)
                return true
            }
            else
            {
                let alert = UIAlertController(title: "App Name".localized, message: "Please enter correct OTP".localized, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Dismiss".localized, style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
    }
    
}

extension DriverEmailViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
            return false
        }

        return true
    }
}





extension DriverEmailViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        btnCountryCode.setTitle(country.phoneCode, for: .normal)

    }
    
//    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
//        btnCountryCode.setTitle(country.phoneCode, for: .normal)
//    }
}

extension DriverEmailViewController: CountryPickerViewDataSource {

    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
        
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return false
    }
}
