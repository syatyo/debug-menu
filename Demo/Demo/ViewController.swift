//
//  ViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let debugViewController = DebugViewController()
    private let containerView = UIView()
    private let debugMenuBounds: CGRect = {
        let debugMenuWidthMultiplier: CGFloat = 0.8
        return CGRect(x: 0,
                      y: 0,
                      width: UIScreen.main.bounds.width * debugMenuWidthMultiplier,
                      height: UIScreen.main.bounds.height)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.frame = debugMenuBounds
        
        addChild(debugViewController)
        containerView.addSubview(debugViewController.view)
        debugViewController.didMove(toParent: self)
        
//        let debugMenuInitialFrame = CGRect(x: containerView.frame.minX - containerView.frame.size.width,
//                                           y: containerView.frame.minY,
//                                           width: containerView.frame.width,
//                                           height: containerView.frame.height)
        debugViewController.view.frame = containerView.frame
        debugViewController.panGestureDelegate = self
    }
}

extension ViewController: UIGestureRecognizerDelegate { }
