//
//  GameScene.swift
//  Infinity Bounce!
//
//  Created by Nikhil Kulkarni on 6/14/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

let ballBitmask:UInt32 = 0x00
let groundBitmask:UInt32 = 0x01

let NUMBER_SEGMENTS = 6

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball:NKBall!
    var groundOne:NKGroundOne!
    
    var gameOverLabel:SKLabelNode!
    var title:SKLabelNode!
    
    var started = false
    
    let groundColors = [UIColor.flat(FlatColors.SanMarino), UIColor.greenColor(), UIColor.grayColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.flat(FlatColors.Sandstorm)]
    
    var groundArray:NSMutableArray = []
    
    var contactBegan = false
    var gameOver = false
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    var highScoreLabel:SKLabelNode!
    var replayButton:SKSpriteNode!
    var replayTextNode:SKLabelNode!
    
    var startScreenInstruction:SKLabelNode!
    var startScreenIns:SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scoreLabel.fontSize = CGFloat(25)
        scoreLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: (self.view?.frame.height)! / 2)
        scoreLabel.fontName = "Chalkduster"
        
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.flat(FlatColors.PictonBlue);
        
        // Setup the ball
        ball = NKBall(size: CGSizeMake(20, 20), bColor: UIColor.flat(FlatColors.SanMarino))
        ball.position = CGPoint(x: (self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS) / CGFloat(2), y: (self.view?.frame.height)! / 2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.allowsRotation = true
        
        ball.physicsBody?.categoryBitMask = ballBitmask
        ball.physicsBody?.contactTestBitMask = groundBitmask
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.usesPreciseCollisionDetection = true
        addChild(ball)
        
        for var i = 0; i < NUMBER_SEGMENTS; i++ {
            let segment = NKGroundOne(size: CGSize(width: (self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS), height: 20), groundColor: groundColors[i])
            segment.anchorPoint = CGPoint(x: 0, y: 0.5)
            segment.position = CGPoint(x: segment.frame.width * CGFloat(i), y: 20)
            segment.physicsBody = SKPhysicsBody(rectangleOfSize: segment.size)
            segment.physicsBody?.dynamic = false
            segment.physicsBody?.categoryBitMask = groundBitmask
            segment.physicsBody?.contactTestBitMask = 0
            segment.physicsBody?.collisionBitMask = 0
            groundArray.addObject(segment)
            addChild(segment)
        }
        
        // Setup the title screen
        gameOverLabel = SKLabelNode(text: "Tap to start")
        gameOverLabel.fontSize = CGFloat(25)
        gameOverLabel.fontName = "Chalkduster"
        gameOverLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: (self.view?.frame.height)! / 2)
        addChild(gameOverLabel)
        
        title = SKLabelNode(text: "Infinity Bounce!")
        title.fontSize = CGFloat(40)
        title.fontName = "Chalkduster"
        title.position = CGPoint(x: (self.view?.frame.width)! / 2, y: gameOverLabel.position.y + 50)
        addChild(title)
        
        startScreenInstruction = SKLabelNode(text: "Match the ball color with the ground color")
        startScreenInstruction.fontName = "Chalkduster"
        startScreenInstruction.fontSize = CGFloat(10)
        startScreenInstruction.position = CGPoint(x: (self.view?.frame.width)! / 2, y: gameOverLabel.position.y - 50)
        addChild(startScreenInstruction)
        
        startScreenIns = SKLabelNode(text: "Tap on either side of screen to change ball position")
        startScreenIns.fontName = "Chalkduster"
        startScreenIns.fontSize = CGFloat(10)
        startScreenIns.position = CGPoint(x: (self.view?.frame.width)! / 2, y: startScreenInstruction.position.y - 30)
        addChild(startScreenIns)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if !contactBegan && started {
            if ball.position.x >= 0 && ball.position.x <= ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.flat(FlatColors.SanMarino) {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else if ball.position.x >= ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.position.x <=  2 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.greenColor() {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else if ball.position.x >= 2 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.position.x <=  3 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.grayColor() {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else if ball.position.x >= 3 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.position.x <=  4 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.purpleColor() {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else if ball.position.x >= 4 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.position.x <=  5 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.redColor() {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else if ball.position.x >= 5 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.position.x <=  6 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && ball.getBallColor() == UIColor.flat(FlatColors.Sandstorm) {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12.0))
                let randInt = Int(arc4random_uniform(6))
                ball.setBallColor(groundColors[randInt])
                contactBegan = true
                score++
            } else {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.dynamic = false
                contactBegan = true
                gameOver = true
                
                gameOverLabel = SKLabelNode(text: "Game Over")
                gameOverLabel.fontSize = CGFloat(40)
                gameOverLabel.fontName = "ChalkDuster"
                gameOverLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: (self.view?.frame.height)! / 2)
                addChild(gameOverLabel)
                
                let highScore = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
                if score > highScore {
                    NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highScore")
                }
                let key = "highScore"
                highScoreLabel = SKLabelNode(text: "Your Score: \(score)    High Score:\(NSUserDefaults.standardUserDefaults().integerForKey(key))")
                highScoreLabel.fontName = "Chalkduster"
                highScoreLabel.fontSize = 25
                highScoreLabel.position = CGPoint(x: (self.view?.frame.width)! / 2, y: gameOverLabel.position.y + 50)
                addChild(highScoreLabel)
                
                replayButton = SKSpriteNode(color: UIColor.flat(FlatColors.MidnightBlue), size: CGSize(width: 100, height: 30))
                replayButton.position = CGPoint(x: (self.view?.frame.width)! / 2, y: gameOverLabel.position.y - 70)
                replayTextNode = SKLabelNode(text: "Replay")
                replayTextNode.fontName = "Chalkduster"
                replayTextNode.fontSize = CGFloat(15)
                replayTextNode.position = CGPoint(x: 0, y: -5)
                replayTextNode.name = "Replay Text"
                replayButton.name = "Replay"
                replayButton.addChild(replayTextNode)
                
                addChild(replayButton)
                scoreLabel.removeFromParent()
            }
        } else {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 13.0))
        }
        scoreLabel.text = "\(score)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if !started {
            gameOverLabel.removeFromParent()
            title.removeFromParent()
            startScreenInstruction.removeFromParent()
            startScreenIns.removeFromParent()
            started = true
            addChild(scoreLabel)
        } else {
            if !gameOver {
                let touch = touches.first
                let location = touch!.locationInView(self.view)
                if location.x < (self.view?.frame.width)! / CGFloat(2) && ball.position.x >= ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) {
                    let moveOver = SKAction.moveByX(-(self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS), y: 0, duration: 0.2)
                    ball.runAction(moveOver)
                }
                if ball.position.x <= 5 * ((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS)) && location.x >= (self.view?.frame.width)! / CGFloat(2) {
                    let moveOver = SKAction.moveByX((self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS), y: 0, duration: 0.2)
                    ball.runAction(moveOver)
                }
            }
        }
        
        
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location) as SKNode
        
        if node.name == "Replay" || node.name == "Replay Text" {
            self.replayButton.removeFromParent()
            self.gameOverLabel.removeFromParent()
            self.highScoreLabel.removeFromParent()
            ball.position = CGPoint(x: (self.view?.frame.width)! / CGFloat(NUMBER_SEGMENTS) / CGFloat(2), y: (self.view?.frame.height)! / 2)
            ball.physicsBody?.dynamic = true
            gameOver = false
            score = 0
            addChild(scoreLabel)
            ball.setBallColor(UIColor.flat(FlatColors.SanMarino))
        }
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if ball.position.y > (self.view?.frame.height)! / 2 {
            contactBegan = false
        }
    }
}
