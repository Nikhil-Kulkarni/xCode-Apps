//
//  Tile.swift
//  Game of Life
//
//  Created by Nikhil Kulkarni on 6/18/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {

    var isAlive:Bool = false {
    didSet{
        self.hidden = !isAlive
    }
    }
    var numLivingNeighbors = 0
    
}
