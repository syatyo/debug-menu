//
//  DebugMenuPresenter.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

/// presentation logic for Debug Menu.
struct DebugMenuPresenter {
    
    /// initial frame of menu.
    let sourceFrame: CGRect
    
    /// threshold to open or close menu. The value is in 0...1
    var threshold: CGFloat = 0.3
    
    /// current framw of menu.
    var currentFrame: CGRect
    
    /// the x point that you start dragging.
    private(set) var beganLocationX: CGFloat = 0
    
    init(sourceSize: CGSize) {
        self.sourceFrame = CGRect(origin: CGPoint(x: -sourceSize.width, y: 0),
                                  size: sourceSize)
        self.currentFrame = sourceFrame
    }
    
    /// store start position of pan.
    ///
    /// - Parameter locationMinX: Position x to store.
    mutating func began(from locationX: CGFloat) {
        beganLocationX = locationX
    }
    
    /// change current frame. point x is in 0...sourceFrame.minX.
    ///
    /// - Parameter locationX: location x to move
    mutating func move(to locationX: CGFloat) {
        let distance = beganLocationX - locationX
        let destinationX = currentFrame.minX - distance
        
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
    
    /// fit current frame by pan state.
    ///
    /// - Parameter translationX: translation point x to distinguish direction.
    mutating func fit(by translationX: CGFloat) {
        let direction = PanDirection(translationX: translationX)
        
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
    
    /// pan direction
    ///
    /// - left: pan to left
    /// - right: pan to right
    private enum PanDirection {
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
