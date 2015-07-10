//
//  StarNode.swift
//  UberJump
//
//  Created by Nikhil Kulkarni on 6/10/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

let starSound = SKAction.playSoundFileNamed("StarPing.wav", waitForCompletion: false)

class StarNode:GameObjectNode {
    
    var starType: StarType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVectorMake((player.physicsBody?.velocity.dx)!, 400.0)
        
        runAction(starSound) { () -> Void in
            self.removeFromParent()
        }
        
        return true
    }
    
}
