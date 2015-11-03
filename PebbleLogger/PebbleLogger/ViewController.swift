//
//  ViewController.swift
//  PebbleLogger
//
//  Created by Nikhil Kulkarni on 10/24/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import PebbleKit

class ViewController: UIViewController, PBDataLoggingServiceDelegate, PBPebbleCentralDelegate, PBWatchDelegate {
    
    let uuid:NSUUID = NSUUID(UUIDString: "8f547ed2-bfbd-4271-aa0f-b15ed9dc5947")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PBPebbleCentral.defaultCentral().appUUID = NSUUID(UUIDString: "8f547ed2-bfbd-4271-aa0f-b15ed9dc5947")
        
        PBPebbleCentral.defaultCentral().dataLoggingService.delegate = self
        PBPebbleCentral.defaultCentral().delegate = self
        PBPebbleCentral.defaultCentral().run()
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidConnect watch: PBWatch, isNew: Bool) {
        print(watch.name)
        print("Watch is connected")
        watch.delegate = self
        
        watch.getVersionInfo({ (watch, versionInfo) -> Void in
            print(versionInfo)
            }) { (watch) -> Void in
                print("timed out")
        }
        
        watch.appMessagesGetIsSupported { (watch, supported) -> Void in
            if (supported) {
                print("supported")
            } else {
                print("not supported")
            }
        }
        
        watch.appMessagesLaunch { (watch, error) -> Void in
            if ((error) != nil) {
                print("Error launching app")
                print(error?.description)
            }
        }
        
        PBPebbleCentral.defaultCentral().dataLoggingService.pollForData()
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidDisconnect watch: PBWatch) {
        print(watch.name)
        print("Watch is disconnected")
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasByteArrays bytes: UnsafePointer<UInt8>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("1")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasSInt16s data: UnsafePointer<Int16>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("2")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasSInt8s data: UnsafePointer<Int8>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("3")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasUInt16s data: UnsafePointer<UInt16>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("4")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasUInt32s data: UnsafePointer<UInt32>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("5")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasUInt8s data: UnsafePointer<UInt8>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print("6")
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, hasSInt32s data: UnsafePointer<Int32>, numberOfItems: UInt16, forDataLoggingSession session: PBDataLoggingSessionMetadata) -> Bool {
        print(data)
        return true
    }
    
    func dataLoggingService(service: PBDataLoggingService, sessionDidFinish session: PBDataLoggingSessionMetadata) {
        print("Done saving data")
    }

}

