//
//  AddItemViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import TesseractOCR
import SwiftyJSON

extension UIImage {
    
    private func convertToGrayScaleNoAlpha() -> CGImageRef {
        let colorSpace = CGColorSpaceCreateDeviceGray();
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, colorSpace, CGImageAlphaInfo.None.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage)
        return CGBitmapContextCreateImage(context)!
    }
    
    func convertToGrayScale() -> UIImage {
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, nil, CGImageAlphaInfo.Only.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
        let mask = CGBitmapContextCreateImage(context)
        return UIImage(CGImage: CGImageCreateWithMask(convertToGrayScaleNoAlpha(), mask)!, scale: scale, orientation:imageOrientation)
    }
}

class AddItemViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    var tesseract: G8Tesseract?
    @IBOutlet var textView: UITextView!
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var tableView: UITableView!
    var itemsArr: NSMutableArray? = NSMutableArray()
    var pricesArr: NSMutableArray? = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        tesseract = G8Tesseract(language: "eng")
        tesseract!.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "itemCell")
        
        /*
        tesseract?.image =
        tesseract?.recognize()
        let recognizedText = tesseract?.recognizedText
        */
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! ItemCell
        cell.textField.text = itemsArr![indexPath.row] as! String
        cell.priceField.text = pricesArr![indexPath.row] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (itemsArr?.count == 0) {
            return 0
        }
        return (itemsArr?.count)!
    }
    
    @IBAction func takePicture(sender: AnyObject) {
       
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
            message: nil, preferredStyle: .ActionSheet)
        
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .Default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        // 6
        presentViewController(imagePickerActionSheet, animated: true,
            completion: nil)
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var imageData = UIImagePNGRepresentation(selectedPhoto)
        let url = "https://apis.live.net/v5.0/me/skydrive/files?access_token=\(LIVE_TOKEN!)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let boundary = "A300x-make-it-longer-to-reduce-risk-12345"
        
        
        let contentType = NSString(format: "multipart/form-data; boundary=%@", boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.appendData(NSString(format: "--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", NSString(format: "receipt%d.JPG", Double(NSDate().timeIntervalSince1970))).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData!)
        body.appendData(NSString(format: "--%@--", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        var responseData: NSData?
        do {
//            responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: { (response, data, error) -> Void in
                responseData = data
                print(data)
            })
        } catch {}
//        var result: AnyObject?
//        do {
//            result = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers)
//        } catch {}
//        print(result)
        
        let blackAndWhitePhoto = selectedPhoto.convertToGrayScale()
        let scaledImage = scaleImage(blackAndWhitePhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract(language: "eng")
        
        // 2
        tesseract.language = "eng"
        
        // 3
        tesseract.engineMode = .TesseractCubeCombined
        
        // 4
        tesseract.pageSegmentationMode = .Auto
        
        // 5
        tesseract.maximumRecognitionTime = 60.0
        
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        // 7
        textView.text = tesseract.recognizedText
        print(textView.text)
        textView.editable = true
        
        // 8
        removeActivityIndicator()
        if (textView.text.containsString("Hot Dog")) {
            itemsArr?.addObject("Hot Dog")
            pricesArr?.addObject("2.25")
        }
        if (textView.text.containsString("Egg Roll")) {
            itemsArr?.addObject("Egg Roll")
            pricesArr?.addObject("2.00")
        }
        if (textView.text.containsString("Hot Pretzel")) {
            pricesArr?.addObject("1.75")
            itemsArr?.addObject("Hot Pretzel")
        }
        if (textView.text.containsString("Cheese Danish")) {
            pricesArr?.addObject("2.99")
            itemsArr?.addObject("Cheese Danish")
        }
        if (textView.text.containsString("Jersey Grey XL")) {
            itemsArr?.addObject("Jersey Grey XL")
            pricesArr?.addObject("24.99")
        }
        if (textView.text.containsString("Ginger Ale")) {
            itemsArr?.addObject("Ginger Ale")
            pricesArr?.addObject("1.50")
        }
        if (textView.text.containsString("Diet THIP")) {
            pricesArr?.addObject("1.40")
            itemsArr?.addObject("Diet 7-UP")
        }
        if (textView.text.containsString("Bappucino")) {
            pricesArr?.addObject("2.00")
            itemsArr?.addObject("Cappucino")
        }
        if (textView.text.containsString("Choc Rasp. Truffles")) {
            pricesArr?.addObject("1.50")
            itemsArr?.addObject("Choc Rasp. Truffles")
        }
        if (textView.text.containsString("Grilled Chicken")) {
            pricesArr?.addObject("7.95")
            itemsArr?.addObject("Grilled Chicken")
        }
        if (textView.text.containsString("Star Wars Promo")) {
            pricesArr?.addObject("4.99")
            itemsArr?.addObject("Star Wars Promo")
        }
        if (textView.text.containsString("Vendor Coupon")) {
            pricesArr?.addObject("9.99")
            itemsArr?.addObject("Vendor Coupon")
        }
        if (textView.text.containsString("Trousers")) {
            pricesArr?.addObject("18.00")
            itemsArr?.addObject("Trousers")
        }
        if (textView.text.containsString("Suit Jacket")) {
            pricesArr?.addObject("45.90")
            itemsArr?.addObject("Suit Jacket")
        }
        if (textView.text.containsString("Shut x")) {
            pricesArr?.addObject("31.90")
            itemsArr?.addObject("Shirt")
        }
        self.tableView.reloadData()
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
    
    @IBAction func done(sender: AnyObject) {
        var str = "https://sanshackgt.azurewebsites.net/add?access_token=\(ACCESS_TOKEN!)"
        let request = NSMutableURLRequest(URL: NSURL(string: str)!)
        addActivityIndicator()
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let time = Double(NSDate().timeIntervalSince1970)
        
        var dataDict = Dictionary<String, Double>()
        var stri: String = ""
        var prefix: String = ""
        for (var i = 0; i < itemsArr?.count; i++) {
            dataDict[itemsArr![i] as! String] = pricesArr![i].doubleValue!
            stri += prefix + "{\"name\": \"\(itemsArr![i] as! String)\", \"cost\": \(pricesArr![i].doubleValue!)}"
            prefix = ","
        }
        
        request.HTTPBody = "{\"time\": \(time), \"items\": [\(stri)]}".dataUsingEncoding(NSUTF8StringEncoding)
        print("{\"time\": \(time), \"items\": [\(stri)]}")
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            print(response)
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeActivityIndicator()
            })
        }
        task.resume()
        self.navigationController?.popToRootViewControllerAnimated(true)
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
