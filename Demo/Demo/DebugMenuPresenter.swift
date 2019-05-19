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
    
    /// lower limit frame of menu.
    let lowerLimitFrame: CGRect
    
    /// upper limit frame of menu.
    let upperLimitFrame: CGRect
    
    /// current framw of menu.
    var currentFrame: CGRect

    /// threshold to open or close menu. The value is in 0...1
    var threshold: CGFloat = 0.1
    
    /// Either debug menu is visible or not
    var isShown: Bool {
        return currentFrame.minX > lowerLimitFrame.minX
    }
    
    /// the x point that you start dragging.
    private(set) var beganLocationX: CGFloat = 0
    
    init(sourceSize: CGSize) {
        self.lowerLimitFrame = CGRect(origin: CGPoint(x: -sourceSize.width, y: 0),
                                  size: sourceSize)
        self.upperLimitFrame = lowerLimitFrame.prototype(withX: 0)
        self.currentFrame = lowerLimitFrame
    }
    
    /// store start position of pan.
    ///
    /// - Parameter locationMinX: Position x to store.
    mutating func began(from locationX: CGFloat) {
        beganLocationX = locationX
    }
    
    /// change current frame. point x is in 0...upperLimitFrame.minX.
    ///
    /// - Parameter locationX: location x to move
    mutating func move(to locationX: CGFloat) {
        let panDistance = beganLocationX - locationX
        let destinationFrameX = currentFrame.minX - panDistance
        
        let minX: CGFloat = {
            let isBelowLowerLimit = destinationFrameX < lowerLimitFrame.minX
            let isOverUppserLimit = destinationFrameX > upperLimitFrame.minX
            
            if isBelowLowerLimit {
                return lowerLimitFrame.minX
            } else if isOverUppserLimit {
                return upperLimitFrame.minX
            } else {
                 return destinationFrameX
            }
        }()
        
        currentFrame = currentFrame.prototype(withX: minX)
    }
    
    /// fit current frame to edge by pan state.
    ///
    /// - Parameter translationX: translation point x to distinguish direction.
    mutating func fit(by translationX: CGFloat) {
        let direction = PanDirection(translationX: translationX)
        
        switch direction {
        case .left:
            let distanceFromStartEdge = upperLimitFrame.maxX - currentFrame.maxX
            if distanceFromStartEdge >= (lowerLimitFrame.width * threshold) {
                currentFrame = currentFrame.prototype(withX: lowerLimitFrame.minX)
            } else {
                currentFrame = currentFrame.prototype(withX: 0)
            }
        case .right:
            let distanceFromEndEdge = currentFrame.minX - lowerLimitFrame.minX
            if distanceFromEndEdge >= (lowerLimitFrame.width * threshold) {
                currentFrame = currentFrame.prototype(withX: 0)
            } else {
                currentFrame = currentFrame.prototype(withX: lowerLimitFrame.minX)
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
    
    /// clone instance with given x value.
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
