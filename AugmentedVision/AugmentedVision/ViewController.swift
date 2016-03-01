//
//  ViewController.swift
//  AugmentedVision
//
//  Created by Nikhil Kulkarni on 8/28/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
//        motionManager.gyroUpdateInterval = 0.2
//        motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue()) { (data:CMGyroData?, error:NSError?) -> Void in
//            print(data!.description)
//        }
        
        motionManager.startGyroUpdates()
        motionManager.startAccelerometerUpdates()
//        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion:CMDeviceMotion?, error:NSError?) -> Void in
////            print("Acceleration \(deviceMotion)")
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        print(location!.coordinate)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading
        print("Heading \(heading.description)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

