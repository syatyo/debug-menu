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
    
    let openedPoint = CGPoint(x: 300, y: 0)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBegan() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.began(from: 30)
        XCTAssertEqual(debugMenuPresenter.beganLocationX, 30)
    }

    func testChangeToRight() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.began(from: 50)
        debugMenuPresenter.move(to: 70)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -280)
    }
    
    func testChangeToLeft() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.move(to: 200)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -100)
        
        debugMenuPresenter.began(from: 200)
        debugMenuPresenter.move(to: 100) // move left
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -200)
    }
    
    func testChangeMinimumFrame() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.move(to: -50)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }
    
    func testChangeMinimumFrameOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.move(to: -1)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }
    
    func testChangedMaximumFrame() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.move(to: 400)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }
    
    func testChangedMaximumFrameOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.move(to: 301)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }

    func testEndMaximize() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.move(to: 70)
        debugMenuPresenter.end(translationX: 80)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }
    
    func testEndMaximizeOnPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.move(to: 60)
        debugMenuPresenter.end(translationX: 70)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }

    /// back to initial position
    func testEndMaximizeOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.move(to: 59)
        debugMenuPresenter.end(translationX: 60)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }

    func testEndMinimize() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.began(from: 300)
        debugMenuPresenter.currentFrame = CGRect(origin: .zero,
                                                 size: debugMenuPresenter.currentFrame.size)
        debugMenuPresenter.move(to: 230)
        XCTAssertEqual(debugMenuPresenter.currentFrame.maxX, 230)
        
        debugMenuPresenter.end(translationX: -1)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }
    
    func testEndMinimizeOnPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.began(from: 300)
        debugMenuPresenter.currentFrame = CGRect(origin: .zero,
                                                 size: debugMenuPresenter.currentFrame.size)
        debugMenuPresenter.move(to: 240)
        debugMenuPresenter.end(translationX: -1)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, -300)
    }

    func testEndMinimizeOffPoint() {
        var debugMenuPresenter = DebugMenuPresenter(sourceSize: CGSize(width: 300, height: 500))
        debugMenuPresenter.threshold = 0.2
        debugMenuPresenter.began(from: 300)
        debugMenuPresenter.currentFrame = CGRect(origin: .zero,
                                                 size: debugMenuPresenter.currentFrame.size)
        debugMenuPresenter.move(to: 241)
        debugMenuPresenter.end(translationX: -1)
        XCTAssertEqual(debugMenuPresenter.currentFrame.minX, 0)
    }
    
}
