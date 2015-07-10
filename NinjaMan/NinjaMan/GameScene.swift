//
//  GameScene.swift
//  NinjaMan
//
//  Created by Nikhil Kulkarni on 6/9/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var movingGround: NKMovingGround!
    var hero: NKHero!
    
    var isStarted = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 159/255.0, green: 201/255.0, blue: 244/255.0, alpha: 1)
        
        movingGround = NKMovingGround(size: CGSize(width: view.frame.width, height: NKGroundHeight))
        movingGround.position = CGPointMake(0, self.frame.height / 2)
        addChild(movingGround)
        
        hero = NKHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.height / 2 + hero.frame.size.height / 2)
        addChild(hero)
        hero.breathe()

    }
    
    func start() {
        isStarted = true
        hero.stop()
        hero.startRunning()
        movingGround.start()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if !isStarted {
            start()
        } else {
            hero.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
