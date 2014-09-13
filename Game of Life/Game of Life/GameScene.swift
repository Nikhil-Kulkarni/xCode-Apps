//
//  GameScene.swift
//  Game of Life
//
//  Created by Nikhil Kulkarni on 6/18/14.
//  Copyright (c) 2014 Nikhil Kulkarni. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gridWidth = 400
    let gridHeight = 300
    let numRows = 8
    let numCols = 10
    let gridLowerLeftCorner:CGPoint = CGPoint(x: 158, y: 10)
    
    let populationLabel = SKLabelNode(text: "Population")
    let generationLabel = SKLabelNode(text: "Generation")
    var populationValueLabel = SKLabelNode(text: "0")
    var generationValueLabel = SKLabelNode(text: "0")
    var playButton = SKSpriteNode(imageNamed: "play.png")
    var pauseButton = SKSpriteNode(imageNamed: "pause.png")
    
    var tiles:Tile[][] = []
    var margin = 4
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
        
        let gridBackground = SKSpriteNode(imageNamed: "grid.png")
        gridBackground.anchorPoint = CGPoint(x: 0, y: 0)
        gridBackground.size = CGSize(width: gridWidth, height: gridHeight)
        gridBackground.zPosition = -1
        gridBackground.position = gridLowerLeftCorner
        self.addChild(gridBackground)
        
        playButton.position = CGPoint(x: 79, y: 290)
        playButton.setScale(0.5)
        self.addChild(playButton)
        pauseButton.position = CGPoint(x: 79, y: 250)
        pauseButton.setScale(0.5)
        self.addChild(pauseButton)
        
        let balloon = SKSpriteNode(imageNamed: "balloon.png")
        balloon.position = CGPoint(x: 79, y: 170)
        balloon.setScale(0.5)
        self.addChild(balloon)
        
        let microscope = SKSpriteNode(imageNamed: "microscope.png")
        microscope.position = CGPoint(x: 79, y: 70)
        microscope.setScale(0.4)
        self.addChild(microscope)
        
        populationLabel.position = CGPoint(x: 79, y: 190)
        populationLabel.fontName = "Courier"
        populationLabel.fontSize = 12
        populationLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(populationLabel)
        
        generationLabel.position = CGPoint(x: 79, y: 160)
        generationLabel.fontName = "Courier"
        generationLabel.fontSize = 12
        generationLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(generationLabel)
        
        populationValueLabel.position = CGPoint(x: 79, y: 175)
        populationValueLabel.fontName = "Courier"
        populationValueLabel.fontSize = 12
        populationValueLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(populationValueLabel)
        
        generationValueLabel.position = CGPoint(x: 79, y: 145)
        generationValueLabel.fontName = "Courier"
        generationValueLabel.fontSize = 12
        generationValueLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(generationValueLabel)
        
        let tileSize = calculateTileSize()
        for r in 0..numRows {
            var tileRow:Tile[] = []
            for c in 0..numCols {
                let tile = Tile(imageNamed: "bubble.png")
                tile.isAlive = false
                tile.size = CGSize(width: tileSize.width, height: tileSize.height)
                tile.anchorPoint = CGPoint(x: 0, y: 0)
                tile.position = getTilePosition(row: r, column: c)
                self.addChild(tile)
                tileRow.append(tile)
            }
            
            tiles.append(tileRow)
        }
        
    }
    
    func calculateTileSize() -> CGSize {
        
        let tileWidth = gridWidth / numCols - margin
        let tileHeight = gridHeight / numRows - margin
        return CGSize(width: tileWidth, height: tileHeight)
        
    }
    
    func getTilePosition(row r:Int, column c:Int) -> CGPoint {
        
        let tileSize = calculateTileSize()
        let x = Int(gridLowerLeftCorner.x) + margin + (c * (Int(tileSize.width) + margin))
        let y = Int(gridLowerLeftCorner.y) + margin + (r * (Int(tileSize.height) + margin))
        return CGPoint(x: x, y: y)
        
        
    }
    
    func isValidTile(row r: Int, column c:Int) -> Bool {
        
        return r>=0 && r < numRows && c >= 0 && c < numCols
        
    }
    
    func getTileAtPosition(xPos x: Int, yPos y: Int) -> Tile? {
        let r:Int = Int( CGFloat(y - (Int(gridLowerLeftCorner.y) + margin)) / CGFloat(gridHeight) * CGFloat(numRows))
        let c:Int = Int( CGFloat(x - (Int(gridLowerLeftCorner.x) + margin)) / CGFloat(gridWidth) * CGFloat(numCols))
        if isValidTile(row: r, column: c) {
            return tiles[r][c]
        } else {
            return nil
        }
    }
    
    

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            var selectedTile:Tile? = getTileAtPosition(xPos: Int(touch.locationInNode(self).x), yPos: Int(touch.locationInNode(self).y))
            if let tile = selectedTile {
                tile.isAlive = !tile.isAlive
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
