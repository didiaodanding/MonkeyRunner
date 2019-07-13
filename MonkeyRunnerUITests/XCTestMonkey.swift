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
        
        let bundleID = "myCompany.tencent.LLDebugToolDemo1"
    
        var app : XCUIApplication!
        app = XCUIApplication.init(bundleIdentifier: bundleID)
        app!.launch()
        
        if app == nil {
            return -1
        }
        
        sleep(4)
        NSLog("XCTestMonkeySetup->start monkey<-XCTestMonkeySetup")
        
        let monkey = Monkey()
//        monkey.addXCTestTapAlertAction(interval: 100, application: app)
        monkey.addXCTestCheckCurrentApp(interval: 10, application: app)
        
        //add setup events
        //        monkey.addXCTestAppLogin(application: app)
        //        monkey.addXCTestAppQuiteH5Page(interval: 30, application: app)
        //        monkey.addXCTestAppQuiteGamePlayPage(interval: 30, application: app)
        monkey.monkeyAround()
        RunLoop.main.run()
        return 0
    }
}
