//
//  ViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var debugViewController: DebugViewController!
    
    private let containerView: UIView = {
        let debugMenuWidthMultiplier: CGFloat = 0.8
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width * debugMenuWidthMultiplier
        let frame = CGRect(x: -width,
                           y: screenBounds.minY,
                           width: width,
                           height: screenBounds.height)
        return UIView(frame: frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.backgroundColor = .yellow
        
        debugViewController = DebugViewController(menuSize: containerView.bounds.size)
        
        addChild(debugViewController)
        containerView.addSubview(debugViewController.view)
        debugViewController.didMove(toParent: self)
        
        debugViewController.view.frame = containerView.bounds
        debugViewController.panGestureDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        assert(view.bounds.width > containerView.bounds.width)
    }
}

extension ViewController: UIGestureRecognizerDelegate { }
