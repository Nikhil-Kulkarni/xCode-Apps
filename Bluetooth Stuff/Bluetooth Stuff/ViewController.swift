//
//  ViewController.swift
//  Bluetooth Stuff
//
//  Created by Nikhil Kulkarni on 3/16/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
    let beaconIdentifier = "beacon"
    
    override func viewDidLoad() {
        let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: beaconIdentifier)
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        for beacon in beacons {
            println(beacon)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

