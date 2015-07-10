//
//  Player.swift
//  LineJumper
//
//  Created by Nikhil Kulkarni on 6/13/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class Player:SKSpriteNode {
    
    let playerColor = UIColor.blackColor()
    
    init(size:CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
//        let block = SKSpriteNode(color: playerColor, size: size)
//        block.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        block.position = CGPoint(x: 0, y: 0)       
//        
//        addChild(block)
        
        let circle = SKShapeNode(circleOfRadius: 10.0)
        circle.position = CGPoint(x: 0, y: 0)
        circle.fillColor = UIColor.flat(FlatColors.Turquoise)
        circle.strokeColor = UIColor.flat(FlatColors.Turquoise)
        addChild(circle)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveOver() {
        let move = SKAction.moveByX(sizeOfScreen.width / CGFloat(NUMBER_OF_SEGMENTS), y: 0, duration: 0.2)
        runAction(move)
    }
}
