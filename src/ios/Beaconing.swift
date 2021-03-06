import Foundation
import CoreLocation
/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/
@objc(Beaconing) class Beaconing : CDVPlugin, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var delegateIds = [String:String?]()

    override func pluginInitialize() {
        super.pluginInitialize()
        print("adding delegate")
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        
        
        
        // set up delegate ids
        delegateIds = [
            "rangeBeaconId": "id",
            "monitorBeaconId": "id",
            "enteredRegionId": "id",
            "leftRegionId": "id"
        ]
        
    }
    
    
    
     @objc func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if(state == .inside){
            //When beacon did enter region, ranging will start. As it is called from background, the ranging will only last 10 seconds max.
            print("DID ENTER REGION")
            var mUuidstr = "00000000-0000-0000-0000-000000000100"
            let mUUID = UUID(uuidString: mUuidstr)!
            let beaconRegion = CLBeaconRegion(proximityUUID: mUUID, identifier: "region_Keefob")
            self.locationManager.startRangingBeacons(in: beaconRegion)
        }else if(state == .outside){
            print("DID EXIT REGION")
        }
    }
    
    
    
    
    // the listeners get called based on the functions in ionic .ts code
    // they provide callback ids, which are used to send delegate results to ionic 
  @objc(requestAlwaysAuthorization:) // Declare your function name.
  func requestAlwaysAuthorization(command: CDVInvokedUrlCommand) { // write the function code.
    
    self.commandDelegate.run {
        print("requestAlwaysAuthorization", command.callbackId)
        // get the callbackid
        //self.delegateIds["rangeBeaconId"] = command.callbackId!
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        
        // this can be placed as callable function, but let's be real, you'll always need to authorize
        //self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.allowsBackgroundLocationUpdates = true
        
        // Set the plugin result to fail.
        let pluginResult = CDVPluginResult (status: CDVCommandStatus_NO_RESULT);
        
        pluginResult?.setKeepCallbackAs(true)
        // Send the function result back to Cordova.
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }
    
    // the listeners get called based on the functions in ionic .ts code
    // they provide callback ids, which are used to send delegate results to ionic 
  @objc(rangeBeaconIdListener:) // Declare your function name.
  func rangeBeaconIdListener(command: CDVInvokedUrlCommand) { // write the function code.
    
    self.commandDelegate.run {
        print("adding ranging beacon listener", command.callbackId)
        // get the callbackid
        self.delegateIds["rangeBeaconId"] = command.callbackId!
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        // Set the plugin result to fail.
        let pluginResult = CDVPluginResult (status: CDVCommandStatus_NO_RESULT);
        
        pluginResult?.setKeepCallbackAs(true)
        // Send the function result back to Cordova.
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }

  @objc(monitorBeaconIdListener:) // Declare your function name.
  func monitorBeaconIdListener(command: CDVInvokedUrlCommand) { // write the function code.
    
    self.commandDelegate.run {
        print("adding monitoring beacon listener", command.callbackId)
        
        self.delegateIds["monitorBeaconId"] = command.callbackId!

        let pluginResult = CDVPluginResult (status: CDVCommandStatus_NO_RESULT);
        
        pluginResult?.setKeepCallbackAs(true)
       
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }

  @objc(enteredRegionIdListener:) // Declare your function name.
  func enteredRegionIdListener(command: CDVInvokedUrlCommand) { // write the function code.
    
    self.commandDelegate.run {
        print("adding beacon entered region listener", command.callbackId)
        
        self.delegateIds["enteredRegionId"] = command.callbackId!

        let pluginResult = CDVPluginResult (status: CDVCommandStatus_NO_RESULT);
        
        pluginResult?.setKeepCallbackAs(true)
       
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }

  @objc(leftRegionIdListener:) // Declare your function name.
  func leftRegionIdListener(command: CDVInvokedUrlCommand) { // write the function code.
    
    self.commandDelegate.run {
        print("adding beacon exit region listener", command.callbackId)
        
        self.delegateIds["leftRegionId"] = command.callbackId!

        let pluginResult = CDVPluginResult (status: CDVCommandStatus_NO_RESULT);
        
        pluginResult?.setKeepCallbackAs(true)
       
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
  }

  @objc(rangeBeacons:)
  func rangeBeacons(command: CDVInvokedUrlCommand) {
    print("rangeBeacons", command.callbackId)
    print("beacon array string: ", command.arguments![0])

        // Set the plugin result to fail.
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        

        // turn the csv style string to an array
    let newBeaconList = (command.arguments![0] as AnyObject).components(separatedBy: ",") // or "\n"
        print("newBeaconList")
        print(newBeaconList)

        let uuid = UUID(uuidString: newBeaconList[0]) // UUID(uuidString: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
        //let major: CLBeaconMajorValue = CLBeaconMajorValue(Int(newBeaconList[1])!) // XXXX
        //let minor: CLBeaconMinorValue = CLBeaconMinorValue(Int(newBeaconList[2])!) // XXXX
        let id: String = newBeaconList[3] // "beaconName"

        //let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: id)
      
        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: id)

//        self.locationManager.startRangingBeacons( in: region)
        self.locationManager.startRangingBeacons(in: region)
        // return region as an object
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "region set!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }

@objc(monitorBeacons:)
  func monitorBeacons(command: CDVInvokedUrlCommand) {
    print("monitorBeacons", command.callbackId)
    print("beacon array string: ", command.arguments![0])

        // Set the plugin result to fail.
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        

        // turn the csv style string to an array
    let newBeaconList = (command.arguments![0] as AnyObject).components(separatedBy: ",") // or "\n"
        print("newBeaconList")
        print(newBeaconList)

        let uuid = UUID(uuidString: newBeaconList[0]) // UUID(uuidString: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
        //let major: CLBeaconMajorValue = CLBeaconMajorValue(Int(newBeaconList[1])!) // XXXX
        //let minor: CLBeaconMinorValue = CLBeaconMinorValue(Int(newBeaconList[2])!) // XXXX
        let id: String = newBeaconList[3] // "beaconName"

        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: id)

        self.locationManager.startMonitoring(for: region)
        // return region as an object
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "region set!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }

  @objc(stopRangeBeacons:)
  func stopRangeBeacons(command: CDVInvokedUrlCommand) {
    print("stopping ranging beacons", command.callbackId)
    print("beacon array string: ", command.arguments![0])

        // Set the plugin result to fail.
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        

        // turn the csv style string to an array
    let newBeaconList = (command.arguments![0] as AnyObject).components(separatedBy: ",") // or "\n"
        print("newBeaconList")
        print(newBeaconList)

        let uuid = UUID(uuidString: newBeaconList[0]) // UUID(uuidString: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
        let major: CLBeaconMajorValue = CLBeaconMajorValue(Int(newBeaconList[1])!) // XXXX
        let minor: CLBeaconMinorValue = CLBeaconMinorValue(Int(newBeaconList[2])!) // XXXX
        let id: String = newBeaconList[3] // "beaconName"

        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: id)

        self.locationManager.stopRangingBeacons(in: region)
        
        // return region as an object
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "stopped ranging!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }

  @objc(stopMonitorBeacons:)
  func stopMonitorBeacons(command: CDVInvokedUrlCommand) {
    print("stopping monitoring beacons", command.callbackId)
    print("beacon array string: ", command.arguments![0])

        // Set the plugin result to fail.
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "The Plugin Failed");
        

        // turn the csv style string to an array
    let newBeaconList = (command.arguments![0] as AnyObject).components(separatedBy: ",") // or "\n"
        print("newBeaconList")
        print(newBeaconList)

        let uuid = UUID(uuidString: newBeaconList[0]) // UUID(uuidString: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
        let major: CLBeaconMajorValue = CLBeaconMajorValue(Int(newBeaconList[1])!) // XXXX
        let minor: CLBeaconMinorValue = CLBeaconMinorValue(Int(newBeaconList[2])!) // XXXX
        let id: String = newBeaconList[3] // "beaconName"

        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: id)

        self.locationManager.stopMonitoring(for: region)
        // return region as an object
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "stopped monitoring!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
  }
    
    // MARK: Delegate functions
    
    @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if(status == .authorizedAlways){
            print("Permission granted location!")
            if(CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)){
                if(CLLocationManager.isRangingAvailable()){
                    var mUuidstr = "00000000-0000-0000-0000-000000000100"
                    let mUUID = UUID(uuidString: mUuidstr)!
                    let beaconRegion = CLBeaconRegion(proximityUUID: mUUID, identifier: "region_Keefob")
                    //self.locationManager.startRangingBeacons(in: beaconRegion)
                    self.locationManager.startMonitoring(for: beaconRegion)
                    print("startMonitoring after didChangeAuthorization")
                }
            }
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in: CLBeaconRegion) {
        
        print("started ranging beacons")
        guard let discoveredBeaconProximity = beacons.first?.proximity
            else {
                print("couldn't find any beacons.")
                return
        }
        
        print(discoveredBeaconProximity.rawValue)

        // turn results into strings and into an array
        let returnBeaconArray: [String] = [(beacons.first?.proximityUUID.uuidString)!,
                                           String(beacons.first?.proximity.rawValue ?? 0),
                                           (beacons.first?.major.stringValue)!,
                                           (beacons.first?.minor.stringValue)!,
                                           String(beacons.first?.rssi ?? 0)]
        
        //locationManager!.stopRangingBeacons(in: beaconRegion)
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: returnBeaconArray);
        
        pluginResult?.setKeepCallbackAs(true)
        
        self.commandDelegate.send(pluginResult, callbackId: self.delegateIds["rangeBeaconId"]!)
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitoring beacon")
        self.commandDelegate.run {
            guard (region.identifier) != "" else { print("couldn't find a monitored beacon"); return}
            
            print("within beacon range!", region)
            print(region.identifier)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: region.identifier)
            
            pluginResult?.setKeepCallbackAs(true)
            
            self.commandDelegate.send(pluginResult, callbackId: self.delegateIds["monitorBeaconId"]!)
        }
        
    }

    @objc func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("checking if entered region")
        self.commandDelegate.run {
            guard (region.identifier) != "" else { print("couldn't find a beacon"); return}
            
            print("entered beacon region!", region)
            print(region.identifier)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: region.identifier)
            
            pluginResult?.setKeepCallbackAs(true)
            
            self.commandDelegate.send(pluginResult, callbackId: self.delegateIds["enteredRegionId"]!)
        }
    }

    @objc func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("checking if exited region")
        self.commandDelegate.run {
            guard (region.identifier) != "" else { print("couldn't find a beacon"); return}
            
            print("exited beacon region!", region)
            print(region.identifier)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: region.identifier)
            
            pluginResult?.setKeepCallbackAs(true)
            
            self.commandDelegate.send(pluginResult, callbackId: self.delegateIds["leftRegionId"]!)
        }
    }
}
