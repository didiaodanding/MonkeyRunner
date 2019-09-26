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
    var regularActions: [(interval: Int, action: () -> Void)]
    var actionCounter = 0
    
    let lock = DispatchSemaphore(value: 1)

    
    public init() {
        self.checkActions = []
        self.regularActions = []
    }
    
    /// Generate any pending fixed-interval events.
    public func actRegularly() {
        actionCounter += 1
        for action in regularActions {
            if actionCounter % action.interval == 0 {
                actionLock(action: action.action)
            }
        }
    }
    
    public func actionLock(action:@escaping ()->Void){
        let work = DispatchWorkItem(qos:.default){
            self.lock.wait()
            action()
            self.lock.signal()
            return
        }
        DispatchQueue.main.sync(execute:work)
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
     Add a block for fixed-interval events.
     
     - parameter interval: How often to generate this
     event. One of these events will be generated after
     this many randomised events have been generated.
     - parameter action: The block to run when this event
     is generated.
     */
    public func addAction(interval: Int, action: @escaping () -> Void) {
        regularActions.append((interval: interval, action: action))
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
    
    /**
     Add an action that checks, at a fixed interval,
     if an alert is being displayed, and if so, selects
     a random button on it.
     
     - parameter interval: How often to generate this
     event. One of these events will be generated after
     this many randomised events have been generated.
     - parameter application: The `XCUIApplication` object
     for the current application.
     */
    public func addXCTestTapAlertAction(interval: Int, application: XCUIApplication) {
        addAction(interval: interval) { [weak self] in
            //处理被测app内的弹窗
            if application.state == XCUIApplication.State.runningForeground {
                for i in 0 ..< application.alerts.count {
                    let alert = application.alerts.element(boundBy: i)
                    let buttons = alert.descendants(matching: .button)
                    let index = buttons.count - 1 ;
                    let button = buttons.element(boundBy: index)
                    button.tap()
                }
            }else{
                application.activate()
                self!.sleep(5)
            }
            //处理系统弹窗
            let sprintboard = XCUIApplication.init(bundleIdentifier: "com.apple.springboard")
            for i in 0 ..< sprintboard.alerts.count {
                if sprintboard.buttons["允许"].exists{
                    sprintboard.buttons["允许"].tap()
                }else if sprintboard.buttons["好"].exists{
                    sprintboard.buttons["好"].tap()
                }else if sprintboard.buttons["打开"].exists{
                    sprintboard.buttons["打开"].tap()
                }else{
                    let alert = sprintboard.alerts.element(boundBy: i)
                    let buttons = alert.descendants(matching: .button)
                    let index = buttons.count - 1
                    let button = buttons.element(boundBy: index)
                    button.tap()
                }
            }
        }
    }
    
    /// Generate random events forever, or until the app crashes.
    public func monkeyAround() {
        DispatchQueue.global().async {
            while true{
                self.actCheck()
                self.actRegularly()
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
