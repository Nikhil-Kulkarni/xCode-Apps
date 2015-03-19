//
//  GameViewController.swift
//  Alien Destroyer
//
//  Created by Nikhil Kulkarni on 8/7/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

//extension SKNode {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        
//        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
//        
//        //var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
//        //var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//        
////        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
////        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
////        archiver.finishDecoding()
////        return scene
//    }
//}

class GameViewController: UIViewController {
    
    var backgroundMusicPlayer: AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillLayoutSubviews()  {
        
        var bgMusicURL: NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        var skView = self.view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        
        var scene: SKScene = GameScene(size: skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.Fill
        skView.presentScene(scene)
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
        
    }
}
