//
//  Breakout.swift
//  Games
//
//  Created by period2 on 4/27/21.
//

import UIKit
import AVFoundation

class Breakout: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var paddle: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var brickOne: UIView!
    @IBOutlet weak var brickTwo: UIView!
    @IBOutlet weak var brickThree: UIView!
    @IBOutlet weak var brickFour: UIView!
    @IBOutlet weak var brickFive: UIView!
    @IBOutlet weak var brickSix: UIView!
    @IBOutlet weak var brickSeven: UIView!
    @IBOutlet weak var brickEight: UIView!
    @IBOutlet weak var brickNine: UIView!
    @IBOutlet weak var leftBoundary: UIView!
    @IBOutlet weak var rightBoundary: UIView!
    var bricks = [UIView]()
    var dynamicAnimator: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    var collisionBehavior: UICollisionBehavior!
    var ballDynamicItem: UIDynamicItemBehavior!
    var paddleDynamicItem: UIDynamicItemBehavior!
    var brickDynamicBehavior: UIDynamicItemBehavior!
    var boundaryDynamicBehavior: UIDynamicItemBehavior!
    var brickCount = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ballView.layer.cornerRadius = 10
        bricks = [brickOne, brickTwo, brickThree, brickFour, brickFive, brickSix, brickSeven, brickEight, brickNine]
        paddle.isHidden = true
        ballView.isHidden = true
        brickOne.isHidden = true
        brickTwo.isHidden = true
        brickThree.isHidden = true
        brickFour.isHidden = true
        brickFive.isHidden = true
        brickSix.isHidden = true
        brickSeven.isHidden = true
        brickEight.isHidden = true
        brickNine.isHidden = true
        startButton.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func movingPaddle(_ sender: UIPanGestureRecognizer) {
        paddle.center = CGPoint(x: sender.location(in: view).x, y: paddle.center.y)
        dynamicAnimator.updateItem(usingCurrentState: paddle)
    }
    
    func dynamicBehaviors() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        pushBehavior = UIPushBehavior(items: [ballView], mode: .instantaneous)
        collisionBehavior = UICollisionBehavior(items: [ballView, paddle, leftBoundary, rightBoundary] + bricks)
        
        pushBehavior.active = true
        pushBehavior.setAngle(30, magnitude: 0.2)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .everything
        collisionBehavior.collisionDelegate = self
        
        ballDynamicItem = UIDynamicItemBehavior(items: [ballView])
        ballDynamicItem.allowsRotation = true
        ballDynamicItem.elasticity = 1
        ballDynamicItem.friction = 0
        ballDynamicItem.resistance = -0.1
        
        paddleDynamicItem = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicItem.density = 1000
        paddleDynamicItem.allowsRotation = false
        paddleDynamicItem.elasticity = 1
        
        boundaryDynamicBehavior = UIDynamicItemBehavior(items: [rightBoundary, leftBoundary])
        boundaryDynamicBehavior.density = 10000000
        boundaryDynamicBehavior.allowsRotation = false
        boundaryDynamicBehavior.elasticity = 1
        
        brickDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        brickDynamicBehavior.density = 1000
        brickDynamicBehavior.allowsRotation = false
        brickDynamicBehavior.elasticity = 1
        
        
        
        dynamicAnimator.addBehavior(pushBehavior)
        dynamicAnimator.addBehavior(collisionBehavior)
        dynamicAnimator.addBehavior(ballDynamicItem)
        dynamicAnimator.addBehavior(paddleDynamicItem)
        dynamicAnimator.addBehavior(brickDynamicBehavior)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        for brick in bricks {
            if item1.isEqual(ballView) && item2.isEqual(brick) {
                if brick.backgroundColor == .blue {
                    brick.isHidden = true
                    collisionBehavior.removeItem(brick)
                    brickCount -= 1
                } else {
                    brick.backgroundColor = .blue
                }
            }
        }
        if brickCount == 0 {
            alert()
            ballView.isHidden = true
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if ballView.center.y > paddle.center.y + 20 {
            alert()
        }
    }
    
    func alert() {
        let gameOver = UIAlertController(title: "GG!", message: "", preferredStyle: .alert)
        let newGame = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.reset()
            self.ballView.isHidden = false
        }
        gameOver.addAction(newGame)
        present(gameOver, animated: true, completion: nil)
    }
    
    func reset() {
        ballView.isHidden = false
        brickOne.isHidden = false
        brickTwo.isHidden = false
        brickThree.isHidden = false
        brickFour.isHidden = false
        brickFive.isHidden = false
        brickSix.isHidden = false
        brickSeven.isHidden = false
        brickEight.isHidden = false
        brickNine.isHidden = false
        ballView.center.x = 200
        ballView.center.y = 438
        paddle.center.x = 200
        paddle.center.y = 720
        brickCount = 9
        dynamicBehaviors()
    }
    
    
    @IBAction func startButton(_ sender: UIButton) {
        startButton.isHidden = true
        paddle.isHidden = false
        ballView.isHidden = false
        brickOne.isHidden = false
        brickTwo.isHidden = false
        brickThree.isHidden = false
        brickFour.isHidden = false
        brickFive.isHidden = false
        brickSix.isHidden = false
        brickSeven.isHidden = false
        brickEight.isHidden = false
        brickNine.isHidden = false
        let synth = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Gameday")
        synth.speak(utterance)
        dynamicBehaviors()
    }
    @IBAction func resetButton(_ sender: UIButton) {
        reset()
    }
    
}
