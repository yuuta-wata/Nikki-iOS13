//
//  CalendarViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/29.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate {
    let dayOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
    var weekCount = 0

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        // 年月を日本表記に変更
        calendar.appearance.headerDateFormat = "y年MM月"
        
        settingWeek()
    }
    // 曜日を日本表記に変更
    private func settingWeek() {
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = dayOfWeek[weekCount]
            weekCount += 1
        }
    }
}

