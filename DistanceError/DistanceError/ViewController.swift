//
//  ViewController.swift
//  DistanceError
//
//  Created by Nikhil Kulkarni on 11/29/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (acceleration, error) -> Void in
            print(acceleration?.acceleration)
            if (error != nil) {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(sender: AnyObject) {
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        motionManager.stopAccelerometerUpdates()
    }
    

}

