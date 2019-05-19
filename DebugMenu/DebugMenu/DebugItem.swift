//
//  DebugItem.swift
//  Demo
//
//  Created by syatyo on 2019/05/19.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

/// Debug item that listed in Debug Menu.
public struct DebugItem {
    
    /// title for textLabel.
    let title: String
    
    /// subTitle for detailTextLabel.
    let subTitle: String
    
    /// executable debug action when selected cell.
    let debugAction: DebugAction
    
    /// debug action.
    ///
    /// - transition: destination ViewController for transition.
    /// - selectedAction->Void: any action you want to execute.
    public enum DebugAction {
        case transition(UIViewController)
        case selectedAction(() -> Void)
    }
    
    public init(title: String, subTitle: String, debugAction: DebugAction) {
        self.title = title
        self.subTitle = subTitle
        self.debugAction = debugAction
    }
    
}
