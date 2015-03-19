//
//  ViewController.swift
//  eMart
//
//  Created by Nikhil Kulkarni on 3/18/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        background.addSubview(blurView)
        background.layer.zPosition = 0
        signIn.layer.zPosition = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        signIn.transform = CGAffineTransformMakeTranslation(-250, 0)
        signUp.transform = CGAffineTransformMakeTranslation(250, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.0, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            self.signIn.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            self.signUp.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

