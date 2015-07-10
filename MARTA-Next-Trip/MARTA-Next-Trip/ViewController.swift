//
//  ViewController.swift
//  MARTA-Next-Trip
//
//  Created by Nikhil Kulkarni on 6/17/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    var mapView:MKMapView!
    
    var refreshTimer:NSTimer!
    var busArray:[MKPointAnnotation] = []
    
    var addedBuses = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView(frame: self.view.bounds)
        self.view = mapView
        mapView.mapType = MKMapType.Standard
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("getBusData"), userInfo: nil, repeats: true)
        
//        getBusData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTrainData() {
        let url = NSURL(string: trainsURL + API_KEY)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in

            let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println(json["LATITUDE"])
            
            
        })
        task.resume()
    }
    
    func getBusData() {
        let url = NSURL(string: busesURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
//            self.busArray.removeAll(keepCapacity: false)
            
            let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            for var i = 0; i < 1; i++ {
                let busLatitude = json[i]["LATITUDE"].string
                let busLongitude = json[i]["LONGITUDE"].string
                
                let latString = NSString(string: busLatitude!)
                let longString = NSString(string: busLongitude!)
                
                let bus = MKPointAnnotation()
                bus.coordinate = CLLocationCoordinate2D(latitude: latString.doubleValue, longitude: longString.doubleValue)
                
                if !self.addedBuses {
                    self.busArray.append(bus)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if !self.addedBuses {
                        self.mapView.addAnnotation(bus)
                    } else {
                        self.busArray[0].coordinate = bus.coordinate
                    }
                    
                })
            }
            self.addedBuses = true
        })
        task.resume()
    }

}

