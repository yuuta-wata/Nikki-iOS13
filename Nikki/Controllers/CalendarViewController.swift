//
//  CalendarViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/29.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    let dayOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
    var dayOfWeekCount = 0
    var dayOfWeekColorCount = 0
    var dayColorCount = 0
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        // 年月を日本表記に変更
        calendar.appearance.headerDateFormat = "y年MM月"
        
        settingWeek()
        settingWeekColor()
    }
    // 曜日を日本表記に変更
    private func settingWeek() {
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = dayOfWeek[dayOfWeekCount]
            dayOfWeekCount += 1
        }
    }
    // 曜日毎に色を変更
    private func settingWeekColor() {
        for i in 0...6 {
            switch dayOfWeekColorCount {
            case 0:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.red
                dayOfWeekColorCount += 1
            case 6:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.blue
            default:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.black
                dayOfWeekColorCount += 1
            }
        }
    }
}
