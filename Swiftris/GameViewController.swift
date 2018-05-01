//
//  GameViewController.swift
//  Swiftris
//
//  Created by Cara on 4/12/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameLogicDelegate, UIGestureRecognizerDelegate {
    var scene: GameScene!
    var swiftris: GameLogic!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        swiftris = GameLogic()
        swiftris.delegate = self
        swiftris.beginGame()
        
        
        // Present the scene.
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    func didTick() {
        swiftris.letShapeFall()
        scene.redrawShape(shape: swiftris.fallingShape!, completion: {})
    }
    
    func nextShape() {
        
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!, completion: {})
        
        self.scene.movePreviewShape(shape: fallingShape) {
            
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: GameLogic) {
        
        // the following is false when restarting a new game
        
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: GameLogic) {
        
        view.isUserInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: GameLogic) {
        
    }
    
    func gameShapeDidDrop(swiftris: GameLogic) {
        
    }
    
    func gameShapeDidLand(swiftris: GameLogic) {
        
        scene.stopTicking()
        nextShape()
    }
    
    func gameShapeDidMove(swiftris: GameLogic) {
        scene.redrawShape(shape: swiftris.fallingShape!, completion: {})
    }
}
