//
//  ListViewController.swift
//  ScavengerHunt
//
//  Created by Nikhil Kulkarni on 9/18/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   // var itemsList = [ScavengerHuntItem]()
    
    let itemsManager = ItemsManager()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsManager.items.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera //UIImagePickerControllerSource.Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary //UIImagePickerControllerSource.PhotoLibrary
        }
         
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let indexPath = tableView.indexPathForSelectedRow()!
        let selectedItem = itemsManager.items[indexPath.row]
        
        let photo = info[UIImagePickerControllerOriginalImage] as UIImage
        selectedItem.photo = photo
        itemsManager.save()
        
        dismissViewControllerAnimated(true, completion: {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        })
        
    }
    
    /* 
    
        <LocalAuthenticationLocalAuthentication.h
    
    
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell") as UITableViewCell
        
        let item = itemsManager.items[indexPath.row]
        cell.textLabel!.text = item.name
        
        if (item.isComplete) {
            cell.accessoryType = .Checkmark
            cell.imageView!.image = item.photo
        } else {
            cell.accessoryType = .None
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
        if segue.identifier == "DoneItem" {
            let addItemController = segue.sourceViewController as ViewController
            
            if let newItem = addItemController.createdName {
                itemsManager.items += [newItem]
                itemsManager.save()
                
                let indexPath = NSIndexPath(forRow: itemsManager.items.count - 1, inSection: 0)
                
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        
    }
    
}
