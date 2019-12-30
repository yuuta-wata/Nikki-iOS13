//
//  Date.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/30.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation

// 日付を年、月、日で取得する
enum DateItems {
    struct Request {
        var year: Int
        var month: Int
        var day: Int
        // 初期化
        init(date: Date) {
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.dateComponents([.year, .month, .day], from: date)
            year = date.year!
            month = date.month!
            day = date.day!
        }
    }
}
