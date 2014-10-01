//
//  ItemManager.swift
//  Exchange O' Gram
//
//  Created by Nikhil Kulkarni on 9/30/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ItemManager {
    
    let itemPriceArray:NSMutableArray?
    let itemNameArray:NSMutableArray?
    let itemPhotoArray:NSMutableArray?
    let itemDescritionArray:NSMutableArray?
    
    func addItem (price: String, name: String, description: String, photo: UIImage) {
        
        itemPriceArray?.addObject(price)
        itemNameArray?.addObject(name)
        itemPhotoArray?.addObject(photo)
        itemDescritionArray?.addObject(description)
        
    }
    
    func getItem () {
        
    }
    
}
