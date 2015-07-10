//
//  PlatformNode.swift
//  UberJump
//
//  Created by Nikhil Kulkarni on 6/10/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformNode: GameObjectNode {
    
    var platformType: PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if player.physicsBody?.velocity.dy < 0 {
            player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: 250.0)
            
            if platformType == PlatformType.Break {
                self.removeFromParent()
            }
        }
        
        //Indicates if the player gets points (only from stars)
        return false
    }
    
}
