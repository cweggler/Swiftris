//
//  GameScene.swift
//  Swiftris
//
//  Created by Cara on 4/12/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import SpriteKit

let BlockSize:CGFloat = 20.0                //
let TickLengthLevelOne = TimeInterval(600)

/**
    The GameScene class is responsible for displaying everything
    in the Swiftris app. It renders the Tetrominos, background and
    gameboard
*/

class GameScene: SKScene {
    
    let gameLayer = SKNode()  // creates a baseline to draw game designs
    let shapeLayer = SKNode() // creates a baseline to draw the shapes on
    let LayerPosition = CGPoint(x: 6, y: -6) // creates the point to show
                                             // the extent of other SKNode()
    
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()
    
    /**
        This part initializes the GameScene object
        The 'required' part means this init must be implemented by every subclass of this class
        The fatalError part is the message that should show if
        initializing fails
    */
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        anchorPoint = CGPoint(x: 0, y: 1.0) // anchor pt is now in top
                                            // left corner of the screen
        
        // Set the background as a SKNode from SpriteKit and make
        // the background image in Assets show up
        let background = SKSpriteNode(imageNamed: "background")
        
        // centers the background at middle, far left 0,0
        background.position = CGPoint(x: 0, y: 0)
        
        // makes the anchorpoint for image to be upper left corner
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        // Adds background as a node
        addChild(background)
        
        // Adds gameLayer as a node
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard2")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(NumColumns), height: BlockSize * CGFloat(NumRows)))
        
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
        
        run(SKAction.repeatForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)))
    }
    
    func playSound(sound: String){
        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    /**
     By default, the update function won't do anything. The scene subclasses should override this method and perform any necessary updates to the scene.
     */
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard let lastTick = lastTick else {
            return
        }
        
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        
        if timePassed > tickLengthMillis{
            self.lastTick = NSDate()
            tick?()
        }
    }
    
    /**
     This function does...
     
     */
    
    func startTicking(){
        lastTick = NSDate()
    }
    
    /**
     This function does...
     
     */
    
    func stopTicking(){
        lastTick = nil
    }
    /**
      pointforColumn returns the precise coordinates on a screen
     where the block belongs based on its column and row position
     
     Parameters:
     - column: The column position of the block
     - row: The row position of the block
     
     Returns: The center point of the block
    */
    
    func pointforColumn(column: Int, row: Int) -> CGPoint {
        let x = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPoint(x: x, y: y)
    }
    
    /**
        addPreviewShapeToScene adds a shape to the scene as a preview shape
     
     Parameters:
     - shape: one of the seven Swiftris shapes
     - completion: a Swift closure
    */
    
    func addPreviewShapeToScene(shape: Shape, completion:@escaping () -> ()){
        for block in shape.blocks {
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            
            let sprite = SKSpriteNode(texture: texture)
            
            sprite.position = pointforColumn(column: block.column, row: block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            
            let moveAction = SKAction.move(to: pointforColumn(column: block.column, row: block.row), duration: TimeInterval(0.2))
            
            moveAction.timingMode = .easeOut
            
            let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.4)
            fadeInAction.timingMode = .easeOut
            
            sprite.run(SKAction.group([moveAction, fadeInAction]))
        }
        
        run(SKAction.wait(forDuration: 0.4), completion: completion)
    }
    
    /**
        movePreviewShape does...
    */
    
    func movePreviewShape(shape: Shape, completion: @escaping () -> ()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointforColumn(column: block.column, row: block.row)
            let moveToAction: SKAction = SKAction.move(to: moveTo, duration: 0.2)
            moveToAction.timingMode = .easeOut
            sprite.run(SKAction.group([moveToAction, SKAction.fadeAlpha(to: 1.0, duration: 0.1)]), completion: {})
        }
        run(SKAction.wait(forDuration: 0.2), completion: completion)
    }
    
    /**
        redrawShape moves and redraws each block of a given shape
     
    Parameters:
     - shape: one of the seven shapes in Swiftris
     - completion: an escaping closure
    */
    
    func redrawShape(shape: Shape, completion: @escaping () -> ()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointforColumn(column: block.column, row: block.row)
            let moveToAction: SKAction = SKAction.move(to: moveTo, duration: 0.6)
            moveToAction.timingMode = .easeOut
            
            if block == shape.blocks.last {
                sprite.run(moveToAction, completion: completion)
            } else {
                sprite.run(moveToAction)
            }
        }
    }
    
    func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion: @escaping () -> ()) {
        
        var longestDuration: TimeInterval = 0
        
        for (columnIdx, column) in fallenBlocks.enumerated() {
            
            for (blockIdx, block) in column.enumerated() {
                let newPosition = pointforColumn(column: block.column, row: block.row)
                let sprite = block.sprite!
                let delay = (TimeInterval(columnIdx) * 0.05) + (TimeInterval(blockIdx) * 0.05)
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        moveAction]))
                longestDuration = max(longestDuration, duration + delay)
            }
        }
        
        for rowToRemove in linesToRemove {
            
            for block in rowToRemove {
                
                let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = pointforColumn(column: block.column, row: block.row)
                point = CGPoint(x: point.x + (goLeft ? -randomRadius : randomRadius), y: point.y)
                
                let randomDuration = TimeInterval(arc4random_uniform(2)) + 0.5
                
                var startAngle = CGFloat(Double.pi)
                var endAngle = startAngle * 2
                if goLeft {
                    
                    endAngle = startAngle
                    startAngle = 0
                }
                
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                
                let archAction = SKAction.follow(archPath.cgPath, asOffset: false, orientToPath: true, duration: randomDuration)
                
                archAction.timingMode = .easeIn
                let sprite = block.sprite!
                
                sprite.zPosition = 100
                sprite.run(
                    SKAction.sequence(
                        [SKAction.group([archAction,
                            SKAction.fadeOut(withDuration: TimeInterval(randomDuration))]),
                                SKAction.removeFromParent()]))
            }
        }
        
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
}


