//
//  NKCloud.swift
//  NimbleNinja
//
//  Created by Nikhil Kulkarni on 5/3/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class NKCloud:SKShapeNode {
    init(size: CGSize) {
        super.init()
        let path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, size.width, size.height), nil)
        self.path = path
        fillColor = UIColor.whiteColor()
        
        startMoving()
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveByX(-10, y: 0, duration: 1)
        runAction(SKAction.repeatActionForever(moveLeft))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}