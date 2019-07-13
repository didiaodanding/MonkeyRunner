//
//  Monkey.swift
//  MonkeyRunnerUITests
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import XCTest

public class Monkey {
    
    var checkActions: [(interval: Int, action: () -> Void)]
    
    
    public init() {
        self.checkActions = []
    }
    
    /// Generate one check app event
    public func actCheck(){
        for action in checkActions {
            action.action()
        }
    }
    
    /**
     Add a block for generating check events
     */
    public func addCheck(interval:Int, action: @escaping () -> Void){
        checkActions.append((interval: interval, action: action))
    }
    
    /**
     Add an action that checks current app, at a fixed interval,
     if app is not running , so launch app
     */
    
    public func addXCTestCheckCurrentApp(interval:Int, application:XCUIApplication) {
        addCheck(interval:interval){ [weak self] in
            let work = DispatchWorkItem(qos:.userInteractive){
                if (application.state != XCUIApplication.State.runningForeground){
                    application.activate()
                    self?.sleep(5)
                }
            }
            DispatchQueue.main.async(execute:work)
        }
    }
    
    
    /// Generate random events forever, or until the app crashes.
    public func monkeyAround() {
        DispatchQueue.global().async {
            while true{
                self.actCheck()
                usleep(500000)
            }
        }
    }
    
    func sleep(_ seconds: Double) {
        if seconds>0 {
            usleep(UInt32(seconds * 1000000.0))
        }
    }
}
