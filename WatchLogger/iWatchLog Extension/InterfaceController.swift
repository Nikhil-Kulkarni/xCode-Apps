//
//  InterfaceController.swift
//  iWatchLog Extension
//
//  Created by Nikhil Kulkarni on 10/30/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var accelerationLabel: WKInterfaceLabel!
    @IBOutlet var xAcceleration: WKInterfaceLabel!
    @IBOutlet var loggingLabel: WKInterfaceButton!
    
    let arr:NSDictionary = [String : NSMutableArray]()
    var dict:NSMutableDictionary!
    
    var info = NSMutableArray()
    
    var logging = false
    
    let currentDate = NSDate(timeIntervalSince1970: 0.0)
    let motionManager = CMMotionManager()
    let session = WCSession.defaultSession()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awakeWithContext")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Gyroscope is not available for Apple Watch
    }
    
    override func didAppear() {
        print("didAppear")
        dict  = NSMutableDictionary(dictionary: arr)
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            self.accelerationLabel.setText("WC is supported")
            session.delegate = self
            session.activateSession()
        }
    }
    
    
    @IBAction func startLogging() {
        if (!logging) {
            loggingLabel.setTitle("Stop Logging")
            logging = true
            let operation = NSOperation()
            operation.queuePriority = NSOperationQueuePriority.VeryHigh
            operation.qualityOfService = NSQualityOfService.UserInitiated
            
            let operationQueue: NSOperationQueue = NSOperationQueue()
            operationQueue.addOperation(operation)
            self.xAcceleration.setText("Reading Data")
            motionManager.startAccelerometerUpdatesToQueue(operationQueue) { (acceleration, error) -> Void in
                
            // Send notification to phone to record data
            self.info.addObject("X: \(acceleration!.acceleration.x*1000), Y: \(acceleration!.acceleration.y*1000)), Z: \(acceleration!.acceleration.z*1000), Timestamp: \(CFAbsoluteTimeGetCurrent())")
            }
        } else {
            logging = false;
            motionManager.stopAccelerometerUpdates()
            dict["info"] = info
            let userInfo = ["userInfo" : info]
//            let transfer = session.transferUserInfo(userInfo)
            session.sendMessage(userInfo, replyHandler: { (dict) -> Void in
                
                }, errorHandler: { (error) -> Void in
                    
            })
            self.xAcceleration.setText("DT: True")
            loggingLabel.setTitle("Start Logging")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
