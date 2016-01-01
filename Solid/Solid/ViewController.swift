//
//  ViewController.swift
//  Solid
//
//  Created by Nikhil Kulkarni on 12/23/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON

var global_phone_number = ""

class ViewController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(sender: AnyObject) {
        if (name.text == "") {
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            let alertView = UIAlertController(title: "Name", message: "Enter Name", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(alertAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else if (phoneNumber.text == "") {
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            let alertView = UIAlertController(title: "Phone Number", message: "Enter Phone Number", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(alertAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            let post: String = "name=\(name.text!)&phone_number=\(phoneNumber.text!)"
            let postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
            let postLength: String = "\(postData.length)"
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8080/api/register")!)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let json = JSON(data: data!)
                if let message = json["message"].string {
                    print(message)
                    global_phone_number = self.phoneNumber.text!
                    self.performSegueWithIdentifier("showSolids", sender: nil)
                }
            })
            task.resume()
        }
    }
}

