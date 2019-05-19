//
//  ViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit
import DebugMenu

class ViewController: UIViewController {
    
    var debugViewController: DebugViewController!
    
    let containerView: UIView = {
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
        
        setupDebugMenu()
    }
    
}

extension ViewController: UIGestureRecognizerDelegate { }

extension ViewController: DebugMenuDelegate {
    
    func debugViewController(_ debugViewController: DebugViewController, requestShowing: Bool) {
        guard requestShowing else { return }
        addChild(debugViewController)
        containerView.addSubview(debugViewController.view)
        debugViewController.didMove(toParent: self)
    }
    
    func debugViewController(_ debugViewController: DebugViewController, requestHiding: Bool) {
        guard requestHiding else { return }
        debugViewController.willMove(toParent: nil)
        debugViewController.view.removeFromSuperview()
        debugViewController.removeFromParent()
    }

}

extension ViewController: DebugMenuDataSource {
    
    func debugItems(in debugViewController: DebugViewController) -> [DebugItem] {
        let debugItems: [DebugItem] = [
            DebugItem(title: "title1",
                      subTitle: "subtitle1",
                      debugAction: .selectedAction( { print("hello world1") })),
            DebugItem(title: "title2",
                      subTitle: "subtitle2",
                      debugAction: .selectedAction( { print("hello world2") }))
        ]
        return debugItems
    }
    
}

extension ViewController: DebugMenuContainer { }
