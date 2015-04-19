//
//  SelectionController.swift
//  eMart
//
//  Created by Nikhil Kulkarni on 3/21/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!    
    @IBOutlet weak var background: UIImageView!
    
    let fb = Firebase(url: "https://kangamart.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        background.addSubview(blurView)
        background.layer.zPosition = 0
    }
    
    @IBAction func signUpClicked(sender: AnyObject) {
        fb.createUser(usernameField.text, password: passwordField.text) { (error, authdata) -> Void in
            if (error != nil) {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Done", style: .Cancel, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                var vc = self.storyboard?.instantiateViewControllerWithIdentifier("selection") as SelectionController
                self.presentViewController(vc, animated: true, completion: nil)
                println(authdata.description)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}

