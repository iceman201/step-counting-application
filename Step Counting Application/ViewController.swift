//
//  ViewController.swift
//  Step Counting Application
//
//  Created by Liguo Jiao on 16/6/14.
//  Copyright © 2016年 Liguo Jiao. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cal = NSCalendar.currentCalendar()
        let now = NSDate()
        let calendarComponents = cal.components([NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Year], fromDate: now)
        let timeZone = NSTimeZone.systemTimeZone()
        calendarComponents.hour = 0
        calendarComponents.minute = 0
        calendarComponents.second = 0
        cal.timeZone = timeZone
        
        guard let midnightOfToday = cal.dateFromComponents(calendarComponents) else {
            return
        }
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (CMMotionData: CMMotionActivity?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = CMMotionData {
                        if data.stationary == true {
                            self.status.text = "Stationary"
                        } else if data.walking == true {
                            self.status.text = "Walking"
                        } else if data.running == true {
                            self.status.text = "Running"
                        } else if data.automotive == true {
                            self.status.text = "Automotive"
                        }
                    }
                })
            })
        }
        if CMPedometer.isStepCountingAvailable() {
            let startDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerDataFromDate(startDate, toDate: NSDate(), withHandler: { (CMPData: CMPedometerData?, error:NSError?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = CMPData {
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            })

            self.pedoMeter.startPedometerUpdatesFromDate(midnightOfToday, withHandler: { (CMPData:CMPedometerData?, error:NSError?) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = CMPData {
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}