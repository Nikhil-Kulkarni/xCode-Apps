//
//  SpendingViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/27/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON

class SpendingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerOne: UIPickerView!
    @IBOutlet var pickerTwo: UIPickerView!
    @IBOutlet var webView: UIWebView!
    
    var activityIndicator: UIActivityIndicatorView?
    
    var pickerData: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        // Do any additional setup after loading the view.
        
        pickerData = ["Cereals", "Bakery", "Meats", "Poultry", "Fish", "Eggs", "Dairy", "Fruits", "Vegetables", "Sugars/sweets", "Fats/Oils", "Grains"]
        
        pickerOne.delegate = self
        pickerOne.dataSource = self
        pickerTwo.delegate = self
        pickerTwo.dataSource = self
        
    }

    @IBAction func confirm(sender: AnyObject) {
        let str = "https://sanshackgt.azurewebsites.net/analyze?access_token=\(ACCESS_TOKEN!)"
        print(str)
        let request = NSMutableURLRequest(URL: NSURL(string: str)!)
        addActivityIndicator()
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.HTTPBody = "{\"cat1\": \"\(pickerData![pickerOne.selectedRowInComponent(0)])\"\n, \"cat2\": \"\(pickerData![pickerTwo.selectedRowInComponent(0)])\"}".dataUsingEncoding(NSUTF8StringEncoding)
        print("{\"cat1\": \"\(pickerData![pickerOne.selectedRowInComponent(0)])\"\n, \"cat2\": \"\(pickerData![pickerTwo.selectedRowInComponent(0)])\"}")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            print(response)
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let html = "<!DOCTYPE html><html lang=en><head><meta charset=utf-8><title>Paylytics</title><script src=http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.5.min.js type=text/javascript></script><script src=http://d3js.org/d3.v3.min.js></script><script src=http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js></script><link href=http://getbootstrap.com/dist/css/bootstrap.min.css rel=stylesheet><style type=text/css>.axis path,.axis line{fill:none;stroke:black;shape-rendering:crispEdges}body{text-align:center}.bold{font-weight:bold}.axis text{font-family:sans-serif;font-size:11px}.centb{text-align:center;margin-top:5px}.cent{border-bottom:1px solid black;text-align:center;font-size:.5em}.smaller{font-size:3em}.aler{width:100%;text-align:center;margin-left:0;height:40px;margin-top:-320px;vertical-align:middle}</style></head><body><div class=container><div class=centb><svg id=visualisation width=400 height=300></svg></div></div><script type=text/javascript>var w=400;var h=300;var padding=50;$(\"#alerty\").hide();$(\"#alerty1\").hide();var dat=%graphdata%;var dataset=[];var parsed=(dat.Results[\"output1\"][\"value\"][\"Values\"]);for(var i=0;i<parsed.length;i++){for(var j=0;j<4;j++){console.log(j);if(j==0||j===1){parsed[i][j]=(parseInt(parsed[i][j]));console.log(parsed[i][j]+\"ij\")}}dataset.push(parsed[i])}console.log(dataset);var xScale=d3.scale.linear().domain([0,d3.max(dataset,function(a){return a[0]})]).range([padding,w-padding*2]);var yScale=d3.scale.linear().domain([0,d3.max(dataset,function(a){return a[1]})]).range([h-padding,padding]);var rScale=d3.scale.linear().domain([0,d3.max(dataset,function(a){return a[1]})]).range([2,5]);var xAxis=d3.svg.axis().scale(xScale).orient(\"bottom\").ticks(5);var yAxis=d3.svg.axis().scale(yScale).orient(\"left\").ticks(5);var svg=d3.select(\"#visualisation\").append(\"svg\").attr(\"width\",w).attr(\"height\",h);svg.append(\"g\").append(\"text\").attr(\"class\",\"label\").attr(\"transform\",\"rotate(-90)\").attr(\"y\",12).attr(\"dy\",\".71em\").attr(\"dx\",\"-12em\").style(\"text-anchor\",\"end\").attr(\"id\",\"my-axis-name\").text(\"Item 2 ($)\");svg.append(\"g\").append(\"text\").attr(\"class\",\"label\").attr(\"x\",w).attr(\"y\",-6).style(\"text-anchor\",\"end\").text(\"Calories\");svg.selectAll(\"circle\").data(dataset).enter().append(\"circle\").attr(\"cx\",function(a){return xScale(a[0])}).attr(\"cy\",function(a){return yScale(a[1])}).attr(\"r\",function(a){if(a[3]===\"1\"){return rScale(100)}else{return rScale(2)}}).style(\"fill\",function(a){if(a[2]===\"1\"&&a[3]!==\"1\"){return\"green\"}else{if(a[2]===\"0\"&&a[3]!==\"1\"){return\"red\"}else{if(a[2]===\"0\"&&a[3]===\"1\"){return\"#FF6666\"}else{return\"#4DB870\"}}}}).on(\"click\",function(a){if(a[3]===\"1\"&&a[2]===\"1\"){$(\"#alerty2\").hide();$(\"#alerty1\").hide();$(\"#alerty\").show()}else{if(a[3]===\"1\"&&a[2]===\"0\"){$(\"#alerty2\").hide();$(\"#alerty\").hide();$(\"#alerty1\").show()}}}).style(\"stroke\",function(a){if(a[3]===\"1\"){return\"black\"}});svg.append(\"g\").attr(\"class\",\"axis\").attr(\"transform\",\"translate(0,\"+(h-padding)+\")\").attr(\"stroke-width\",1.2).call(xAxis);svg.append(\"g\").attr(\"class\",\"axis\").attr(\"transform\",\"translate(\"+padding+\",0)\").attr(\"stroke-width\",1.2).call(yAxis);var legend=svg.selectAll(\".legend\").data(color.domain()).enter().append(\"g\").attr(\"class\",\"legend\").attr(\"transform\",function(b,a){return\"translate(0,\"+a*20+\")\"});legend.append(\"rect\").attr(\"x\",width-18).attr(\"width\",18).attr(\"height\",18).style(\"fill\",\"red\");legend.append(\"text\").attr(\"x\",width-24).attr(\"y\",9).attr(\"dy\",\".35em\").style(\"text-anchor\",\"end\").text(function(a){return a});</script><div class=\"alert alert-info aler\" id=alerty2>Click a circle to find out what it means.</div><div class=\"alert alert-success aler\" role=alert id=alerty>Receipts w/ under-budget spending behavior.</div><div class=\"alert alert-danger aler\" role=alert id=alerty1>Receipts w/ over-budget spending behavior.</div></body></html>".stringByReplacingOccurrencesOfString("%graphdata%", withString: parsedJSON["data"].stringValue)
                self.webView.loadHTMLString(html, baseURL: nil)
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData![row] as! String
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerData?.count)!
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
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
