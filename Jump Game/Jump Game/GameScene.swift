//
//  GameScene.swift
//  Jump Game
//
//  Created by Nikhil Kulkarni on 7/8/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton: SKSpriteNode = SKSpriteNode(imageNamed: "playButton.png")
    
    override func didMoveToView(view: SKView) {
        
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(playButton)
        self.backgroundColor = UIColor.blueColor()
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == playButton {
                println("go to game")
                var scene = playScene(size: self.size)
                let sKView = self.view as SKView
                sKView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = sKView.bounds.size
                sKView.presentScene(scene)
                
            }
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
