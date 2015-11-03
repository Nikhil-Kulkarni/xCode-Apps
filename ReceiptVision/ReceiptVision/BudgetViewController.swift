//
//  BudgetViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import PNChartSwift

class BudgetViewController: UIViewController {
    
    var items: NSMutableArray?
    @IBOutlet var lineGraphView: UIView!
    @IBOutlet var barGraphView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let lineChart = PNLineChart(frame: CGRectMake(0, 25, self.lineGraphView.frame.width, self.lineGraphView.frame.height - 25))
        lineChart.xLabels = ["SEP 21", "SEP 22", "SEP 23", "SEP 24", "SEP 25", "SEP 26"]
        
        items = ["60.1", "160.1", "126.4", "56.5", "25.2", "45.2"]
        let data01 = PNLineChartData()
        data01.color = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        data01.itemCount = lineChart.xLabels.count
        data01.getData = getItems
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        self.lineGraphView.addSubview(lineChart)
        
        let barChart = PNBarChart(frame: CGRectMake(0, 25, self.barGraphView.frame.width, self.barGraphView.frame.height - 25))
        barChart.xLabels = ["Clothing", "Electronics", "Entertainment", "Gas", "Gifts", "Grocery", "Miscellaneous", "Restaurants"]
        barChart.yValues = [2, 7, 3, 5, 8, 4, 2, 6]
        barChart.yValueMax = CGFloat(10.0)
        barChart.strokeColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        barChart.strokeChart()
        self.barGraphView.addSubview(barChart)
        // Do any additional setup after loading the view.
    }
    
    func getItems(count:Int) -> PNLineChartDataItem {
        let yValue:CGFloat = CGFloat(items![count].floatValue)
        return PNLineChartDataItem(y: yValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
