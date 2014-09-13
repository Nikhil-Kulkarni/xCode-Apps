//
//  playScene.swift
//  Jump Game
//
//  Created by Nikhil Kulkarni on 7/8/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class playScene: SKScene {
    
    let runningBar = SKSpriteNode(imageNamed: "background.png")
    let hero = SKSpriteNode(imageNamed: "character.png")
    let block1 = SKSpriteNode(imageNamed: "smallBlock.png")
    let block2 = SKSpriteNode(imageNamed: "largeBlock.png")
    var origRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var heroBaseLine = CGFloat(0)
    var onGround = true
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)
    
    override func didMoveToView(view: SKView!)  {
        
        runningBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        runningBar.position = CGPoint(x: CGRectGetMinX(frame), y: CGRectGetMinY(frame) + runningBar.size.height/2)
        addChild(runningBar)
        origRunningBarPositionX = runningBar.position.x
        maxBarX = runningBar.size.width - frame.width
        maxBarX *= -1
        
        heroBaseLine = runningBar.position.y + runningBar.size.height/2 + hero.size.height/2
        hero.position = CGPoint(x: CGRectGetMinX(frame) + hero.size.width/4 + hero.size.width, y: heroBaseLine)
        addChild(hero)
        
        block1.position = CGPoint(x: CGRectGetMaxX(self.frame) + block1.size.width, y: heroBaseLine)
        block2.position = CGPoint(x: CGRectGetMaxX(self.frame) + block2.size.width, y: heroBaseLine + block2.size.height)
        addChild(block1)
        addChild(block2)
        
    }
    
    func random() -> UInt32 {
        var range = UInt32(50)..<UInt32(200)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex+1)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        
        if onGround {
            velocityY = -18.0
            onGround = false
        }
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        
        if velocityY < -9.0 {
            velocityY = -9.0
        }
        
    }
    
    override func update(currentTime: NSTimeInterval)  {
        
        if runningBar.position.x <= maxBarX {
            runningBar.position.x = origRunningBarPositionX
        }
        
        velocityY += gravity
        hero.position.y -= velocityY
        if hero.position.y < heroBaseLine{
            hero.position.y = heroBaseLine
            velocityY = 0.0
            onGround = true
        }
        
        runningBar.position.x -= CGFloat(groundSpeed)
        
        var degreeRotation = CDouble(groundSpeed) * M_PI / 180
        hero.zRotation -= CGFloat(degreeRotation)
        
    }
}
