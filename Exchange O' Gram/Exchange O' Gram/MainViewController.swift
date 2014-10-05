//
//  MainViewController.swift
//  Exchange O' Gram
//
//  Created by Nikhil Kulkarni on 10/4/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class MainViewController: ViewController {
    
    
    @IBOutlet var sellLabel: UIButton!
    @IBOutlet var buyLabel: UIButton!
   
    override func viewDidLoad() {
        sellLabel.alpha = 0;
        buyLabel.alpha = 0;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.sellLabel.alpha = 1.0
            self.buyLabel.alpha = 1.0
        })
    }
    
}
