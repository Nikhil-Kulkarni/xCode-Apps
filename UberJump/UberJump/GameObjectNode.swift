//
//  GameObjectNode.swift
//  UberJump
//
//  Created by Nikhil Kulkarni on 6/10/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionCategoryBitmask {
    static let Player:UInt32 = 0x00
    static let Star:UInt32 = 0x01
    static let Platform:UInt32 = 0x02
}

enum StarType:Int {
    case Normal = 0
    case Special
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}

class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
    
}
