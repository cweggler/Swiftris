//
//  GameScene.swift
//  Swiftris
//
//  Created by Cara on 4/12/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import SpriteKit

let BlockSize:CGFloat = 20.0 // explain variables
let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: 0, y: 0)
        
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        addChild(background)
        
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(NumColumns), height: BlockSize * CGFloat(NumRows)))
        
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
        
    }
    
    /**
     This function does...
     
     */
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard let lastTick = lastTick else{
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
        let y = LayerPosition.y + (CGFloat(row) * BlockSize) + (BlockSize / 2)
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
            sprite.run(SKAction.group([moveToAction, SKAction.fadeAlpha(to: 1.0, duration: 0.2)]), completion: {})
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
            let moveToAction: SKAction = SKAction.move(to: moveTo, duration: 0.05)
            moveToAction.timingMode = .easeOut
            
            if block == shape.blocks.last {
                sprite.run(moveToAction, completion: completion)
            } else {
                sprite.run(moveToAction)
            }
        }
    }
}


