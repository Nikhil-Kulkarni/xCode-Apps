//
//  Ground.swift
//  LineJumper
//
//  Created by Nikhil Kulkarni on 6/13/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import Foundation
import SpriteKit

let NUMBER_OF_SEGMENTS = 6

class Ground: SKSpriteNode {
    
    let heightOfBlock = 20
    
    let COLOR_ONE = UIColor.flat(FlatColors.Turquoise)
    let COLOR_TWO = UIColor.flat(FlatColors.PeterRiver)
    let COLOR_THREE = UIColor.flat(FlatColors.AliceBlue)
    let COLOR_FOUR = UIColor.flat(FlatColors.SunFlower)
    let COLOR_FIVE = UIColor.flat(FlatColors.RadicalRed)
    let COLOR_SIX = UIColor.flat(FlatColors.Ming)

    init(size:CGSize) {
        super.init(texture: nil, color: UIColor.brownColor(), size: CGSizeMake(size.width, size.height))
        var segmentColor: UIColor!
        for var i = 0; i < NUMBER_OF_SEGMENTS; i++ {
            if i % 6 == 0 {
                segmentColor = COLOR_ONE
            }
            else if i % 6 == 1 {
                segmentColor = COLOR_TWO
            }
            else if i % 6 == 2 {
                segmentColor = COLOR_THREE
            }
            else if i % 6 == 3 {
                segmentColor = COLOR_FOUR
            }
            else if i % 6 == 4 {
                segmentColor = COLOR_FIVE
            }
            else  {
                segmentColor = COLOR_SIX
            }
            
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(self.size.width / CGFloat(NUMBER_OF_SEGMENTS), CGFloat(heightOfBlock)))
            segment.anchorPoint = CGPoint(x: 0, y: 0.5)
            segment.position = CGPoint(x: CGFloat(i) * segment.size.width, y: 0)
            addChild(segment)
        }
    }
    
    func start() {
        let moveLeft = SKAction.moveByX(-frame.size.width / 2, y: 0, duration: 1.0)
        let reset = SKAction.moveToX(0.0, duration: 0.0)
        
        let action = SKAction.sequence([moveLeft, reset])
        runAction(SKAction.repeatActionForever(action))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
