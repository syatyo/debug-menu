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
    
    var debugItems: [DebugItem] = []
    private let reuseIdentifer = "cell"
    
    init(menuSize: CGSize) {
        presenter = DebugMenuPresenter(sourceSize: menuSize)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                    action: #selector(panGestureRecognizerDidPanned(recognizer:)))
        edgePanGestureRecognizer.edges = .left
        edgePanGestureRecognizer.delegate = panGestureDelegate
        parent?.view.addGestureRecognizer(edgePanGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                      action: #selector(panGestureRecognizerDidPanned(recognizer:)))
        panGestureRecognizer.delegate = panGestureDelegate
        view.addGestureRecognizer(panGestureRecognizer)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
    }
    
    @objc private func panGestureRecognizerDidPanned(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: view)
            presenter.began(from: location.x)
            
        case .changed:
            let location = recognizer.location(in: view)
            presenter.move(to: location.x)
            
            UIView.animate(withDuration: 0.1) {
                self.view.superview?.frame = self.presenter.currentFrame
            }
            
        case .ended, .cancelled, .failed, .possible:
            let translation = recognizer.translation(in: view)
            presenter.fit(by: translation.x)
            
            UIView.animate(withDuration: 0.1) {
                self.view.superview?.frame = self.presenter.currentFrame
            }
            
        @unknown default:
            fatalError()
        }
    }
    
}

// MARK: UITableView DataSource
extension DebugViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debugItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let debugItem = debugItems[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifer)
        cell.textLabel?.text = debugItem.title
        cell.detailTextLabel?.text = debugItem.subTitle
        return cell
    }

}

// MARK: - UITableView Delegate
extension DebugViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let debugItem = debugItems[indexPath.row]
        
        switch debugItem.debugAction {
        case .transition(let viewController):
            parent?.present(viewController, animated: true)
            
        case .selectedAction(let action):
            action()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
