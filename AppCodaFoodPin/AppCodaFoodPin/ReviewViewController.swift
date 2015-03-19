//
//  ReviewViewController.swift
//  AppCodaFoodPin
//
//  Created by Nikhil Kulkarni on 2/19/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var dialogView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var blurEffect = UIBlurEffect(style: .Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        background.addSubview(blurEffectView)
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 667)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
    }

    override func viewDidAppear(animated: Bool) {
        
//        UIView.animateWithDuration(0.7, delay: 0.0, options: nil, animations: {
//            self.dialogView.transform = CGAffineTransformMakeScale(1.0, 1.0)
//            }, completion: nil)

        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            let scale = CGAffineTransformMakeScale(1.0, 1.0)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
        }, completion: nil)
    
    }

}
