//
//  NewsTableViewController.swift
//  SimplyNews
//
//  Created by Nikhil Kulkarni on 6/2/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var num_rows = 1
    
    var abstractArray: [String] = []
    var imageURLArray: [String] = []
    var colorArray = [UIColor.flat(FlatColors.Downy), UIColor.flat(FlatColors.SilverTree), UIColor.flat(FlatColors.AquaIsland), UIColor.flat(FlatColors.Wistful)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: Selector("getStories"), forControlEvents: UIControlEvents.ValueChanged)
        
        getStories()

        let headerView:ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "worldnews"), forSize: CGSizeMake(self.tableView.frame.size.width, 150)) as! ParallaxHeaderView
        tableView.tableHeaderView = headerView
    
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableView.tableHeaderView = header
    }
    
    func getStories() {
        
        abstractArray.removeAll(keepCapacity: false)
        
        let url = NSURL(string: topStoryURL + API_KEY)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            let json = JSON(data: data, options: .AllowFragments, error: nil)
            if let num_results = json["num_results"].int {
               println(num_results)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.num_rows = num_results
                })
            }
            if let results = json["results"].array {
                for result in results {
                    self.abstractArray.append(result["abstract"].string!)
                    if result["multimedia"][0]["url"] != nil {
                        self.imageURLArray.append(result["multimedia"][0]["url"].string!)
                    } else {
                        self.imageURLArray.append("null")
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.refreshControl?.endRefreshing()
                        
                        self.tableView.reloadData()
                    })
                }
            }
        }
        task.resume()
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
        return abstractArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var label = cell.contentView.viewWithTag(1) as? UILabel
        var image = cell.contentView.viewWithTag(2) as? UIImageView
        
        label?.text = abstractArray[indexPath.row]
        if imageURLArray[indexPath.row] != "null" {
            image?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageURLArray[indexPath.row])!)!)
        }
        
        var colorIndex = indexPath.row % colorArray.count
//        cell.backgroundColor = colorArray[colorIndex]

        return cell
    }
    
    func uicolorFromHex(rgbValue:UInt32)-> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
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
