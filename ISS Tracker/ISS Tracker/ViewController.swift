//
//  ViewController.swift
//  ISS Tracker
//
//  Created by Nikhil Kulkarni on 5/24/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // Labels
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var nextPassLabel: UILabel!
    
    // Google Maps mapView
    @IBOutlet weak var mapView: GMSMapView!
    
    // Timer used to getting current ISS position
    var timer:NSTimer!
    
    // Timer uesed to update position
    var updatePositionTimer: NSTimer!
    
    // Used to get current location
    var locationManager = CLLocationManager()
    
    // ISS image
    let iss_image = UIImage(named: "iss-icon")
    
    // ISS marker
    var marker = GMSMarker()
    
    // App has been started
    var started = false
    
    // Geoposition
    var latitude:Double!
    var longitude:Double!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeMarker()
        
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.settings.compassButton = true
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("getPosition"), userInfo: nil, repeats: true)
        updatePositionTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateISS"), userInfo: nil, repeats: true)
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.settings.myLocationButton = false
            mapView.myLocationEnabled = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func makeMarker() {
        marker.title = "ISS"
        marker.icon = iss_image
        getPosition()
        marker.map = mapView
    }
    
    func getPosition() {
        println("Getting position")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let url = NSURL(string: "http://api.open-notify.org/iss-now.json")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) {(data: NSData!, response: NSURLResponse!, error: NSError!) in
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                //Print the JSON object
                if let toplevel = parsedObject as? NSMutableDictionary {
                    var issLat: Double!
                    var issLong: Double!
                    if let iss_position = toplevel["iss_position"] as? NSMutableDictionary {
                        if let iss_latitude: AnyObject = iss_position["latitude"] {
                            println("Latitude \(iss_latitude)")
                            issLat = iss_latitude as! Double
                            self.latitude = issLat
                        }
                        if let iss_longitude: AnyObject = iss_position["longitude"] {
                            println("Longitude \(iss_longitude)")
                            issLong = iss_longitude as! Double
                            self.longitude = issLong
                        }
                        if let timestamp: AnyObject = toplevel["timestamp"] {
                            println("Timestamp \(timestamp)")
                        }
                    }
                }
            }
            task.resume()
        })
    }
    
    func updateISS() {
        if latitude != nil && longitude != nil {
            self.marker.position = CLLocationCoordinate2DMake(Double(self.latitude), Double(self.longitude))
            if !self.started {
                self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(Double(latitude), Double(longitude)), zoom: 5, bearing: CLLocationDirection(0), viewingAngle: 0)
            }
            self.started = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

