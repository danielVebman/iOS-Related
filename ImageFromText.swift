//
//  ImageFromText.swift
//  SwipeableCell
//
//  Created by Daniel Vebman on 1/14/17.
//  Copyright © 2017 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

/// Returns an image with the given text and font (`pointSize` does not matter)
/**
 - parameters:
    - string: The text to be made into an image
    - font: The font with which the text should be displayed. If `font` is `nil`, the system font will be used.
*/
func image(from string: String, with font: UIFont?) -> UIImage {
    let label = UILabel()
    label.text = string
    label.font = font ?? UIFont.systemFont(ofSize: 1000)
    label.font = UIFont(name: label.font!.fontName, size: 1000)
    label.sizeToFit()
    
    UIGraphicsBeginImageContext(label.frame.size)
    label.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
