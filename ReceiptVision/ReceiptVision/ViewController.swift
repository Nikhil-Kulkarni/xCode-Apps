//
//  ViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON
import PNChartSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activityIndicator: UIActivityIndicatorView?
    var nameArr = NSMutableArray()
    var priceArr = NSMutableArray()
    var timeArr = NSMutableArray()
    
    @IBOutlet var historyTable: UITableView!
    @IBOutlet var budgetGraphView: UIView!
    @IBOutlet var showBudgets: UIButton!
    @IBOutlet var spendingBehavior: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
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
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeActivityIndicator()
                self.historyTable.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        // Do any additional setup after loading the view, typically from a nib.
        
        historyTable.delegate = self
        historyTable.dataSource = self
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
        
        let locationNib = UINib(nibName: "HistoryCell", bundle: nil)
        let topHistoryNib = UINib(nibName: "BudgetTransactions", bundle: nil)
        let allTransactionsNib = UINib(nibName: "AllTransactions", bundle: nil)
        historyTable.registerNib(locationNib, forCellReuseIdentifier: "locationCell")
        historyTable.registerNib(topHistoryNib, forCellReuseIdentifier: "topHistoryNib")
        historyTable.registerNib(allTransactionsNib, forCellReuseIdentifier: "allTransactions")
        
        let barChart: PNBarChart = PNBarChart(frame: CGRectMake(0, 25, budgetGraphView.frame.width, budgetGraphView.frame.height - 55))
        barChart.xLabels = ["Clothing", "Grocery", "Restaurants", "Electronics", "Fun"]
        barChart.yValues = [1, 8, 2, 6, 4]
        barChart.strokeColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        barChart.strokeChart()
        self.budgetGraphView.addSubview(barChart)
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row != 0 && indexPath.row != 4 && indexPath.row != 5) {
            let cell = historyTable.dequeueReusableCellWithIdentifier("locationCell") as! HistoryCell
            cell.placeName.text = nameArr[indexPath.row] as! String
            cell.placeCategory.text = "Grocery"
            cell.datePurchased.text = timeArr[indexPath.row] as! String
            cell.moneySpent.text = "-\(priceArr[indexPath.row])"
            
            return cell
        }
        else if (indexPath.row == 0) {
            let cell = historyTable.dequeueReusableCellWithIdentifier("topHistoryNib") as! BudgetTransactions
            cell.budgetTransactions.text = "Recent Transactions"
            return cell
        } else if (indexPath.row == 4) {
            let cell = historyTable.dequeueReusableCellWithIdentifier("allTransactions") as! AllTransactions
            cell.allTransactions.text = "All Transactions"
            return cell
        } else {
            let cell = historyTable.dequeueReusableCellWithIdentifier("allTransactions") as! AllTransactions
            cell.allTransactions.text = "Feature Importance"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 4) {
            performSegueWithIdentifier("allTransactions", sender: nil)
        }
        if (indexPath.row == 5) {
            performSegueWithIdentifier("goToHistogram", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (nameArr.count == 0) {
            return 0
        } else {
            return 6
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row != 0 && indexPath.row != 4 && indexPath.row != 5) {
            return 45
        } else {
            return 40
        }
    }


}

