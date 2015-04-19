//
//  BuyViewController.swift
//  eMart
//
//  Created by Nikhil Kulkarni on 3/21/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    
    
    @IBOutlet weak var creditNumber: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var cvv: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
