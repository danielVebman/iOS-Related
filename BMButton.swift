//
//  BMB.swift
//  BurgerMenuButton
//
//  Created by Daniel Vebman on 1/19/17.
//  Copyright © 2017 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

/**
    A 'burger menu' `UIButton` that toggles between the opened and closed states. 
*/
class BMButton: UIButton {
    
    /// Whether `self` is currently in the open or closed state
    private enum Status {
        case menuOpened
        case menuClosed
    }
    
    /// The ids of the three bars
    private enum Ids {
        case bar1
        case bar2
        case bar3
    }
    
    /// `simple` fades the bars when the touch is inside `self`'s frame; `complex` animates the bars' positions
    public enum SecondaryAnimationStyle {
        case simple
        case complex
    }
    
    /// The color of the bars. The default `tintColor` is `UIColor.black`.
    override var tintColor: UIColor!  {
        willSet(color) {
            animView.bar1!.backgroundColor = color
            animView.bar2!.backgroundColor = color
            animView.bar3!.backgroundColor = color
        }
    }
    
    /// The current animation style of `self`
    public var secondaryAnimationStyle = SecondaryAnimationStyle.complex
    
    /// The view containing the bars in which the animation occurs.
    private var animView: AnimView!
    /// The status of `self`.
    private var status = Status.menuClosed
    
    /// Initialize `self` with the given frame. The default `tintColor` is `UIColor.black`, and the default `secondaryAnimationStyle` is `.complex`.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAnimView()
        
        tintColor = UIColor.black
        
        addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
        addTarget(self, action: #selector(selected), for: .touchDown)
        addTarget(self, action: #selector(selected), for: .touchDragEnter)
        addTarget(self, action: #selector(deselected), for: .touchDragExit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializes `animView` and adds the bars to it.
    private func setupAnimView() {
        animView = AnimView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        animView.isUserInteractionEnabled = false
        
        let barWidth = min(frame.width, frame.height) * 4 / 5
        let barHeight: CGFloat = 3
        
        let bar1 = UIView(frame: CGRect(x: (frame.width - barWidth) / 2, y: frame.height * 1 / 4 - barHeight / 2, width: barWidth, height: barHeight))
        let bar2 = UIView(frame: CGRect(x: (frame.width - barWidth) / 2, y: frame.height * 2 / 4 - barHeight / 2, width: barWidth, height: barHeight))
        let bar3 = UIView(frame: CGRect(x: (frame.width - barWidth) / 2, y: frame.height * 3 / 4 - barHeight / 2, width: barWidth, height: barHeight))
        
        bar1.backgroundColor = tintColor
        bar2.backgroundColor = tintColor
        bar3.backgroundColor = tintColor
        
        animView.bar1 = bar1
        animView.bar2 = bar2
        animView.bar3 = bar3
        
        animView.addSubview(bar2)
        animView.addSubview(bar3)
        
        addSubview(animView)
    }
    
    /// Toggle and animate the state of the button between `.menuOpened` and `.menuClosed`.
    func toggleButton() {
        if status == .menuClosed {
            status = .menuOpened
            UIView.animate(withDuration: 0.25, animations: {
                self.animView.bar1!.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 4))
                self.animView.bar1!.center = CGPoint(x: self.animView.frame.width / 2, y: self.animView.frame.height / 2)
                self.animView.bar2!.frame.size.width = 0
                self.animView.bar2!.alpha = 0
                self.animView.bar3!.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 4))
                self.animView.bar3!.center = CGPoint(x: self.animView.frame.width / 2, y: self.animView.frame.height / 2)
            })
        } else if status == .menuOpened {
            status = .menuClosed
            UIView.animate(withDuration: 0.25, animations: {
                self.animView.bar1!.transform = CGAffineTransform(rotationAngle: 0)
                self.animView.bar2!.alpha = 1
                self.animView.bar3!.transform = CGAffineTransform(rotationAngle: 0)
                
                let barWidth = min(self.frame.width, self.frame.height) * 4 / 5
                let barHeight: CGFloat = 3
                self.animView.bar2!.frame.size.width = barWidth
                self.animView.bar1!.frame.origin = CGPoint(x: (self.frame.width - barWidth) / 2, y: self.frame.height * 1 / 4 - barHeight / 2)
                self.animView.bar2!.frame.origin = CGPoint(x: (self.frame.width - barWidth) / 2, y: self.frame.height * 2 / 4 - barHeight / 2)
                self.animView.bar3!.frame.origin = CGPoint(x: (self.frame.width - barWidth) / 2, y: self.frame.height * 3 / 4 - barHeight / 2)
            })
        }
        if secondaryAnimationStyle == .simple {
            deselected()
        }
    }
    
    /// Called when the touch enters `self`'s frame.
    @objc private func selected() {
        if secondaryAnimationStyle == .complex {
            if status == .menuClosed {
                UIView.animate(withDuration: 0.15, animations: {
                    self.animView.bar1!.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 10))
                    self.animView.bar2!.frame.size.width *= 3 / 4
                    self.animView.bar3!.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 10))
                })
            } else if status == .menuOpened {
                UIView.animate(withDuration: 0.15, animations: {
                    self.animView.bar1!.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 5))
                    self.animView.bar3!.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 5))
                })
            }
        } else if secondaryAnimationStyle == .simple {
            UIView.animate(withDuration: 0.15, animations: {
                for bar in self.animView.bars {
                    bar?.alpha = 0.5
                }
            })
        }
    }
    
    /// Called when the touch left `self`'s frame.
    @objc private func deselected() {
        if secondaryAnimationStyle == .complex {
            if status == .menuClosed {
                UIView.animate(withDuration: 0.25, animations: {
                    self.animView.bar1!.transform = CGAffineTransform(rotationAngle: 0)
                    self.animView.bar2!.frame.size.width *= 4 / 3
                    self.animView.bar3!.transform = CGAffineTransform(rotationAngle: 0)
                })
            } else if status == .menuOpened {
                UIView.animate(withDuration: 0.25, animations: {
                    self.animView.bar1!.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 4))
                    self.animView.bar3!.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 4))
                })
            }
        } else if secondaryAnimationStyle == .simple {
            UIView.animate(withDuration: 0.25, animations: {
                for bar in self.animView.bars {
                    bar?.alpha = 1
                }
            })
        }
    }
    
    /// The view containing the bars to be animated.
    private class AnimView: UIView {
        var bars: [UIView?] {
            get {
                return [bar1, bar2, bar3]
            }
        }
        
        var bar1: UIView? {
            willSet(bar) {
                addSubview(bar!)
            }
        }
        var bar2: UIView? {
            willSet(bar) {
                addSubview(bar!)
            }
        }
        var bar3: UIView? {
            willSet(bar) {
                addSubview(bar!)
            }
        }
    }
    
}
