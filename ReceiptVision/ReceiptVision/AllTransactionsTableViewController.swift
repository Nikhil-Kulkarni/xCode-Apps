//
//  AllTransactionsTableViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllTransactionsTableViewController: UITableViewController {
    
    var activityIndicator: UIActivityIndicatorView?
    var nameArr = NSMutableArray()
    var priceArr = NSMutableArray()
    var timeArr = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let headerNib = UINib(nibName: "BudgetTransactions", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "tableHeader")
        
        let locationNib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.registerNib(locationNib, forCellReuseIdentifier: "locationCell")
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getData()
    }
    
    func getData() {
        let url = "https://sanshackgt.azurewebsites.net/get?access_token=\(ACCESS_TOKEN!)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        addActivityIndicator()
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
            let data = parsedJSON["data"].dictionary
            let items = data!["items"]!.array
            print(items)
            for item in items! {
                self.nameArr.addObject(item["name"].string!)
                self.priceArr.addObject(item["cost"].double!)
                self.timeArr.addObject(item["time"].string!)
            }
            self.tableView.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeActivityIndicator()
            })
        }
        task.resume()
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator!.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator!.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator!.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func removeActivityIndicator() {
        activityIndicator!.removeFromSuperview()
        activityIndicator = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameArr.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableHeader", forIndexPath: indexPath) as! BudgetTransactions
            cell.budgetTransactions.text = "Recent Transactions"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! HistoryCell
            cell.placeName.text = nameArr[indexPath.row] as! String
            cell.placeCategory.text = "Grocery"
            cell.datePurchased.text = timeArr[indexPath.row] as! String
            cell.moneySpent.text = "-\(priceArr[indexPath.row])"
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 40
        } else {
            return 55
        }
    }
   
}
