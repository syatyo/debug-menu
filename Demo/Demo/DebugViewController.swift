//
//  DebugViewController.swift
//  Demo
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import UIKit

protocol DebugMenuContainer: UIViewController,
    DebugMenuDelegate,
    DebugMenuDataSource,
    UIGestureRecognizerDelegate {
    
    var debugViewController: DebugViewController! { get set }
    var containerView: UIView { get }
    
    func setupDebugMenu()
}

extension DebugMenuContainer {
    
    func setupDebugMenu() {
        view.addSubview(containerView)
        
        debugViewController = DebugViewController(menuSize: containerView.bounds.size)
        
        addChild(debugViewController)
        containerView.addSubview(debugViewController.view)
        debugViewController.didMove(toParent: self)
        
        debugViewController.view.frame = containerView.bounds
        debugViewController.panGestureDelegate = self
        debugViewController.debugMenuDelegate = self
        debugViewController.debugMenuDataSource = self
    }
    
}

protocol DebugMenuDelegate: AnyObject {    
    func debugViewController(_ debugViewController: DebugViewController, requestShowing: Bool)
    func debugViewController(_ debugViewController: DebugViewController, requestHiding: Bool)
}

protocol DebugMenuDataSource: AnyObject {
    func debugItems(in debugViewController: DebugViewController) -> [DebugItem]
}

class DebugViewController: UITableViewController {
    
    var animationDuration: Double = 0.15
    weak var panGestureDelegate: UIGestureRecognizerDelegate?
    weak var debugMenuDelegate: DebugMenuDelegate?
    weak var debugMenuDataSource: DebugMenuDataSource?

    private var presenter: DebugMenuPresenter
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
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
            if !presenter.isShown {
                let requestShowing = parent == nil
                debugMenuDelegate?.debugViewController(self, requestShowing: requestShowing)
            }

            let location = recognizer.location(in: view)
            presenter.began(from: location.x)
            
        case .changed:
            let location = recognizer.location(in: view)
            presenter.move(to: location.x)
            
            UIView.animate(withDuration: animationDuration) {
                self.view.superview?.frame = self.presenter.currentFrame
            }
            
        case .ended, .cancelled, .failed, .possible:
            let translation = recognizer.translation(in: view)
            presenter.fit(by: translation.x)
            
            UIView.animate(withDuration: animationDuration,
                           animations: {
                            self.view.superview?.frame = self.presenter.currentFrame
            }) { [weak self] (finished) in
                guard let self = self, !self.presenter.isShown else { return }
                if !self.presenter.isShown {
                    let requestHiding = self.parent != nil
                    self.debugMenuDelegate?.debugViewController(self, requestHiding: requestHiding)
                }
            }
            
        @unknown default:
            fatalError()
        }
    }
    
}

// MARK: UITableView DataSource
extension DebugViewController {
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debugMenuDataSource?.debugItems(in: self).count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let debugItem = debugMenuDataSource?.debugItems(in: self)[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifer)
        cell.textLabel?.text = debugItem?.title
        cell.detailTextLabel?.text = debugItem?.subTitle
        return cell
    }

}

// MARK: - UITableView Delegate
extension DebugViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let debugItem = debugMenuDataSource?.debugItems(in: self)[indexPath.row] else { return }
        
        switch debugItem.debugAction {
        case .transition(let viewController):
            parent?.present(viewController, animated: true)
            
        case .selectedAction(let action):
            action()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
