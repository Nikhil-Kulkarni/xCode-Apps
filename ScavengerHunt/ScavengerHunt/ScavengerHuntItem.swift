//
//  ScavengerHuntItem.swift
//  ScavengerHunt
//
//  Created by Nikhil Kulkarni on 9/18/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ScavengerHuntItem: NSObject {
    
    private struct SerializationKeys {
        static let name = "name"
        static let photo = "photo"
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(name, forKey: SerializationKeys.name)
        if let thePhoto = photo {
            coder.encodeObject(thePhoto, forKey: SerializationKeys.photo)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(SerializationKeys.name) as String
        photo = aDecoder.decodeObjectForKey(SerializationKeys.photo) as? UIImage
    }
    
    
    let name:String
    var photo: UIImage?
    var isComplete: Bool {
        get {
            return photo != nil
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
}
