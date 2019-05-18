//
//  DebugViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

class DebugViewController: UITableViewController {
    
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    weak var panGestureDelegate: UIGestureRecognizerDelegate?
    
    private var sourceFrame: CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.alpha = 0.5
        
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                    action: #selector(edgePanGestureRecognizerDidPanned(recognizer:)))
        edgePanGestureRecognizer.edges = .left
        edgePanGestureRecognizer.delegate = panGestureDelegate
        parent?.view.addGestureRecognizer(edgePanGestureRecognizer)
        
        sourceFrame = view.frame
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @objc private func edgePanGestureRecognizerDidPanned(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        let minimumMinX = max(self.view.frame.minX, 0)
        let maximumMinMinX = min(sourceFrame.size.width, self.view.frame.minY)
        
        switch recognizer.state {
        case .changed:
            let transition = recognizer.translation(in: view)
            let location = recognizer.location(in: view)
            
            UIView.animate(withDuration: 0.1) {
                self.view.frame = CGRect(x: self.view.frame.minX + location.x,
                                         y: self.view.frame.minY,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
            }
        default:
            print()
        }
    }
    
}
