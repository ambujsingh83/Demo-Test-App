//
//  UserProfileViewController.swift
//  StercoDigitex
//
//  Created by Ambuj Singh on 20/10/18.
//  Copyright © 2018 Ambuj Singh. All rights reserved.
//

import UIKit
import CoreLocation

class UserProfileViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblTotalVisited: UILabel!
    var locationManager:CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        setupView()
       // getUserLocation()
    }
    
    func setupView(){
        if let userInfo = UserDefaults.standard.value(forKey: "UserInfo") as? NSDictionary{
            lblUserName.text = userInfo["UserFullName"] as? String
            lblEmail.text =  userInfo["Email"] as? String
            lblGender.text = userInfo["Gender"] as? String
            imgView.layer.cornerRadius = 50.0
            imgView.layer.masksToBounds = true
        }
        
        //set MobileNum
        if let userMobNo = UserDefaults.standard.object(forKey: "MobileNum"){
            lblMobileNo.text = userMobNo as? String
        }
        //Set user profile image
        if let profileURL = UserDefaults.standard.object(forKey: "ProfileImg"){
            
            let imgURL = NSURL(string:profileURL as! String)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imgURL! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.imgView.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
    
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                var addressString : String = ""
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + " "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                
                print(addressString)
                DispatchQueue.main.async {
                    self.lblUserLocation.text = addressString
                    self.locationManager.stopUpdatingLocation()
                }
                
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
//    // MARK: - Get User Lat Longs
//    func getUserLocation()
//    {
//
//        var currentLocation = CLLocation()
//
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//
//            if locManager.location != nil {
//                currentLocation = locManager.location!
//                self.getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")
//
//            }
//        }else{
//            let alertController = UIAlertController (title: "Alert", message: "location permission required", preferredStyle: .alert)
//
//            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                    return
//                }
//
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)") // Prints true
//                        })
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
//            }
//            alertController.addAction(settingsAction)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//            alertController.addAction(cancelAction)
//
//            present(alertController, animated: true, completion: nil)
//        }
//
//    }
    
//
//    //MARK: Get User's Location
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        let lon: Double = Double("\(pdblLongitude)")!
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//
//                    var addressString : String = ""
//
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + " "
//                    }
//
//                    print(addressString)
//                    DispatchQueue.main.async {
//                        self.lblUserLocation.text = addressString
//                    }
//
//                }
//        })
//
//    }
    
    
}
