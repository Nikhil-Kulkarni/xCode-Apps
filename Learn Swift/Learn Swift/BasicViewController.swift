//
//  BasicViewController.swift
//  Learn Swift
//
//  Created by Nikhil Kulkarni on 10/4/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class BasicViewController: ViewController {
    
    @IBOutlet var scrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        //scrollView.scrollEnabled = true
        //scrollView.contentSize = CGSizeMake(400, 776)
    }
   
}
