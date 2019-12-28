//
//  DateItems.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/27.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
// 日付の取得
enum DateItems {
    // 今月
    enum ThisMonth {
        struct Request {
            var year: Int
            var month: Int
            var day: Int
            // 初期化
            init() {
                // Calendarをグレゴリアンでインスタンス生成
                let calendar = Calendar(identifier: .gregorian)
                // 年、月、日を取得
                let date = calendar.dateComponents([.year, .month, .day], from: Date())
                // 取得した値を代入
                year = date.year!
                month = date.month!
                day = date.day!
            }
        }
    }
    // 来月、先月
    enum MoveMonth {
        struct Request {
            var year: Int
            var month: Int
            // 月の初期設定値を引数に設定
            init(_ monthCounter: Int) {
                let calendar = Calendar(identifier: .gregorian)
                // 新しい日付を生成
                let date = calendar.date(byAdding: .month, value: monthCounter, to: Date())
                // 生成した日付をフォーマット
                let newDate = calendar.dateComponents([.year, .month], from: date!)
                // フォーマットした値を代入
                year = newDate.year!
                month = newDate.month!
            }
        }
    }
}
