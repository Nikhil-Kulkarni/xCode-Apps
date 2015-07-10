//
//  ViewController.swift
//  IdeaSharing
//
//  Created by Nikhil Kulkarni on 6/21/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var composeText: UITextView!
    
    let Ideas = PFObject(className: "Ideas")
    
    @IBAction func saveIdea(sender: AnyObject) {
        
        Ideas["description"] = composeText.text
        Ideas["upvotes"] = 0
        Ideas.saveInBackground()
        
        var next = self.storyboard?.instantiateViewControllerWithIdentifier("temp") as! IdeaTableViewController
        self.presentViewController(next, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        // Do any additional setup after loading the view, typically from a nib.
        composeText.delegate = self
    }
    
    func textViewDidChange(textView: UITextView) {
        println("changed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

