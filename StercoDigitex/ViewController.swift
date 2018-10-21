//
//  ViewController.swift
//  StercoDigitex
//
//  Created by Ambuj Singh on 20/10/18.
//  Copyright © 2018 Ambuj Singh. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController,GIDSignInUIDelegate {

@IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    //MARK: Authenticate google user
    func authenticateUserWithGoogleLogin(user:GIDGoogleUser!,error:Error!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let str1 = "https://www.googleapis.com/oauth2/v3/userinfo?access_token="
        let str2 = user.authentication.accessToken
        let url2 = NSURL(string: str1+str2!)
        let session = URLSession.shared
        
       
        
        session.dataTask(with: url2! as URL) {(data, response, error) -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            do {
                let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                /*
                 Get the account information you want here from the dictionary
                 Possible values are
                 */
                let idIs = userData!["sub"] as? String
                let firstName = userData!["given_name"] as? String
                let lastName = userData!["family_name"] as? String
                let gender = userData!["gender"] as? String
                let email = userData!["email"] as? String
                let imgUrl = userData!["picture"] as? String
                
                
                
                
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                
                let dict = NSMutableDictionary()
                dict.setValue(deviceID, forKey: "DeviceID")
                dict.setValue(idIs, forKey: "SocialID")
                dict.setValue(idIs, forKey: "Username")
                dict.setValue(firstName, forKey: "FirstName")
                dict.setValue(lastName, forKey: "LastName")
                dict.setValue(gender, forKey: "Gender")
                dict.setValue(email, forKey: "Email")
                dict.setValue("User", forKey: "UserRole")
                dict.setValue(firstName!+" "+lastName!, forKey: "UserFullName")
//                dict.setValue(CommonMethodsNew.getValueFromUserDefaults(key: STRINGS.TOKEN_VALUE), forKey: STRINGS.TOKEN_KEY)
//
//                UserDefaults.standard.set(idIs, forKey: STRINGS.USERNAME)
                
                
                UserDefaults.standard.set(dict, forKey: "UserInfo")
                UserDefaults.standard.set(imgUrl, forKey: "ProfileImg")
                
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self.openMobileViewController()
                }
                
            } catch {
                NSLog("Account Information could not be loaded")
            }
            }.resume()
    }
    
    func openMobileViewController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let storeViewController = storyBoard.instantiateViewController(withIdentifier: "MobileNumViewController") as! MobileNumViewController
        self.navigationController?.pushViewController(storeViewController, animated: true)
    }
}

