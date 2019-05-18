//
//  PanGestureOperator.swift
//  DemoTests
//
//  Created by syatyo on 2019/05/18.
//  Copyright © 2019 syatyo. All rights reserved.
//

import XCTest
@testable import Demo
class DebugMenuPresenterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeToRight() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: 30, y: 0))
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -270)
    }
    
    func testChangeToLeft() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: 200, y: 0)) // move right to shift current frame
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -100)
        
        debugMenuPresenter.change(in: CGPoint(x: -50, y: 0)) // move left
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -150)
    }
    
    func testChangeMinimumFrame() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: -50, y: 0))
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }
    
    func testChangeMinimumFrameOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: -1, y: 0))
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }
    
    func testChangedMaximumFrame() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: 400, y: 0))
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }
    
    func testChangedMaximumFrameOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.change(in: CGPoint(x: 301, y: 0))
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }

    // TODO: - パンが終了した時に、閾値以上であればopen/closeできるようにしたい
}
