//
//  ATextField.swift
//  ATextField
//
//  Created by Daniel Vebman on 1/20/17.
//  Copyright © 2017 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

/**
    A `UITextField` that looks and acts similarly to Google's text fields. 
*/
class ATextField: UITextField, UITextFieldDelegate {
    
    /// The label containing the placeholder text.
    public var placeholderLabel: UILabel!
    
    /** Initialize with the given frame and placeholder.

    - parameters:
        - frame: The frame with which to initialize. The area in which `ATextField` is drawn is actually 10pt greater on the top than the given `frame`.
        - placeholder: The placeholder text.
    */
    init(frame: CGRect, placeholder: String?) {
        super.init(frame: frame)
        
        placeholderLabel = UILabel(frame: CGRect(x: alignmentRectInsets.left, y: alignmentRectInsets.top, width: frame.width - alignmentRectInsets.left - alignmentRectInsets.right, height: frame.height - alignmentRectInsets.top - alignmentRectInsets.bottom))
        placeholderLabel.text = placeholder
        placeholderLabel.font = font ?? UIFont.systemFont(ofSize: 20)
        placeholderLabel.textColor = UIColor.lightGray
        addSubview(placeholderLabel)
        
        clipsToBounds = false
        delegate = self
        layer.addBorder(edge: .bottom, color: UIColor.gray, thickness: 0.5)
        tintColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The font used to draw the text and `placeholderLabel` text.
    override var font: UIFont? {
        willSet(font) {
            placeholderLabel.font = font!
        }
    }
    
    /// The color of the text cursor and bar.
    override var tintColor: UIColor! {
        willSet(color) {
            layer.addBorder(edge: .bottom, color: color, thickness: 0.5)
        }
    }
    
    /// The text displayed when `self` is empty (contains no text).
    override var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set(text) {
            placeholderLabel.text = text
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.placeholderLabel.frame.origin = CGPoint(x: 0, y: -10)
        })
        layer.animateBorder(startWidth: frame.width - 10, endWidth: frame.width + 10, startThickness: 0.5, endThickness: 1, startColor: tintColor, endColor: tintColor, time: 0.25)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (text?.isEmpty)! {
            UIView.animate(withDuration: 0.25, animations: {
                self.placeholderLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.placeholderLabel.frame.origin = CGPoint(x: self.alignmentRectInsets.left, y: self.alignmentRectInsets.top)
            })
        }
        layer.animateBorder(startWidth: frame.width + 10, endWidth: frame.width - 10, startThickness: 1, endThickness: 0.5, startColor: tintColor, endColor: tintColor, time: 0.25)
    }
    
}

private extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CAShapeLayer()
        switch edge {
        case UIRectEdge.top:
            border.path = CGPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: thickness),transform: nil)
        case UIRectEdge.bottom:
            border.path = CGPath(rect:CGRect(x: 0, y:self.frame.height - thickness, width:self.frame.width, height: thickness), transform: nil)
        case UIRectEdge.left:
            border.path = CGPath(rect: CGRect(x:0, y:0, width: thickness, height: self.frame.height),transform: nil)
        case UIRectEdge.right:
            border.path = CGPath(rect: CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height),transform: nil)
        default:
            break
        }
        border.name="border"
        border.fillColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    func animateBorder(startWidth: CGFloat, endWidth: CGFloat, startThickness: CGFloat, endThickness: CGFloat, startColor: UIColor, endColor: UIColor, time: CGFloat) {
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = CGPath(rect:CGRect(x: (self.frame.width - startWidth) / 2, y:self.frame.height - startThickness, width:startWidth, height: startThickness), transform: nil)
        animation.toValue = CGPath(rect:CGRect(x: (self.frame.width - endWidth) / 2, y:self.frame.height - endThickness, width:endWidth, height: endThickness), transform: nil)
        animation.duration = Double(time)
        animation.speed = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let animationC = CABasicAnimation(keyPath: "fillColor")
        animationC.fromValue = startColor.cgColor
        animationC.toValue = endColor.cgColor
        animationC.duration = Double(time)
        animationC.speed = 1
        animationC.isRemovedOnCompletion = false
        animationC.fillMode = kCAFillModeBoth
        animationC.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        for border in self.sublayers! {
            if border.name == "border" {
                border.add(animation, forKey: nil)
                border.add(animationC, forKey: nil)
            }
        }
    }
}
