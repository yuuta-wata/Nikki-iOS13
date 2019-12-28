//
//  CalendarUseCase.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/27.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
// カレンダーを作成するプロトコル
protocol CalendarLogic {
    // 対象月の日付を生成する
    func dateManager(year: Int, month: Int)
    // 対象月の週の数を生成する
    func numberOfWeeks(year: Int, month: Int)
}
// カレンダーを作成するにあたって必要な計算クラス
class CalendarUseCase: CalendarLogic {
    
    var responseForCalendar: ResponseForCalendar?
    // 一週間を定義
    private let daysPerWeek = 7
    /**
     *うるう年を定義
     *1年を400で割り切れるor1年を4で割り切れる且つ1年を100で割り切れない
    */
    private let isLeapYear = { (year: Int) in year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) }
    // 曜日の計算（ツェラーの公式）
    private let zellerCongruence = {
        (year: Int, month: Int , day: Int) in
        (year + year/4 - year/100 + year/400 + (13 * month + 8)/5 + day) % 7 }
    
    func dateManager(year: Int, month: Int) {
        // 最初の曜日を格納
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        // セルに表示する日数を計算し、値を格納
        let numberOfCells = numberOfWeeks(year, month) * daysPerWeek
        // 月の日数を格納
        let days = numberOfDays(year, month)
        // 1ヶ月を生成し、配列として代入
        let daysArray = aligumentOfDays(firstDayOfWeek, numberOfCells, days)
        responseForCalendar?.responseDateManager(response: daysArray)
    }
    
    func numberOfWeeks(year: Int, month: Int) {
        let weeks = numberOfWeeks(year, month)
        responseForCalendar?.responseNumberOfWeeks(resopnse: weeks)
    }
    
    
}
extension CalendarUseCase {
    // 曜日を求める
    /**
     *対象月が1月か2月の場合はyearを1年引き、monthを12ヶ月足す
     *例えば2019年1月の場合が2018年13月にする
     */
    private func dayOfWeek(_ year: Int, _ month: Int, _ day: Int) -> Int {
        var year = year
        var month = month
        if month == 1 || month == 2 {
            year -= 1
            month += 12
        }
        // ツェラーの公式を返す
        return zellerCongruence(year, month, day)
    }
    // 週の数を求めるメソッド
    private func numberOfWeeks(_ year: Int, _ month: Int) -> Int {
        if conditionFourWeeks(year, month) {
            return 4
        } else if conditionSixWeeks(year, month) {
            return 6
        } else {
            return 5
        }
    }
    // 月の日数を計算する
    private func numberOfDays(_ year: Int, _ month: Int) -> Int {
        var monthMaxDay = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31]
        // うるう年なら2月を29日までとする
        if month == 2, isLeapYear(year) {
            monthMaxDay.updateValue(29, forKey: 2)
        }
        return monthMaxDay[month]!
    }
    
    // 週の数が4つの場合（平年の2月でかつ初日が日曜日で始まる時のみしかない）
    private func conditionFourWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        // 平年且つ、2月であり且つ、日曜日ならtrueを返す
        return !isLeapYear(year) && month == 2 && (firstDayOfWeek == 0)
    }
    //　週の数が6つの場合
    private func conditionSixWeeks(_ year: Int, _ month: Int) -> Bool {
        let firstDayOfWeek = dayOfWeek(year, month, 1)
        let days = numberOfDays(year, month)
        // 祝日が土曜日且つ月の日数が30日 or 祝日が金曜日且つ月の日数が31の場合にtureを返す
        return (firstDayOfWeek == 6 && days == 30) || (firstDayOfWeek >= 5 && days == 31)
    }
    // 1ヶ月を求める
    private func aligumentOfDays(_ firstDayOfWeek: Int, _ numberOfCells: Int, _ days: Int) -> [String] {
        var daysArray: [String] = []
        var dayCount = 0
        // 月のセル数だけループする
        for i in 0 ... numberOfCells {
            let diff = i - firstDayOfWeek
            // セルと曜日の差分が負の値の時 or セルが月の日数を超える時は空を表示させる
            if diff < 0 || dayCount >= days {
                daysArray.append("")
            } else {
                daysArray.append(String(diff + 1))
                dayCount += 1
            }
        }
        return daysArray
    }
}
