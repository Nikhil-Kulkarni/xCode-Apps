//
//  GameScene.swift
//  NimbleNinja
//
//  Created by Nikhil Kulkarni on 5/2/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var movingGround:NKMovingGround!
    var hero: NKHero!
    var cloudGenerator:NKCloudGenerator!
    
    var isStarted = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor(red: 159/255.0, green: 201/255.0, blue: 244/255.0, alpha: 1)
        
        // Add ground
        movingGround = NKMovingGround(size: CGSizeMake(view.frame.width, NKGroundHeight))
        movingGround.position = CGPointMake(0, view.frame.size.height / 2)
        addChild(movingGround)
        
        // Add hero
        hero = NKHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height / 2 + hero.frame.size.height / 2)
        addChild(hero)
        hero.breathe()
        
        // Add cloud
        cloudGenerator = NKCloudGenerator(color: UIColor.clearColor(), size: view.frame.size)
        cloudGenerator.position = view.center
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
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
