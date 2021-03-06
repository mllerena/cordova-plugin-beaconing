//
//  AppDelegate.swift
//  iBKSHelloWorld
//
//  Created by Gabriel Codarcea on 20/7/16.
//  Copyright © 2016 Accent Advanced Systems SLU. All rights reserved.
//
import UIKit
import CoreLocation

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
//class AppDelegate: CLLocationManagerDelegate {

    /*
    class func load() {
        {
            let `class` = AppDelegate
            let originalSelector: Selector = #selector(AppDelegate.application(_:didFinishLaunchingWithOptions:))
            let swizzledSelector: Selector = #selector(AppDelegate.xxx_application(_:didFinishLaunchingWithOptions:))
            let originalMethod = class_getInstanceMethod(`class`, originalSelector)
            let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector)
            let didAddMethod = class_addMethod(`class`, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
            class_replaceMethod(`class`, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        } 
    }
      */  
        
   override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("application AppDelegate native beaconing")
        
        //Request location authorization which is needed for the beacons scan. Don't forget to 
        //define the "Privacy - Location Always Usage Description" in the Info.plist file
        
        var locationManager: CLLocationManager!
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()   
        
        return true
        
    }
 
    
}
