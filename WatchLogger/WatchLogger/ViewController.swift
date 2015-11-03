//
//  ViewController.swift
//  WatchLogger
//
//  Created by Nikhil Kulkarni on 10/30/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusLabel: UILabel!
    var contentArr = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if (WCSession.isSupported()) {
            print("Session is supported")
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.font = UIFont(name: "Avenir Next", size: 8.0)
        cell?.textLabel?.text = self.contentArr[indexPath.row] as? String
        
        return cell!
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Session message received")
        
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths.objectAtIndex(0)
        let currentDate = CFAbsoluteTimeGetCurrent()
        let fileName = "\(documentDirectory)/\(currentDate.description).log"
        let cArr = message["userInfo"] as! NSArray
        self.contentArr = cArr
        
        var content: String = ""
        for str in cArr {
            content = "\(content)\n\(str)"
        }
        do {
            try content.writeToFile(fileName, atomically: true, encoding: NSStringEncodingConversionOptions.AllowLossy.rawValue)
        }
        catch {
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }

    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        // Write data to file
        print("Message Received")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.statusLabel.text = "Writing content"
        }
        
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths.objectAtIndex(0)
        let currentDate = CFAbsoluteTimeGetCurrent()
        let fileName = "\(documentDirectory)/\(currentDate.description).log"
        let cArr = userInfo["userInfo"] as! NSArray
        self.contentArr = cArr
        
        var content: String = ""
        for str in cArr {
            content = "\(content)\n\(str)"
        }
        
        do {
            try content.writeToFile(fileName, atomically: true, encoding: NSStringEncodingConversionOptions.AllowLossy.rawValue)
        }
        catch {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.statusLabel.text = "Writing content failed"
            })
        }
    }
}

