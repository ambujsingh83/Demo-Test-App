//
//  MobileNumViewController.swift
//  StercoDigitex
//
//  Created by Ambuj Singh on 20/10/18.
//  Copyright © 2018 Ambuj Singh. All rights reserved.
//

import UIKit
import GoogleSignIn

class MobileNumViewController: UIViewController {

@IBOutlet weak var txtMobileNo: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        self.navigationController?.popViewController(animated: true)
    }
     @IBAction func didTapSubmit(_ sender: AnyObject) {
        
        if txtMobileNo.text != nil && (txtMobileNo.text?.count)! > 9{
            UserDefaults.standard.set(txtMobileNo.text!, forKey: "MobileNum")
            UserDefaults.standard.synchronize()
            openUserProfileViewController()
        }else{
            
        }
    }

    func openUserProfileViewController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let appWindow = UIApplication.shared.delegate?.window!
        let storeViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        let navigatioStack = UINavigationController(rootViewController: storeViewController)
//        navigatioStack.navigationBar.isHidden = true
//        appWindow!.rootViewController = navigatioStack
//        appWindow!.makeKeyAndVisible()
        self.navigationController?.pushViewController(storeViewController, animated: true)
    }
}
