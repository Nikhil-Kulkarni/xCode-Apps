//
//  GameScene.swift
//  UberJump
//
//  Created by Nikhil Kulkarni on 6/9/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Layered Nodes
    var backgroundNode: SKNode!
    var midgroundNode: SKNode!
    var foregroundNode: SKNode!
    var hudNode: SKNode!
    
    var player:SKNode!
    
    // Height at which the level ends
    var endLevelY = 0
    
    let tapToStart = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/TapToStart")
    
    // To Accommodate iPhone 6
    var scaleFactor: CGFloat!
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0.0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.whiteColor()
        
        physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        
        scaleFactor = self.size.width / 320.0
        backgroundNode = createBackground()
        addChild(backgroundNode)
        
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        endLevelY = levelData["EndY"]!.integerValue!
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions {
            let patternX = platformPosition["x"]?.floatValue
            let patternY = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as! String
            
            // Look up the pattern
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let x = platformPoint["x"]?.floatValue
                let y = platformPoint["y"]?.floatValue
                let type = PlatformType(rawValue: platformPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = createPlatformAtPosition(CGPoint(x: positionX, y: positionY), type: type!)
                foregroundNode.addChild(platformNode)
            }
        }
        
        // Add the stars
        let stars = levelData["Stars"] as! NSDictionary
        let starPatterns = stars["Patterns"] as! NSDictionary
        let starPositions = stars["Positions"] as! [NSDictionary]
        
        for starPosition in starPositions {
            let patternX = starPosition["x"]?.floatValue
            let patternY = starPosition["y"]?.floatValue
            let pattern = starPosition["pattern"] as! NSString
            
            // Look up the pattern
            let starPattern = starPatterns[pattern] as! [NSDictionary]
            for starPoint in starPattern {
                let x = starPoint["x"]?.floatValue
                let y = starPoint["y"]?.floatValue
                let type = StarType(rawValue: starPoint["type"]!.integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let starNode = createStarAtPosition(CGPoint(x: positionX, y: positionY), type: type!)
                foregroundNode.addChild(starNode)
            }
        }
        
        player = createPlayer()
        foregroundNode.addChild(player)
        
        hudNode = SKNode()
        addChild(hudNode)
        
        tapToStart.position = CGPointMake(self.size.width / 2, 180.0)
        hudNode.addChild(tapToStart)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
            (accelerometerData: CMAccelerometerData!, error: NSError!) in
            // 3
            let acceleration = accelerometerData.acceleration
            // 4
            self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
        })
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 600.0, dy: player.physicsBody!.velocity.dy)
        // 2
        // Check x bounds
        if player.position.x < -20.0 {
            player.position = CGPoint(x: self.size.width + 20.0, y: player.position.y)
        } else if (player.position.x > self.size.width + 20.0) {
            player.position = CGPoint(x: -20.0, y: player.position.y)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        if player.physicsBody!.dynamic {
            return
        }
        
        tapToStart.removeFromParent()
        
        player.physicsBody?.dynamic = true

        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 20.0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var updateHUD = false
        
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as! GameObjectNode
        
        updateHUD = other.collisionWithPlayer(player)
        
        if updateHUD {
            
        }
    }
    
    func createPlatformAtPosition(position: CGPoint, type: PlatformType) -> PlatformNode {
        let node = PlatformNode()
        node.position = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.name = "NODE_PLATFORM"
        node.platformType = type
        
        var sprite:SKSpriteNode
        if type == .Break {
            sprite = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/PlatformBreak")
        } else {
            sprite = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/Platform")
        }
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Platform
        node.physicsBody?.dynamic = false
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func createStarAtPosition(position: CGPoint, type: StarType) -> StarNode {
        let node = StarNode()
        let thePosition = CGPoint(x: position.x * scaleFactor, y: position.y)
        node.position = thePosition
        node.name = "NODE_STAR"
        
        node.starType = type
        var sprite: SKSpriteNode
        if type == .Special {
            sprite = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/StarSpecial")
        } else {
            sprite = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/Star")
        }
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody?.dynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Star
        node.physicsBody?.collisionBitMask = 0
        
        return node
        
    }
    
    func createPlayer() -> SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPointMake(self.size.width / 2, 80.0)
        
        let sprite = SKSpriteNode(imageNamed: "UberJumpGraphics/Assets.atlas/Player")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        playerNode.physicsBody?.dynamic = false
        
        playerNode.physicsBody?.allowsRotation = true
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Star | CollisionCategoryBitmask.Platform
        
        return playerNode
    }
    
    func createBackground() -> SKNode {
        let backgroundNode = SKNode()
        let ySpacing = 64.0 * scaleFactor
        
        for index in 0...19 {
            let node = SKSpriteNode(imageNamed:String(format: "UberJumpGraphics/Backgrounds/Background%02d", index + 1))

            node.setScale(scaleFactor)
            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            node.position = CGPoint(x: self.size.width / 2, y: ySpacing * CGFloat(index))

            backgroundNode.addChild(node)
        }
        return backgroundNode
    }
    
    override func update(currentTime: NSTimeInterval) {
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
    }
    
}
