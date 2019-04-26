//
//  AppDelegate.swift
//  iBKSHelloWorld
//
//  Created by Gabriel Codarcea on 20/7/16.
//  Copyright © 2016 Accent Advanced Systems SLU. All rights reserved.
//

import ObjectiveC
import UIKit
import CoreLocation

//@UIApplicationMain
//extension AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
extension AppDelegate: CLLocationManagerDelegate {

    
    var locationManager: CLLocationManager!
    
        
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
        
        
    func xxx_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("application AppDelegate native beaconing")
        
        //Request location authorization which is needed for the beacons scan. Don't forget to 
        //define the "Privacy - Location Always Usage Description" in the Info.plist file
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()   
        
        return xxx_application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    
    
    
}

