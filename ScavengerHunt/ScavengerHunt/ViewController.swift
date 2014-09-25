//
//  ViewController.swift
//  ScavengerHunt
//
//  Created by Nikhil Kulkarni on 9/18/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var textField: UITextField!
    
    var createdName: ScavengerHuntItem?
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //releases ViewController from memory
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DoneItem" {
            if let name = textField.text {
                if !name.isEmpty {
                    createdName = ScavengerHuntItem(name: name)
                }
            }
        }
        
    }

}

