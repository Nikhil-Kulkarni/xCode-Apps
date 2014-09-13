//
//  SecondViewController.swift
//  ToDoList2
//
//  Created by Nikhil Kulkarni on 6/17/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
                            
    @IBOutlet var taskField : UITextField
    @IBOutlet var descriptionField : UITextField
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonClicked(sender : UIButton) {
        
        TaskMgr.tasks.append(task(name: taskField.text, description: descriptionField.text))
        
        taskField.text = ""
        descriptionField.text = ""
        
        self.view.endEditing(true)
        
        self.tabBarController.selectedIndex = 0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        self.view.endEditing(true)
    }
    
    

}

