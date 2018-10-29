//
//  ViewController.swift
//  InteractiveFlip
//
//  Created by Daniel Vebman on 10/28/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import UIKit

// Example implementation:
class ViewController: UIViewController {
    
    var v1 = UIView()
    var v2 = UIImageView()
    
    var animator: InteractiveFlipAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v1.frame.size = CGSize(width: 200, height: 100)
        v1.center = view.center
        v1.backgroundColor = .red
        v1.layer.cornerRadius = 20
        view.addSubview(v1)
        
        v2.frame.size = CGSize(width: 200, height: 100)
        v2.center = view.center
        v2.backgroundColor = .blue
        v2.layer.cornerRadius = 20
        view.addSubview(v2)
        
        // Initialize an animator
        animator = InteractiveFlipAnimator(front: v1, back: v2)
        
        // Add the pan gesture to the view for interactivity
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(pan)
    }
    
    // Forward pan gestures from the view to the animator.
    // This could be better by encapsulating everything in the animator class, but I'm not doing that now.
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        animator.pan(gesture)
    }
}


/// `InteractiveFlipAnimator` allows an interactive flipping animation between two views like a card.
class InteractiveFlipAnimator: NSObject {
    /// The front view
    private var v1: UIView
    /// Cover for the front view that give a darkening effect
    private var v1Cover = UIView()
    
    /// The back view
    private var v2: UIView
    /// Cover for the front view that give a darkening effect
    private var v2Cover = UIView()
    
    /// Indicates state by saving 0 or -pi. Maybe rename this to make it more api-y
    private(set) var startAngle: CGFloat = 0
    
    /// Whether the animator is currently animating the flip.
    private(set) var isAnimating = false
    
    /// Initialize an animator with a front and back view.
    init(front: UIView, back: UIView) {
        v1 = front
        v1.isUserInteractionEnabled = true
        v2 = back
        v2.isUserInteractionEnabled = true
        
        v1Cover = UIView(frame: v1.bounds)
        v1Cover.isUserInteractionEnabled = false
        v1Cover.backgroundColor = .black
        v1Cover.alpha = 0
        v1Cover.layer.cornerRadius = v1.layer.cornerRadius
        v1.addSubview(v1Cover)
        
        v2Cover = UIView(frame: v2.bounds)
        v2Cover.isUserInteractionEnabled = false
        v2Cover.backgroundColor = .black
        v2Cover.alpha = 0
        v2Cover.layer.cornerRadius = v2.layer.cornerRadius
        v2.addSubview(v2Cover)
        
        super.init()
    }
    
    /// Add a `UIPanGestureRecognizer` to the main view that contains the card and pass it onto this function.
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        if isAnimating { return }
        
        let translation = gesture.translation(in: view)
        let x = translation.x
        let angle = startAngle + CGFloat.pi * x / view.frame.width
        
        if angle < -CGFloat.pi || angle > 0 {
            if gesture.state != .began && gesture.state != .changed {
                finishedPanning(angle: angle, velocity: gesture.velocity(in: view))
            }
            return
        }
        
        var transform1 = CATransform3DIdentity
        transform1.m34 = 1 / -500
        transform1 = CATransform3DRotate(transform1, angle, 0, 1, 0)
        self.v1.layer.transform = transform1
        
        var transform2 = CATransform3DIdentity
        transform2.m34 = 1 / -500
        transform2 = CATransform3DRotate(transform2, angle, 0, 1, 0)
        self.v2.layer.transform = transform2
        
        if startAngle == 0 {
            self.v1Cover.alpha = 1 - abs(x / view.frame.width)
            self.v2Cover.alpha = abs(x / view.frame.width)
        } else {
            self.v1Cover.alpha = abs(x / view.frame.width)
            self.v2Cover.alpha = 1 - abs(x / view.frame.width)
        }
        
        if abs(angle) < CGFloat.pi / 2 {
            // Flipping point
            v1.layer.zPosition = 0
            v2.layer.zPosition = 1
        } else {
            v1.layer.zPosition = 1
            v2.layer.zPosition = 0
        }
        
