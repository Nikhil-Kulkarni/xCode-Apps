//
//  MapInterfaceController.swift
//  ISS Tracker
//
//  Created by Nikhil Kulkarni on 5/25/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import WatchKit
import Foundation

class MapInterfaceController: WKInterfaceController {
    
    // MapView
    @IBOutlet weak var mapView: WKInterfaceMap!
    
    // current ISS position
    var latitude: Double!
    var longitude: Double!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        getPosition()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updatePosition() {
        getPosition()
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
                        if self.latitude != nil && self.longitude != nil {
                            self.mapView.removeAllAnnotations()
                            var coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                            let span = MKCoordinateSpanMake(80, 80)
                            self.mapView.addAnnotation(coordinate, withPinColor: WKInterfaceMapPinColor.Purple)

                            self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span))
                        }
                    }
                }
            }
            task.resume()
        })
    }
    
    @IBAction func refreshPressed() {
        updatePosition()
    }
    

}
