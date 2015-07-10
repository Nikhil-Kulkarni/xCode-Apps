//
//  IdeaTableViewController.swift
//  IdeaSharing
//
//  Created by Nikhil Kulkarni on 6/24/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import Parse

class IdeaTableViewController: UITableViewController {
    
    let query:PFQuery = PFQuery(className: "Ideas")
    var objects:[PFObject] = [PFObject]()
    
    @IBOutlet var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor(red: 80/255.0, green: 227/255.0, blue: 194/255.0, alpha: 1.0)
        self.refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var nib = UINib(nibName: "IdeaCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "IdeaCell")
//        reloadData()
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    func reloadData() {
        if segmentControl.selectedSegmentIndex == 0 {
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock { (arr, error) -> Void in
                self.objects = arr as! [PFObject]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }
        }
        if segmentControl.selectedSegmentIndex == 1 {
            query.orderByDescending("upvotes")
            query.findObjectsInBackgroundWithBlock { (arr, error) -> Void in
                self.objects = arr as! [PFObject]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return objects.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IdeaCell", forIndexPath: indexPath) as! IdeaCell
        cell.ideaLabel.text = objects[indexPath.row]["description"] as! String
        
        let upvotes = objects[indexPath.row]["upvotes"] as! NSNumber
        cell.upvoteCount.text = "\(upvotes)"
        
        cell.objectID = objects[indexPath.row].objectId
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
