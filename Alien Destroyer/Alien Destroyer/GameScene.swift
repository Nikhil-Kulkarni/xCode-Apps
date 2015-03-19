//
//  GameScene.swift
//  Alien Destroyer
//
//  Created by Nikhil Kulkarni on 8/7/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval: NSTimeInterval = NSTimeInterval()
    var lastUpdateTimeInterval: NSTimeInterval = NSTimeInterval()
    var aliensDestroyed:Int = 0
    
    let alienCategory: UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    
    
    override init(size: CGSize) {
        
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPoint(x: self.frame.width/2, y: player.size.height/2 + 20)
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAlien() {
        
        var alien = SKSpriteNode(imageNamed: "alien.png")
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangeX = maxX - minX
        
        let position = CGFloat(Int(arc4random_uniform(UInt32(UInt(rangeX))))) + minX
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        self.addChild(alien)
        
        let minDuration = 2
        let maxDuration = 4
        let range = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(range) + Int(minDuration)
        
        var actionArray: NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPoint(x: position, y: -alien.size.height), duration: NSTimeInterval(duration)))
        
        actionArray.addObject(SKAction.removeFromParent())
        alien.runAction(SKAction.sequence(actionArray))
        
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        
        lastYieldTimeInterval += timeSinceLastUpdate
        if(lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            addAlien()
        }
        
    }
    
    override func didMoveToView(view: SKView) {
        
        
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)  {
        
        self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        var touch: UITouch = touches.anyObject() as UITouch
        var location: CGPoint = touch.locationInNode(self)
        
        var torpedo: SKSpriteNode = SKSpriteNode(imageNamed: "torpedo");
        torpedo.position = player.position
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width/2)
        torpedo.physicsBody?.dynamic = true
        torpedo.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedo.physicsBody?.contactTestBitMask = alienCategory
        torpedo.physicsBody?.collisionBitMask = 0
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        var offset:CGPoint = vecSub(location, torpedo.position)
        if(offset.y < 0) {
            return
        }
        
        self.addChild(torpedo)
        
        var direction:CGPoint = vecNormalize(offset)
        var shotLength:CGPoint = vecMult(direction, 1000)
        var finalDestination: CGPoint = vecAdd(shotLength, torpedo.position)
        print(finalDestination)
        
        let velocity = 568/1
        let moveDuration: Float = Float(Float(self.size.width) / Float(velocity))
        
        var actionArray: NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(finalDestination, duration: NSTimeInterval(moveDuration)))
        actionArray.addObject(SKAction.removeFromParent())
        
        torpedo.runAction(SKAction.sequence(actionArray))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if(timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
}

func vecAdd(a: CGPoint, b:CGPoint) -> CGPoint {
    
    return CGPoint(x: a.x + b.x, y: a.y + b.y)
    
}

func vecSub(a:CGPoint, b:CGPoint) -> CGPoint {
    
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
    
}

func vecMult(a:CGPoint, b:CGFloat) -> CGPoint {
    
    return CGPoint(x: a.x * b, y: a.y * b)
    
}

func vecLength(a:CGPoint) -> CGFloat {
    
    return (sqrt(a.x) * sqrt(a.x)) + (sqrt(a.y) + sqrt(a.y))
    
}

func vecNormalize(a:CGPoint) -> CGPoint {
    
    var length = vecLength(a)
    return CGPoint(x: a.x/length, y: a.y/length)
    
}




