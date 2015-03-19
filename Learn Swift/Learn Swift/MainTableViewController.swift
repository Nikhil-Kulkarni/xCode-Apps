//
//  MainTableViewController.swift
//  Learn Swift
//
//  Created by Nikhil Kulkarni on 10/4/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var tableOfContent:NSMutableArray = ["Basics", "Storyboard", "Control Flow", "Functions", "Classes", "UIKit", "Simple Table App", "Parse", "Build this app!"]
    
    var detail:NSMutableArray = ["Guts of programs", "Visualing your app", "if-statements, loops", "Code snippets", "Objects", "UI elements", "tableViewControllers", "Put data in the cloud", "Yay!"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tableOfContent.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = tableOfContent[indexPath.section] as? String
        cell.detailTextLabel!.text = detail[indexPath.section] as? String
        cell.alpha = 0
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            cell.alpha = 1.0
        })

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0) {
            var basic: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BasicView") as UIViewController
            //self.navigationController?.pushViewController(basic, animated: true)
            println("Basic of Programming")
            self.navigationController?.pushViewController(basic, animated: true)
        }
        if(indexPath.section == 1) {
            var storyboard: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Storyboard") as UIViewController
            self.navigationController?.pushViewController(storyboard, animated: true)
            println("Storyboard")
        }
        if(indexPath.section == 2) {
            var controlFlow: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Control Flow") as UIViewController
            self.navigationController?.pushViewController(controlFlow, animated: true)
            println("Control Flow")
        }
        if(indexPath.section == 3) {
            var functions: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Functions") as UIViewController
            self.navigationController?.pushViewController(functions, animated: true)
            println("Function")
        }
        if(indexPath.section == 4) {
            var classes: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("classes") as UIViewController
            self.navigationController?.pushViewController(classes, animated: true)
            println("Classes")
        }
        if(indexPath.section == 5) {
            var uikit: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("uikit") as UIViewController
            self.navigationController?.pushViewController(uikit, animated: true)
            println("UIKit")
        }
        if(indexPath.section == 6) {
            var simpleTableApp: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Simple Table App") as UIViewController
            self.navigationController?.pushViewController(simpleTableApp, animated: true)
            println("Simple table app")
        }
        if(indexPath.section == 7) {
            var parse: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Parse") as UIViewController
            self.navigationController?.pushViewController(parse, animated: true)
            println("Parse")
        }
        if(indexPath.section == 8) {
            var makeThisApp: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("makeThisApp") as UIViewController
            self.navigationController?.pushViewController(makeThisApp, animated: true)
            println("Make this app!")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
