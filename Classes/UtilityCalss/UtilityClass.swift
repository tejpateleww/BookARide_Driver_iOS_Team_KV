//
//  UtilityClass.swift
//  TenTaxi-Driver
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SocketIO
import Alamofire


typealias CompletionHandler = (_ success:Bool) -> Void

class UtilityClass: NSObject {

    
   
//    let socket = manager.defaultSocket

//    let manager = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])
/*
    class func socketManager() -> SocketIOClient {
        
//        let manager = socketManager(socketURL: URL(string: "http://localhost:8080"), config: [.log(true), .compress])
        
        let manager = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])
        
        return manager
    }
*/
    //-------------------------------------------------------------
    // MARK: -  For Activity Indicator
    //-------------------------------------------------------------
    
    func loadingAnimation(loadingUI : NVActivityIndicatorView?, loadingBG : UIView, view : UIView, navController : UINavigationController) -> (NVActivityIndicatorView, UIView) {
        var loadUI = loadingUI
        let loadBG = loadingBG
        let x = (view.frame.size.width / 2)
        let y = (view.frame.size.height / 2)
        loadUI = NVActivityIndicatorView(frame: CGRect(x: x, y: y, width: 100, height: 100))
        loadUI!.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
            
        
        loadBG.backgroundColor = UIColor.lightGray
        loadBG.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        loadBG.center = navController.view.center
        loadBG.layer.cornerRadius = 5
        loadBG.layer.opacity = 0.5
        navController.view.addSubview(loadBG)
        navController.view.addSubview(loadUI!)
        
        loadUI!.type = .ballTrianglePath
        loadUI!.color = UIColor.white
        loadUI!.startAnimating()
        
        return (loadUI!, loadBG)
    }
    
