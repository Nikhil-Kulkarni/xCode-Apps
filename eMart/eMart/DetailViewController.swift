//
//  DetailViewController.swift
//  eMart
//
//  Created by Nikhil Kulkarni on 3/21/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let fb = Firebase(url: "https://kangamart.firebaseio.com/")
    
    @IBOutlet weak var orderDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func buyNowClicked(sender: AnyObject) {
        fb.childByAutoId().setValue(orderDetails.text)
        var alreadyOrdered = true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
    }
}
