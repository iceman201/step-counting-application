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
        var cal = Calendar.current
        let now = Date()
        var calendarComponents = (cal as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.year], from: now)
        let timeZone = TimeZone.current
        calendarComponents.hour = 0
        calendarComponents.minute = 0
        calendarComponents.second = 0
        cal.timeZone = timeZone
        
        guard let midnightOfToday = cal.date(from: calendarComponents) else {
            return
        }
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (CMMotionData: CMMotionActivity?) in
                DispatchQueue.main.async(execute: { () -> Void in
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
            let startDate = Date(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerData(from: startDate, to: Date(), withHandler: { (CMPData: CMPedometerData?, error:NSError?) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if let data = CMPData {
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            } as! CMPedometerHandler)

            self.pedoMeter.startUpdates(from: midnightOfToday, withHandler: { (CMPData:CMPedometerData?, error:NSError?) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if let data = CMPData {
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            } as! CMPedometerHandler)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
