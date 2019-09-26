//
//  XCTestMonkey.swift
//  MonkeyRunnerUITests
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import XCTest

public class XCTestMonkey{
    func startMonkey() -> Int {
        
        let bundleID = "myCompany.tencent.LLDebugToolDemo2"
    
        var app : XCUIApplication!
        app = XCUIApplication.init(bundleIdentifier: bundleID)
        app!.launch()
        
        if app == nil {
            return -1
        }
        
        sleep(4)
        NSLog("XCTestMonkeySetup->start monkey<-XCTestMonkeySetup")
        
        let monkey = Monkey()

        
        monkey.addXCTestTapAlertAction(interval: 10, application: app)
        monkey.addXCTestCheckCurrentApp(interval: 10, application: app)

        monkey.monkeyAround()
        RunLoop.main.run()
        return 0
    }
}
