//
//  ViewController.swift
//  Exchange O' Gram
//
//  Created by Nikhil Kulkarni on 9/27/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemPrice: UITextField!
    @IBOutlet var itemDescription: UITextField!
    
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        let name:String = itemName.text
        let price:String = itemPrice.text
        let description:String = itemDescription.text
        
        itemName.text = ""
        itemPrice.text = ""
        itemDescription.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        itemName.resignFirstResponder()
        itemPrice.resignFirstResponder()
        itemDescription.resignFirstResponder()
    }


}

