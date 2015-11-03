//
//  SetBudgetViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON

class SetBudgetViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?

    @IBOutlet var budgetField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func letsGo(sender: AnyObject) {
        let str = "https://sanshackgt.azurewebsites.net/set?access_token=\(ACCESS_TOKEN!)"
        let request = NSMutableURLRequest(URL: NSURL(string: str)!)
        addActivityIndicator()
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"budget\": \(budgetField!.text!)}".dataUsingEncoding(NSUTF8StringEncoding)
        print("{\"budget:\" \(budgetField!.text!)}")
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            print(response)
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeActivityIndicator()
            })
        }
        task.resume()
        performSegueWithIdentifier("goToMain", sender: nil)
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator!.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator!.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator!.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func removeActivityIndicator() {
        activityIndicator!.removeFromSuperview()
        activityIndicator = nil
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.budgetField.endEditing(true)
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
