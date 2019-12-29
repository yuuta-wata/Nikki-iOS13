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
    
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor.red
        }
        else if weekday == 7 {
            return UIColor.blue
        }

        return nil
    }

}
