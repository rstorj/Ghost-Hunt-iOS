//
//  TimerModel.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class TimerModel: NSObject {
    
    private var timeElapsed:Int = 0
    private var timeLimit:Int = 1800
    
    static let sharedTimer: TimerModel = {
        let timer = TimerModel()
        return timer
    }()
    
    var internalTimer: Timer?
    var jobs = [() -> Void]()
    
    func startOneSecondTimer(withJob job: @escaping () -> Void) {
        if internalTimer != nil {
            internalTimer?.invalidate()
        }
        jobs.append(job)
        internalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doJob), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }
    
    func stopTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        jobs = [()->()]()
        internalTimer?.invalidate()
    }
    
    func getTimeElapsed() -> Int {
        return timeElapsed
    }
    
    func getTimeLimit() -> Int {
        return timeLimit
    }
    
    func addTimeInBackground(seconds: Int) {
        timeElapsed += seconds
    }
    
    @objc func doJob() {
        timeElapsed = timeElapsed + 1
        guard jobs.count > 0 else { return }
        for job in jobs {
            job()
        }
    }
}
