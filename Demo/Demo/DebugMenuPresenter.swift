//
//  DebugMenuPresenter.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

/// Presentation logic of Debug Menu.
struct DebugMenuPresenter {
    
    /// Initial frame of menu.
    let sourceFrame: CGRect
    
    /// Threshold to open or close menu. The value is in 0...1
    var threshold: CGFloat = 0.3
    
    /// Current framw of menu.
    var currentFrame: CGRect
    
    /// The x point that you start dragging.
    private(set) var beganLocationX: CGFloat = 0
    
    init(sourceSize: CGSize) {
        self.sourceFrame = CGRect(origin: CGPoint(x: -sourceSize.width, y: 0),
                                  size: sourceSize)
        self.currentFrame = sourceFrame
    }
    
    mutating func began(from locationMinX: CGFloat) {
        beganLocationX = locationMinX
    }
    
    mutating func move(to locationX: CGFloat) {
        let distance = (beganLocationX - locationX) * -1
        let destinationX = currentFrame.minX + distance
        
        let minX: CGFloat = {
            if destinationX < sourceFrame.minX {
                return sourceFrame.minX
            } else if destinationX > sourceFrame.maxX {
                return 0
            } else {
                 return destinationX
            }
        }()
        
        currentFrame = currentFrame.prototype(withX: minX)
    }
    
    mutating func end(translationX: CGFloat) {
        let direction = Direction(translationX: translationX)
        
        switch direction {
        case .left:
            let totalMoved = sourceFrame.width - currentFrame.maxX
            if totalMoved >= (sourceFrame.width * threshold) {
                currentFrame = currentFrame.prototype(withX: sourceFrame.minX)
            } else {
                currentFrame = currentFrame.prototype(withX: 0)
            }
        case .right:
            let totalMoved = currentFrame.minX - sourceFrame.minX
            if totalMoved >= (sourceFrame.width * threshold) {
                currentFrame = currentFrame.prototype(withX: 0)
            } else {
                currentFrame = currentFrame.prototype(withX: sourceFrame.minX)
            }
        }
    }
    
    private enum Direction {
        case left
        case right
        
        init(translationX: CGFloat) {
            if translationX < 0 {
                self = .left
            } else {
                self = .right
            }
        }
    }
    
}

private extension CGRect {
    
    /// Clone instance with specific x value.
    ///
    /// - Parameter x: CGPoint x value.
    /// - Returns: new CGRect instance
    func prototype(withX x: CGFloat) -> CGRect {
        return CGRect(x: x,
                      y: self.minY,
                      width: self.width,
                      height: self.height)
    }
    
}
