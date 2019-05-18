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
        view.backgroundColor = .groupTableViewBackground
        
        view.addSubview(containerView)
        
        debugViewController = DebugViewController(menuSize: containerView.bounds.size)
        
        addChild(debugViewController)
        containerView.addSubview(debugViewController.view)
        debugViewController.didMove(toParent: self)
        
        debugViewController.view.frame = containerView.bounds
        debugViewController.panGestureDelegate = self
        
        let sampleItems: [DebugItem] = [
            DebugItem(title: "title1",
                      subTitle: "subtitle1",
                      debugAction: .selectedAction( { print("hello world1") })),
            DebugItem(title: "title2",
                      subTitle: "subtitle2",
                      debugAction: .selectedAction( { print("hello world2") }))
        ]
        debugViewController.debugItems = sampleItems
    }
    
}

extension ViewController: UIGestureRecognizerDelegate { }
