//
//  PullableView.swift
//  PullView
//
//  Created by Daniel Vebman on 12/26/16.
//  Copyright © 2016 Brinklet. All rights reserved.
//

import Foundation
import UIKit

/**
    A view with elastic properties that can be interacted with by the user.
 
    `isPullable` is set to true by default.
  
    Most applications will call for use as a container.
 
    Do not override `touchesBegan`, `touchesMoved`, or `touchesEnded` for a `PullableView`; doing so will break it.
*/
class PullableView: UIView {
    
    private var initCenter = CGPoint.zero
    private var initTouchPos = CGPoint.zero
    
    /**
        The reciprocal of the slope of the derivative of the curve describing the displacement.
     
        A higher `pullFactor` allows for less pulling.
     
        `pullFactor` should be greater than 1. The default `pullFactor` is 4.
     */
    public var pullFactor: CGFloat = 4
    /// Values closer to 1 means less oscillation for the animation. The default damping is 0.5.
    public var damping = 0.5
    /// If the view can be pulled.
    public var isPullable: Bool {
        get {
            return layer.value(forKey: Keys.isPullable) as? Bool ?? false
        }
        set(value) {
            if value { isUserInteractionEnabled = true }
            layer.setValue(value, forKey: Keys.isPullable)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPullable = true
    }
    
    /**
        Initializes and returns a newly allocted `PullView` object with the specified frame rectangle and pullable status.
     
         - Parameter frame: The frame rectangle for the PullView.
     
         - Parameter pullable: Whether or not the PullView is initially pullable.
    */
    init(frame: CGRect, pullable: Bool) {
        super.init(frame: frame)
        isPullable = pullable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPullable {
            initCenter = center
            initTouchPos = touches.first!.location(in: superview)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPullable {
            let loc = touches.first!.location(in: self.superview)
            let xOffset = loc.x - initTouchPos.x
            let yOffset = loc.y - initTouchPos.y
            let xOffsetD = xOffset / pullFactor
            let yOffsetD = yOffset / pullFactor
            
            center.x = xOffsetD + initCenter.x
            center.y = yOffsetD + initCenter.y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPullable {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.center = self.initCenter
            }, completion: nil)
        }
    }
}

struct Keys {
    static let isPullable = "isPullable"
}
