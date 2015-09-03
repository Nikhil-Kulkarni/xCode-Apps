//
//  ViewController.swift
//  WorldChat
//
//  Created by Nikhil Kulkarni on 7/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    var locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var chatBox: UITextField!
    
    var annotationList: NSDictionary!
    
    let fb = Firebase(url: "https://earthchat.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        chatBox.delegate = self
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        fb.observeEventType(FEventType.Value) { (snapshot:FDataSnapshot!) -> Void in
            let snapshotDictionary = snapshot.value as! NSDictionary
            
            if snapshotDictionary.count != 0 {
                let chat = snapshotDictionary["chat"] as! String
                let latitude = (snapshotDictionary["latitude"] as! NSString).doubleValue
                let longitude = (snapshotDictionary["longitude"] as! NSString).doubleValue
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                annotation.title = chat
                
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
        }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        print("Updated location")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Send message
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationManager.location!.coordinate
        annotation.title = self.chatBox.text!
        
        let map: [String : String] = ["chat" : self.chatBox.text!, "latitude" : "\(locationManager.location!.coordinate.latitude)", "longitude" : "\(locationManager.location!.coordinate.longitude)"]
        
        let chat = fb.childByAutoId()
        chat.setValue(map)
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        self.chatBox.text = ""
        self.chatBox.endEditing(true)
        return true
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.chatBox.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

