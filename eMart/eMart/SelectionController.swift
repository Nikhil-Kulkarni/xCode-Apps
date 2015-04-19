//
//  SelectionController.swift
//  eMart
//
//  Created by Nikhil Kulkarni on 3/21/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class SelectionController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    
    
    let fb = Firebase(url: "https://kangamart.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        image.addSubview(blurView)
        
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue) {
    }
    
}