    class func showAlertWithCompletion(_ title: String, message: String, okTitle : String = "", otherTitle : String = "", vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        let alert = UIAlertController(title: appName.kAPPName,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        
      
        
        if(okTitle != "")
        {
            alert.addAction(UIAlertAction(title: okTitle.localized, style: .default, handler: { (action) in
                completionHandler(true)
            }))
        }
        else
        {
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
                completionHandler(true)
            }))
            
        }
        
        
        if(otherTitle != "")
        {
            alert.addAction(UIAlertAction(title: otherTitle.localized, style: .default, handler: { (action) in
                completionHandler(false)
            }))
        }
        
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
        {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                 (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }

    }

    class func setImage(url : String, imageView : UIImageView)
    {
        
//        imageView.sd_addActivityIndicator()
//        imageView.sd_setShowActivityIndicatorView(true)
//        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
            imageView.layer.cornerRadius = imageView.frame.size.width/2
            imageView.layer.masksToBounds = true
        }
        
        
    }
    
    /// Response may be Any Type
    class func showAlertOfAPIResponse(param: Any, vc: UIViewController) {
        
        if let res = param as? String {
            UtilityClass.showAlert(appName.kAPPName, message: res, vc: vc)
        }
        else if let resDict = param as? NSDictionary {
            if let msg = resDict.object(forKey: "message") as? String {
                UtilityClass.showAlert(appName.kAPPName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "msg") as? String {
                UtilityClass.showAlert(appName.kAPPName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "message") as? [String] {
                UtilityClass.showAlert(appName.kAPPName, message: msg.first ?? "", vc: vc)
            }
        }
        else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                if let message = dictIndxZero.object(forKey: "message") as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: message, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    UtilityClass.showAlert(appName.kAPPName, message: msg, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "message") as? [String] {
                    UtilityClass.showAlert(appName.kAPPName, message: msg.first ?? "", vc: vc)
                }
            }
            else if let msg = resAry as? [String] {
                UtilityClass.showAlert(appName.kAPPName, message: msg.first ?? "", vc: vc)
            }
        }
    }
    
    // Alert
    
    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK".localized,
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if(vc.presentedViewController != nil)
        {
            vc.dismiss(animated: true, completion: nil)
        }
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    class func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
//        title = "TickToc"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
            completionHandler(true)
        }))
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    
    class func showAlertAnother(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK".localized,
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if(vc.presentedViewController != nil)
        {
            vc.dismiss(animated: true, completion: {
                vc.present(alert, animated: true, completion: nil)

            })
        }
        vc.present(alert, animated: true, completion: nil)

        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
    }
    
    
    
    class func showHUD() {
        
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 55
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 55
        NVActivityIndicatorView.DEFAULT_TYPE = .ballRotate
        NVActivityIndicatorView.DEFAULT_COLOR = ThemeAppMainColor
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    class func hideHUD() {
           NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    class func showACProgressHUD() {
        
//        let progressView = ACProgressHUD.shared
//      /*
//        ACProgressHUD.shared.configureStyle(withProgressText: "", progressTextColor: .black, progressTextFont: <#T##UIFont#>, shadowColor: UIColor.black, shadowRadius: 3, cornerRadius: 5, indicatorColor: UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), hudBackgroundColor: .white, enableBackground: false, backgroundColor: UIColor.black, backgroundColorAlpha: 0.3, enableBlurBackground: false, showHudAnimation: .growIn, dismissHudAnimation: .growOut)
//      */
//        progressView.progressText = ""
//
//        progressView.hudBackgroundColor = .black
//
//        progressView.indicatorColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
////        progressView.shadowRadius = 0.5
//
//        progressView.showHUD()
        
        self.showHUD()
 
    }
    
    class func hideACProgressHUD() {
        
        self.hideHUD()
        //ACProgressHUD.shared.hideHUD()
        
       
    }
   /*
    func convertAnyToString(dictData: [String:AnyObject], paramString: String) -> String {
        
        var currentData = dictData
        
        if currentData[paramString] == nil {
            return "Nil"
        }
        
        if ((currentData[paramString] as? String) != nil) {
            return String(currentData[paramString] as! String)
        } else if ((currentData[paramString] as? Int) != nil) {
            return String((currentData[paramString] as! Int))
        } else if ((currentData[paramString] as? Double) != nil) {
            return String(currentData[paramString] as! Double)
        } else if ((currentData[paramString] as? Float) != nil){
            return String(currentData[paramString] as! Float)
        }
        else {
            return "Nil"
        }
    }
    */
}


//-------------------------------------------------------------
// MARK: - Extension of UIViewController
//-------------------------------------------------------------

extension UIViewController {
    
    /// Ends editing view when touches to view
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    /// Convert AnyType OF Data To String
    func convertAnyToString(dictData: [String:AnyObject], paramString: String) -> String {
        
        var currentData = dictData
        
        if currentData[paramString] == nil {
            return ""
        }
        
        if ((currentData[paramString] as? String) != nil) {
            return String(currentData[paramString] as! String)
        } else if ((currentData[paramString] as? Int) != nil) {
            return String((currentData[paramString] as! Int))
        } else if ((currentData[paramString] as? Double) != nil) {
            return String(currentData[paramString] as! Double)
        } else if ((currentData[paramString] as? Float) != nil){
            return String(currentData[paramString] as! Float)
        }
        else {
            return ""
        }
    }
}



//-------------------------------------------------------------
// MARK: -  For UIButton Cornor Radios
//-------------------------------------------------------------


extension UIButton {
    func setUIButtonBorderRadius() {
        //White Border
        let UIButtonCALayer = CALayer()
        
        self.layer.cornerRadius = 3
        
        self.layer.addSublayer(UIButtonCALayer)
        
        self.layer.masksToBounds = true
    }
}

//-------------------------------------------------------------
// MARK: -  For View Shadow
//-------------------------------------------------------------



extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
// ------------------------------------------------------------

//-------------------------------------------------------------
// MARK: - Internet Connection Check Methods
//-------------------------------------------------------------

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


