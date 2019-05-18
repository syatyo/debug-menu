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
    
    init(sourceSize: CGSize) {
        self.sourceSize = sourceSize
        self.sourceFrame = CGRect(origin: CGPoint(x: -sourceSize.width,
                                                  y: 0),
                                  size: sourceSize)
        self.currentFrame = sourceFrame
    }
    
    mutating func change(in location: CGPoint) {
        let minX: CGFloat = {
            if currentFrame.minX + location.x < sourceFrame.minX {
                return currentFrame.minX
            } else if currentFrame.minX + location.x > sourceFrame.maxX {
                return 0
            } else {
                 return currentFrame.minX + location.x
            }
        }()
        
        self.currentFrame = CGRect(x: minX,
                                   y: currentFrame.minY,
                                   width: currentFrame.width,
                                   height: currentFrame.height)
    }
    
}
