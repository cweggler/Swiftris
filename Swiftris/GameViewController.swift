//
//  GameViewController.swift
//  Swiftris
//
//  Created by Cara on 4/12/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

/**
    The GameViewController class will be responsible for
    handling user input and handling interactions between
    the GameScene and GameLogic classes
 */
class GameViewController: UIViewController, GameLogicDelegate, UIGestureRecognizerDelegate {
    var scene: GameScene!
    var swiftris: GameLogic!
    var panPointReference: CGPoint?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
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
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        
        let currentPoint = sender.translation(in: self.view)
        
        if let originalPoint = panPointReference {
            
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
              }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        
        swiftris.dropShape()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UISwipeGestureRecognizer {
            
            if otherGestureRecognizer is UIPanGestureRecognizer {
                    return true
            }
            
        } else if gestureRecognizer is UIPanGestureRecognizer {
            
            if otherGestureRecognizer is UITapGestureRecognizer {
                    return true
            }
        }
        
        return false
    }
    
    func didTick() {
        swiftris.letShapeFall()
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
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
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
        scene.playSound(sound: "gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
                swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(swiftris: GameLogic) {
        levelLabel.text = "\(swiftris.level)"
        
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        
        scene.playSound(sound: "levelup.mp3")
    }
    
    func gameShapeDidDrop(swiftris: GameLogic) {
        
        scene.stopTicking()
        scene.redrawShape(shape: swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        
        scene.playSound(sound: "drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: GameLogic) {
        
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks) {
                
                self.gameShapeDidLand(swiftris: swiftris)
            }
            scene.playSound(sound: "bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(swiftris: GameLogic) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
}
