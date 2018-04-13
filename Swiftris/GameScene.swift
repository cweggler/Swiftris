//
//  GameScene.swift
//  Swiftris
//
//  Created by Cara on 4/12/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
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
        
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
    }
    
    
}


