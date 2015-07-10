//
//  NKBall.swift
//  Ball Jump
//
//  Created by Nikhil Kulkarni on 6/14/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

class NKBall:SKSpriteNode {
    
    var nodeColor: UIColor!
    var ball:SKShapeNode!
    
    init(size:CGSize, bColor:UIColor) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        ball = SKShapeNode(circleOfRadius: 10.0)
        ball.fillColor = bColor
        ball.strokeColor = bColor
        nodeColor = bColor
        addChild(ball)
    }
    
    func getBallColor() -> UIColor {
        return nodeColor
    }
    
    func setBallColor(bColor:UIColor) {
        ball.fillColor = bColor
        ball.strokeColor = bColor
        nodeColor = bColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
