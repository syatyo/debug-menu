//
//  DebugMenuPresenter.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

struct DebugMenuPresenter {
    let sourceFrame: CGRect
    let sourceSize: CGSize
    private(set) var currentFrame: CGRect
    private(set) var beganLocation: CGPoint = .zero
    
    init(sourceSize: CGSize) {
        self.sourceSize = sourceSize
        self.sourceFrame = CGRect(origin: CGPoint(x: -sourceSize.width,
                                                  y: 0),
                                  size: sourceSize)
        self.currentFrame = sourceFrame
    }
    
    mutating func began(in location: CGPoint) {
        beganLocation = location
    }
    
    mutating func change(in location: CGPoint) {
        let distance: CGFloat = (beganLocation.x - location.x) * -1
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
        
        self.currentFrame = CGRect(x: minX,
                                   y: currentFrame.minY,
                                   width: currentFrame.width,
                                   height: currentFrame.height)
        print(currentFrame)
    }
    
}
