//
//  SectionedSlider.swift
//  Colin
//
//  Created by Daniel Vebman on 7/11/19.
//  Copyright © 2019 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class SectionedSlider: UIView {
    private var bars: [UIView] = []
    private let separatorWidth: CGFloat = 1
    
    private(set) var sections: Int
    private(set) var orientation: Orientation
    
    var delegate: SectionedSliderDelegate?
    
    var value: Int = 0 {
        didSet { updateColors() }
    }
    
    var selectedColor: UIColor = .blue {
        didSet { updateColors() }
    }
    
    var deselectedColor: UIColor = .darkGray {
        didSet { updateColors() }
    }
    
    init(frame: CGRect, sections: Int, orientation: Orientation = .portrait) {
        self.sections = sections
        self.orientation = orientation
        super.init(frame: frame)
        
        clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(panGesture)
        
        switch orientation {
        case .portrait:
            layer.cornerRadius = frame.width / 4
            
            let cgSections = CGFloat(sections)
            let barHeight = (frame.height - (cgSections * separatorWidth - 1)) / cgSections
            
            for i in 0..<sections {
                let y = CGFloat(sections - 1 - i) * (barHeight + separatorWidth)
                let bar = UIView(frame: CGRect(x: 0, y: y, width: frame.width, height: barHeight))
                bar.backgroundColor = deselectedColor
                addSubview(bar)
                bars.append(bar)
            }
        case .landscape:
            layer.cornerRadius = frame.height / 4
            
            let cgSections = CGFloat(sections)
            let barWidth = (frame.width - (cgSections * separatorWidth - 1)) / cgSections
            
            for i in 0..<sections {
                let x = CGFloat(i) * (barWidth + separatorWidth)
                let bar = UIView(frame: CGRect(x: x, y: 0, width: barWidth, height: frame.height))
                bar.backgroundColor = deselectedColor
                addSubview(bar)
                bars.append(bar)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleGesture(_ gesture: UIGestureRecognizer) {
        let location = gesture.location(in: self)
        switch orientation {
        case .portrait:
            let proportion = (frame.height - location.y) / frame.height * CGFloat(sections)
            let index = proportion < 0 ? -1 : Int(proportion) + 1
            value = min(max(0, index), sections)
        case .landscape:
            let proportion = location.x / frame.width * CGFloat(sections)
            let index = proportion < 0 ? -1 : Int(proportion) + 1
            value = min(max(0, index), sections)
        }
    }
    
    private func updateColors() {
        guard 0 <= value && value <= bars.count else { return }
        
        for selectedIndex in 0..<value {
            bars[selectedIndex].backgroundColor = selectedColor
        }
        
        for deselectedIndex in value..<bars.count {
            bars[deselectedIndex].backgroundColor = deselectedColor
        }
    }
    
    enum Orientation {
        case portrait, landscape
    }
}

protocol SectionedSliderDelegate {
    func sectionedSlider(_ slider: SectionedSlider, selected: Int)
}
