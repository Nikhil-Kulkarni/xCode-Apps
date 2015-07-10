//
//  NKCloudGenerator.swift
//  NimbleNinja
//
//  Created by Nikhil Kulkarni on 5/3/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class NKCloudGenerator:SKSpriteNode {
    let CLOUD_WIDTH:CGFloat = 155.0
    let CLOUD_HEIGHT:CGFloat = 55.0
    
    var generationTimer: NSTimer!
    
    func populate(num: Int) {
        for var i = 0; i < num; i++ {
            let cloud = NKCloud(size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT))
            let x = CGFloat(arc4random_uniform(UInt32(size.width))) - size.width / 2
            let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
            cloud.position = CGPointMake(x, y)
            cloud.zPosition = -1
            addChild(cloud)
        }
    }
    
    func startGeneratingWithSpawnTime(seconds: NSTimeInterval) {
        generationTimer = NSTimer(timeInterval: seconds, target: self, selector: Selector("generateCloud"), userInfo: nil, repeats: true)
    }
    
    func generateCloud() {
        let x = size.width / 2 + CLOUD_WIDTH / 2
        let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
        let cloud = NKCloud(size: CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT))
        cloud.position = CGPointMake(x, y)
        cloud.zPosition = -1
        addChild(cloud)
    }
    
}