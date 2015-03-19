//
//  InterfaceController.swift
//  AppCodaFoodPin WatchKit Extension
//
//  Created by Nikhil Kulkarni on 3/10/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = UIColor.greenColor()
        label.text = "Label"
        
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
