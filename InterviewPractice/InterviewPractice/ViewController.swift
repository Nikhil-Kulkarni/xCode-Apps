//
//  ViewController.swift
//  InterviewPractice
//
//  Created by Nikhil Kulkarni on 11/10/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            print("Outside sync")
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                print("asdf")
            })
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

