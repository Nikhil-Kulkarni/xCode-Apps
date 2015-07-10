//
//  NKGroundOne.swift
//  Ball Jump
//
//  Created by Nikhil Kulkarni on 6/14/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class NKGroundOne:SKSpriteNode {
    
    var groundColor:UIColor!
    
    init(size:CGSize, groundColor:UIColor) {
        super.init(texture: nil, color: groundColor, size: CGSize(width: size.width, height: size.height))
        
        let ground = SKSpriteNode(color: groundColor, size: CGSize(width: size.width, height: size.height))
        ground.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.groundColor = ground.color
        addChild(ground)
        
    }
    
    func collidedWithGround(player: SKNode) {
        player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: 20.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
