//
//  ShareViewController.swift
//  AppCodaFoodPin
//
//  Created by Nikhil Kulkarni on 2/19/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
//import WatchKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var message: UIButton!
    @IBOutlet weak var email: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        background.addSubview(blurEffectView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        facebook.transform = CGAffineTransformMakeTranslation(0, 667)
        message.transform = CGAffineTransformMakeTranslation(0, 667)
        twitter.transform = CGAffineTransformMakeTranslation(0, -667)
        email.transform = CGAffineTransformMakeTranslation(0, -667)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.facebook.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
        
        UIView.animateWithDuration(1.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.email.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
        
        UIView.animateWithDuration(1.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.message.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
        
        UIView.animateWithDuration(1.3, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.twitter.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
    }
    
    
}
