//
//  DebugViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

class DebugViewController: UITableViewController {
    private var presenter: DebugMenuPresenter

    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    weak var panGestureDelegate: UIGestureRecognizerDelegate?
    
    init(menuSize: CGSize) {
        presenter = DebugMenuPresenter(sourceSize: menuSize)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.addGestureRecognizer(panGestureRecognizer)
        
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
    
    @objc private func panGestureRecognizerDidPanned(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        let location = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .began:
            print(location)
            presenter.began(from: location.x)
        case .changed:
            presenter.move(to: location.x)
            
            UIView.animate(withDuration: 0.1) {
                self.view.superview?.frame = self.presenter.currentFrame
            }
        case .ended, .cancelled, .failed, .possible:
            presenter.fit(by: translation.x)
            
            UIView.animate(withDuration: 0.1) {
                self.view.superview?.frame = self.presenter.currentFrame
            }
        @unknown default:
            fatalError()
        }
    }
    
}
