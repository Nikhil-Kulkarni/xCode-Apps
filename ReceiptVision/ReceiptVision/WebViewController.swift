//
//  WebViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

var ACCESS_TOKEN: String?
var LIVE_TOKEN: String?

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://sanshackgt.azurewebsites.net/auth/windowslive")!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL?.absoluteString
        var jsonParser: AnyObject?
        if ((url!.containsString("sanshackgt.azurewebsites.net/auth/windowslive/callback"))) {
            let data = NSData(contentsOfURL: NSURL(string: url!)!)
            do {
                jsonParser = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            }
            catch {
                print("Error")
            }
            let dict = jsonParser as! NSDictionary
            print(dict)
            ACCESS_TOKEN = dict.objectForKey("access_token") as! String
            LIVE_TOKEN = dict.objectForKey("liveToken") as! String
            
            performSegueWithIdentifier("setBudget", sender: nil)
        }
        return true
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
