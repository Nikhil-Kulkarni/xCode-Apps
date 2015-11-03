//
//  ViewController.swift
//  Meetup
//
//  Created by Nikhil Kulkarni on 9/6/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet var meetupButton: UIButton!
    @IBOutlet var joinMeetup: UIButton!
    @IBOutlet var navMarker: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var initialLocation = false
    var doneRendering = false
    
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.mapView.delegate = self
        
        self.searchBar.delegate = self
//        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        
        self.meetupButton.layer.shadowColor = UIColor.grayColor().CGColor
        self.meetupButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        self.meetupButton.layer.shadowOpacity = 1.0
        self.meetupButton.layer.shadowRadius = 8.0
        self.meetupButton.hidden = true
        self.meetupButton.alpha = 0.0
        self.meetupButton.transform = CGAffineTransformMakeTranslation(0, 100)
        
        self.joinMeetup.layer.shadowOpacity = 1.0
        self.joinMeetup.layer.shadowRadius = 8.0
        
        self.navMarker.hidden = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        doneRendering = true
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if doneRendering {
            self.meetupButton.hidden = false
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.meetupButton.alpha = 1.0
                self.meetupButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.joinMeetup.alpha = 0.0
                }, completion: { (bool) -> Void in
                    self.joinMeetup.hidden = true
                    self.navMarker.hidden = false
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        self.location = locations.first
        if !initialLocation {
            self.mapView.setCamera(MKMapCamera(lookingAtCenterCoordinate: (location?.coordinate)!, fromEyeCoordinate: (location?.coordinate)!, eyeAltitude: 5000.0), animated: false)
            initialLocation = true
        }
    }
    
    @IBAction func goToCurrentLocation(sender: AnyObject) {
        self.mapView.setCamera(MKMapCamera(lookingAtCenterCoordinate: (location?.coordinate)!, fromEyeCoordinate: (location?.coordinate)!, eyeAltitude: 5000.0), animated: false)
        self.joinMeetup.hidden = false
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.joinMeetup.alpha = 1.0
//            self.joinMeetup.transform = CGAffineTransformMakeTranslation(0, 0)
            self.meetupButton.alpha = 0.0
            }, completion: { (bool) -> Void in
                self.meetupButton.hidden = true
                self.navMarker.hidden = true
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

