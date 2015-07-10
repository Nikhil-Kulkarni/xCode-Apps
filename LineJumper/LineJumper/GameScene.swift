//
//  GameScene.swift
//  LineJumper
//
//  Created by Nikhil Kulkarni on 6/13/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

var sizeOfScreen:CGRect!

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var started = false
    
    let blockBitmask:UInt32 = 0x00
    let groundBitmask:UInt32 = 0x01
    
    var block:Player!
    var ground:Ground!
    
    var startLabel:SKLabelNode!
    var title:SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        sizeOfScreen = self.view?.frame
        
        self.backgroundColor = UIColor(red: 113/255.0, green: 197/255.0, blue: 218/255.0, alpha: 1.0)
        
        /* Setup your scene here */
        ground = Ground(size: CGSizeMake((self.view?.frame.width)!, CGFloat(20)))
        ground.position = CGPoint(x: 0, y: (self.view?.frame.height)! / 2 - 100)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = groundBitmask
//        ground.physicsBody?.collisionBitMask = 0
        
        addChild(ground)
        
        block = Player(size: CGSizeMake(20, 20))
        block.position = CGPoint(x: (self.view?.frame.width)! / CGFloat(NUMBER_OF_SEGMENTS) / 2, y: ground.position.y + ground.size.height + 150)
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
        block.physicsBody?.dynamic = true
        block.physicsBody?.categoryBitMask = blockBitmask
        block.physicsBody?.collisionBitMask = groundBitmask
        block.physicsBody?.contactTestBitMask = groundBitmask
        block.physicsBody?.restitution = 1.0
        block.physicsBody?.friction = 0.0
        block.physicsBody?.angularDamping = 0.0
        block.physicsBody?.linearDamping = 0.0
        block.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(block)
        
        startLabel = SKLabelNode(text: "Tap to start")
        startLabel.fontSize = CGFloat(25)
        startLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: (self.view?.frame.height)! / 2)
        addChild(startLabel)
        
        title = SKLabelNode(text: "LineJumper")
        title.fontSize = CGFloat(40)
        title.position = CGPoint(x: (self.view?.frame.width)! / 2, y: startLabel.position.y + 50)
        addChild(title)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let player = (contact.bodyA.node == block) ? contact.bodyA.node : contact.bodyB.node as! SKSpriteNode
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if !started {
            title.removeFromParent()
            startLabel.removeFromParent()
            started = true
        } else {
            block.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 5.5))
            block.moveOver()
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
