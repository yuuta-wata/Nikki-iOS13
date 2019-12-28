//
//  CalendarController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/28.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
// カレンダーに関するデータをリクエストするのに必要なプロトコル
protocol RequestForCalendar {
    // 今月の日付を取得する
    func requestDateManager(request: DateItems.ThisMonth.Request)
    // 今月の週の数を取得する
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request)
    
    // 来月、又は先月の日付を取得する
    func requestDateManager(request: DateItems.MoveMonth.Request)
    // 来月、又は先月の週の数を取得する
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request)
}
// カレンダーリクエストを送るクラス
class CalendarController: RequestForCalendar {
    
    var calendarLogic: CalendarLogic?
    
    func requestDateManager(request: DateItems.ThisMonth.Request) {
        // 今月の日付をリクエストする
        calendarLogic?.dateManager(year: request.year, month: request.month)
    }
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request) {
        // 今月の週の数をリクエストする
        calendarLogic?.numberOfWeeks(year: request.year, month: request.month)
    }
    
    func requestDateManager(request: DateItems.MoveMonth.Request) {
        // 来月、又は先月の日付をリクエストする
        calendarLogic?.dateManager(year: request.year, month: request.month)
    }
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request) {
        // 来月、又は先月の週の数をリクエストする
        calendarLogic?.dateManager(year: request.year, month: request.month)
    }
    
    
}
