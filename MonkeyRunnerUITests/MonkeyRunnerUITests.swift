//
//  MonkeyRunnerUITests.swift
//  MonkeyRunnerUITests
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 apple. All rights reserved.
//

import XCTest

class MonkeyRunnerUITests: XCTestCase {

    var monkey: XCTestMonkey?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRunner(){
        self.monkey = XCTestMonkey()
        _ = self.monkey?.startMonkey()
    }

}
