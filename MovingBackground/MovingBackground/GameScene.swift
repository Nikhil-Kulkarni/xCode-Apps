//
//  GameScene.swift
//  MovingBackground
//
//  Created by Nikhil Kulkarni on 6/19/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

let backgroundImage: SKSpriteNode = SKSpriteNode(imageNamed: "backgroundNew.png")
let backgroundImage2: SKSpriteNode = SKSpriteNode(imageNamed: "backgroundNew.png")
let airplane:SKSpriteNode = SKSpriteNode(imageNamed: "Spaceship.png")
let logo:SKSpriteNode = SKSpriteNode(imageNamed: "USA-Soccer.png")
var currentFrame: CDouble = 0.0


var xVar: CGFloat = -2

let collisionPlayer: UInt32 = 1<<1
let collisionEnemy: UInt32 = 1<<2

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var bullet = SKNode()
        var circle: SKShapeNode = SKShapeNode(circleOfRadius: 5)
        
        backgroundImage.size = CGSize(width: 568, height: 320)
        backgroundImage.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundImage.position = CGPoint(x: 0, y: 0)
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        backgroundImage2.size = CGSize(width: 568, height: 320)
        backgroundImage2.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundImage2.position = CGPoint(x: 568, y: 0)
        backgroundImage2.zPosition = 0
        self.addChild(backgroundImage2)
        
        airplane.size = CGSize(width: 28, height: 32)
        airplane.anchorPoint = CGPoint(x: 0, y: 0)
        airplane.position = CGPoint(x: 100, y: self.view.frame.height/2)
        airplane.zRotation = CGFloat(3*M_PI/2)
        airplane.zPosition = 1
        //airplane.physicsBody.categoryBitMask = collisionPlayer
        
        self.addChild(airplane)
        
        circle.fillColor = UIColor.blueColor()
        circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        circle.zPosition = 1
        self.addChild(circle)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touchbegins */
        
        var touch: UITouch = touches.anyObject() as UITouch
        var location:CGPoint = touch.locationInNode(self)
        moveAirplane(location)
        
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        var touch: UITouch = touches.anyObject() as UITouch
        var location:CGPoint = touch.locationInNode(self)
        var move: SKAction = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 0.1)
        airplane.runAction(move)
        
    }
    
    func moveAirplane(location: CGPoint) {
        
        var movePlane:SKAction = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 0.3)
        
        airplane.runAction(movePlane)
    
    }
    
    func moveBackground() {
        
        
        backgroundImage.position = CGPoint(x: backgroundImage.position.x + xVar, y: 0)
        backgroundImage2.position = CGPoint(x: backgroundImage2.position.x + xVar, y: 0)
        
        if(backgroundImage.position.x < -567) {
            backgroundImage.position.x = 568
        }
        if(backgroundImage2.position.x < -567) {
            backgroundImage2.position.x = 568
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        moveBackground()
        
    }
}