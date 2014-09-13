//
//  GameScene.swift
//  Orbivoid
//
//  Created by Nikhil Kulkarni on 6/24/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            let pi: CGFloat = 3.14
            
            
            let rotate = SKAction.rotateByAngle(pi, duration: 0.5)
            let move = SKAction.moveTo(CGPoint(x: location.x-100, y: location.y-100), duration: 0.5)
            let wait = SKAction.waitForDuration(0.5)
            let remove = SKAction.removeFromParent()
            sprite.runAction(SKAction.sequence([rotate, move, wait, remove]))
            self.addChild(sprite)
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
