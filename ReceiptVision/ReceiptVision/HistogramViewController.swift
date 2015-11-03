//
//  HistogramViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/27/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistogramViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?

    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        let str = "https://sanshackgt.azurewebsites.net/fimp?access_token=\(ACCESS_TOKEN!)"
        let request = NSMutableURLRequest(URL: NSURL(string: str)!)
        addActivityIndicator()
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let parsedJSON = JSON(data: data!)
            print(parsedJSON["data"])

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let html = "<!doctype html><html><head><title>Example Domain</title><meta charset=utf-8 /><meta http-equiv=Content-type content=\"text/html; charset=utf-8\" /><meta name=viewport content=\"width=device-width, initial-scale=1\" /><script src=http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js></script><script src=http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js></script><style type=text/css>body{background:#eee}.barchart .bar{fill:steelblue}.barchart .bar:hover{fill:brown}.barchart .axis{font:10px sans-serif}.barchart .axis path,.barchart .axis line{fill:none;stroke:#000;shape-rendering:crispEdges}.title{font-family:arial;margin-left:70px}.barchart .x.axis path{display:none}</style></head><body><div><script src=http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js></script><script src=http://d3js.org/d3.v3.min.js></script><div class=\"page-header title\"><h3>Top Shopping Factors</h3></div><div id=holder><div class=barchart data-role=barchart data-width=320 data-height=400></div></div><script type=text/javascript>$(document).ready(function(){(function(i){var h={el:\"\",oldData:\"\",init:function(j){h.el=this;console.log(\"options\",j);var k=j.data.slice(0);h.setup(k,j.width,j.height)},update:function(j){h.el=this;h.animateBars(j)},animateBars:function(n){var j=d3.select(h.el.selector+\" .barchart\");var m=d3.select(h.el.selector+\" .barrects\");var k=0;var l=m.selectAll(\"rect\").data(n);l.enter().append(\"rect\").attr(\"class\",\"bar\").attr(\"y\",k);l.attr(\"height\",k).transition().duration(500).attr(\"x\",function(o){return h.x(o.letter)}).attr(\"width\",h.x.rangeBand()).attr(\"y\",function(o){return h.y(o.frequency)}).attr(\"height\",function(o){return h.height-h.y(o.frequency)});l.exit().transition().duration(250).attr(\"y\",k).attr(\"height\",k).remove()},setup:function(m,r,n){var p=\"\";var j=0.5;var k=0;var l={top:-55,right:20,bottom:90,left:40};h.width=r-l.left-l.right;h.height=n-l.top-l.bottom;h.x=d3.scale.ordinal().rangeRoundBands([0,h.width],0.1);h.y=d3.scale.linear().range([h.height,0]);h.xAxis=d3.svg.axis().scale(h.x).orient(\"bottom\");h.yAxis=d3.svg.axis().scale(h.y).orient(\"left\");var o=d3.select(h.el.selector).append(\"svg\").attr(\"class\",\"barchart\").attr(\"width\",h.width+l.left+l.right).attr(\"height\",h.height+l.top+l.bottom).append(\"g\").attr(\"transform\",\"translate(\"+l.left+\",\"+l.top+\")\");h.x.domain(m.map(function(s){return s.letter}));h.y.domain([k,j]);o.append(\"g\").attr(\"class\",\"y axis\").call(h.yAxis).append(\"text\").attr(\"transform\",\"rotate(-90)\").attr(\"y\",6).attr(\"dy\",\".71em\").style(\"text-anchor\",\"end\").text(p);o.append(\"g\").attr(\"class\",\"x axis\").attr(\"transform\",\"translate(0,\"+400+\")\").call(h.xAxis).selectAll(\"text\").style(\"text-anchor\",\"start\").attr(\"dx\",\"-2em\").attr(\"dy\",\"-0.5em\").attr(\"transform\",\"rotate(-90)\");this.barrects=o.append(\"g\").attr(\"class\",\"barrects\").attr(\"transform\",\"translate(0,0)\");h.animateBars(m);function q(s){s.frequency=+s.frequency;return s}}};i.fn.barchart=function(j){if(h[j]){return h[j].apply(this,Array.prototype.slice.call(arguments,1))}else{if(typeof j===\"object\"||!j){return h.init.apply(this,arguments)}else{i.error(\"Method \"+j+\" does not exist\")}}}})(jQuery);var a=300;var d=680;dataCharts=[];var b=[];var f=%graphdata%;var e=f.Results[\"output1\"][\"value\"][\"Values\"];for(var c=0;c<e.length;c++){b.push({frequency:Math.abs(parseFloat(e[c][1])),letter:e[c][0].substring(0,9)})}dataCharts.push({data:b});console.log(b);var g=jQuery.extend(true,{},dataCharts);$('[data-role=\"barchart\"]').each(function(j){var h=\"barchart\"+j;$(this).attr(\"id\",h);var i={data:g[0].data,width:$(this).data(\"width\"),height:$(this).data(\"height\")};$(\"#\"+h).barchart(i);$(\"#\"+h).barchart(\"update\",g[0].data)});$(\".testers a\").on(\"click\",function(j){j.preventDefault();var k=jQuery.extend(true,{},dataCharts);var i=0;var h=0.5;$('[data-role=\"barchart\"]').each(function(l){pos=Math.floor(Math.random()*(h-i+1))+i;$(\"#\"+$(this).attr(\"id\")).barchart(\"update\",k[pos].data)})})});</script></div></body></html>".stringByReplacingOccurrencesOfString("%graphdata%", withString: parsedJSON["data"].stringValue)
                self.webView.loadHTMLString(html, baseURL: nil)
                self.removeActivityIndicator()
            })
        }
        task.resume()


        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