        if gesture.state != .began && gesture.state != .changed {
            finishedPanning(angle: angle, velocity: gesture.velocity(in: view))
        }
    }
    
    /// Animates the flip from an angle to a resting state.
    func finishedPanning(angle: CGFloat, velocity: CGPoint) {
        isAnimating = true
        
        // Done to prevent weird behavior in case the velocity is 0
        var effectiveVelocity = velocity
        if effectiveVelocity.x == 0 {
            if angle < -CGFloat.pi / 2 {
                effectiveVelocity.x = -1
            } else {
                effectiveVelocity.x = 1
            }
        }
        
        // Total duration predicated on 1 second to travel full pi degrees
        
        if effectiveVelocity.x < 0 { // Flip to -pi
            let totalDuration: CGFloat = (CGFloat.pi - abs(angle)) * 1 / CGFloat.pi
            let flipToPiDuration = (angle > -CGFloat.pi / 2) ? (totalDuration - (angle + CGFloat.pi / 2) * totalDuration / CGFloat.pi) : totalDuration
            
            let flipToPiAnimator = UIViewPropertyAnimator(duration: Double(flipToPiDuration), curve: .linear, animations: {
                var transform = CATransform3DIdentity
                transform.m34 = 1 / -500
                transform = CATransform3DRotate(transform, -CGFloat.pi, 0, 1, 0)
                self.v1.layer.transform = transform
                self.v2.layer.transform = transform
                
                self.v1Cover.alpha = 0
                self.v2Cover.alpha = 0.5
                
                // These might have to be here for an edge case
                self.v1.layer.zPosition = 1
                self.v2.layer.zPosition = 0
            })
            
            // Save state variables
            flipToPiAnimator.addCompletion { (_) in
                self.startAngle = effectiveVelocity.x < 0 ? -CGFloat.pi : 0
                self.isAnimating = false
            }
            
            if angle > -CGFloat.pi / 2 {
                // Move to -pi/2 and then change zPosition
                let flipToHalfPiAnimator = UIViewPropertyAnimator(duration: Double(totalDuration - flipToPiDuration), curve: .linear) {
                    var transform = CATransform3DIdentity
                    transform.m34 = 1 / -500
                    transform = CATransform3DRotate(transform, -CGFloat.pi / 2, 0, 1, 0)
                    self.v1.layer.transform = transform
                    self.v2.layer.transform = transform
                    
                    self.v1Cover.alpha = 0
                    self.v2Cover.alpha = 0.5
                }
                
                // Swap z-positions
                flipToHalfPiAnimator.addCompletion { (_) in
                    self.v1.layer.zPosition = 1
                    self.v2.layer.zPosition = 0
                    flipToPiAnimator.startAnimation()
                }
                
                flipToHalfPiAnimator.startAnimation()
            } else {
                flipToPiAnimator.startAnimation()
            }
        } else { // Flip to 0
            let totalDuration: CGFloat = abs(angle) * 1 / CGFloat.pi
            let flipTo0Duration = (angle < -CGFloat.pi / 2) ? (totalDuration - abs(abs(angle) - CGFloat.pi / 2) * totalDuration / CGFloat.pi) : totalDuration
            
            let flipTo0Animator = UIViewPropertyAnimator(duration: Double(flipTo0Duration), curve: .linear, animations: {
                var transform = CATransform3DIdentity
                transform.m34 = 1 / -500
                transform = CATransform3DRotate(transform, 0, 0, 1, 0)
                self.v1.layer.transform = transform
                self.v2.layer.transform = transform
                
                self.v1Cover.alpha = 0.5
                self.v2Cover.alpha = 0
                
                // These might have to be here for an edge case
                self.v1.layer.zPosition = 0
                self.v2.layer.zPosition = 1
            })
            
            // Save state variables
            flipTo0Animator.addCompletion { (_) in
                self.startAngle = effectiveVelocity.x < 0 ? -CGFloat.pi : 0
                self.isAnimating = false
            }
            
            if angle < -CGFloat.pi / 2 {
                // Move to -pi/2 and then change zPosition
                let flipToHalfPiAnimator = UIViewPropertyAnimator(duration: Double(totalDuration - flipTo0Duration), curve: .linear) {
                    var transform1 = CATransform3DIdentity
                    transform1.m34 = 1 / -500
                    transform1 = CATransform3DRotate(transform1, -CGFloat.pi / 2, 0, 1, 0)
                    self.v1.layer.transform = transform1
                    
                    var transform2 = CATransform3DIdentity
                    transform2.m34 = 1 / -500
                    transform2 = CATransform3DRotate(transform2, -CGFloat.pi / 2, 0, 1, 0)
                    self.v2.layer.transform = transform2
                    
                    self.v1Cover.alpha = 0.5
                    self.v2Cover.alpha = 0
                }
                
                // Swap z-positions
                flipToHalfPiAnimator.addCompletion { (_) in
                    self.v1.layer.zPosition = 0
                    self.v2.layer.zPosition = 1
                    flipTo0Animator.startAnimation()
                }
                
                flipToHalfPiAnimator.startAnimation()
            } else {
                flipTo0Animator.startAnimation()
            }
        }
    }
}
