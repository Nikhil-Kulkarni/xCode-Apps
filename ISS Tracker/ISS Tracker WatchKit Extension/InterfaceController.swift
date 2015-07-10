//
//  InterfaceController.swift
//  ISS Tracker WatchKit Extension
//
//  Created by Nikhil Kulkarni on 5/25/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    // Current geoposition
    var latitude:Double!
    var longitude:Double!
    
    // The next duration and risetime
    var duration: Int!
    var risetime: Int!
    
    // LocationManager
    var locationManager = CLLocationManager()
    
    // Used to display the date of the next pass of ISS
    @IBOutlet weak var nextPassLabel: WKInterfaceLabel!
    
    // Displays duration
    @IBOutlet weak var durationLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            getPasses()
        }
    }
    
    
    @IBAction func refreshPressed() {
        getPasses()
    }
    
    func getPasses() {
        println("Getting next passes")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let url = NSURL(string: "http://api.open-notify.org/iss-pass.json?lat=\(self.latitude)&lon=\(self.longitude)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            var first = true
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) {(data: NSData!, response: NSURLResponse!, error: NSError!) in
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println(parsedObject)
                //Print the JSON object
                if let toplevel = parsedObject as? NSMutableDictionary {
                    if let request = toplevel["request"] as? NSMutableDictionary {
                        if let num_passes: AnyObject = request["passes"] {
                            println(num_passes)
                        }
                    }
                    if let response = toplevel["response"] as? NSMutableArray {
                        for pass in response {
                            if first {
                                self.risetime = pass["risetime"] as! Int
                                self.duration = pass["duration"] as! Int
                                self.durationLabel.setText("Duration: \(self.duration)")
                                
                                let date = NSDate(timeIntervalSince1970: pass["risetime"] as! Double)
                                
                                self.nextPassLabel.setText("\(date)")
                            }
                            first = false
                            println(pass["duration"] as! Int)
                            println(pass["risetime"] as! Int)
                            println(NSDate(timeIntervalSince1970: pass["risetime"] as! Double))
                        }
                    }
                }
            }
            task.resume()
        })
    }
    
    
    

}
