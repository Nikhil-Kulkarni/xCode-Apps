//
//  TaskManager.swift
//  ToDoList2
//
//  Created by Nikhil Kulkarni on 6/17/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

var TaskMgr: TaskManager = TaskManager()

struct task {
    
    var name = "no name"
    var description = "no description"
    
}


class TaskManager: NSObject {

    var tasks = task[]()
    
    func addTask(name: String, description: String){
        tasks.append(task(name: name, description: description))
    }
    
}
