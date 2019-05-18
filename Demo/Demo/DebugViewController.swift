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
    private var panGestureRecognizer: UIPanGestureRecognizer!
    weak var panGestureDelegate: UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.alpha = 0.5
        
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                    action: #selector(panGestureRecognizerDidPanned(recognizer:)))
        edgePanGestureRecognizer.edges = .left
        edgePanGestureRecognizer.delegate = panGestureDelegate
        parent?.view.addGestureRecognizer(edgePanGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                      action: #selector(panGestureRecognizerDidPanned(recognizer:)))
        panGestureRecognizer.delegate = panGestureDelegate
        parent?.view.addGestureRecognizer(panGestureRecognizer)
        
        presenter = DebugMenuPresenter(sourceSize: view.bounds.size)
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

    private var presenter: DebugMenuPresenter!
    
    @objc private func panGestureRecognizerDidPanned(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: view)
            presenter.began(in: location)
        case .changed:
            let location = recognizer.location(in: view)
            presenter.change(in: location)
            
            UIView.animate(withDuration: 0.1) {
                self.view.frame = self.presenter.currentFrame
            }
        default:
            print()
        }
    }
    
}
