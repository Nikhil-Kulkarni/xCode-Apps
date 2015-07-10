//
//  MoreViewControllerViewController.swift
//  ISS Tracker
//
//  Created by Nikhil Kulkarni on 5/24/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation

class MoreViewControllerViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Used to get current location
    var locationManager = CLLocationManager()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Formatted String
    var formattedString: [String] = []
    
    // Geoposition
    var latitude:Double!
    var longitude:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = false
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        getPasses()
        
        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = formattedString[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formattedString.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            getPasses()
        }
    }
    
    func getPasses() {
        println("Getting next passes")
        let url = NSURL(string: "http://api.open-notify.org/iss-pass.json?lat=\(self.latitude)&lon=\(self.longitude)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
    
        
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
                        println(pass["duration"] as! Int)
                        println(pass["risetime"] as! Int)
                        var date = NSDate(timeIntervalSince1970: pass["risetime"] as! Double)
                        self.formattedString.append("\(date)")
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
