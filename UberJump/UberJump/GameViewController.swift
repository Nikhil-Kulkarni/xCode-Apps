//
//  GameViewController.swift
//  UberJump
//
//  Created by Nikhil Kulkarni on 6/9/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skview = self.view as! SKView
        
        skview.showsFPS = true
        skview.showsNodeCount = true
        
        let scene = GameScene(size: skview.bounds.size)
        scene.scaleMode = .AspectFill
        
        skview.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .AllButUpsideDown
//        } else {
//            return .All
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
