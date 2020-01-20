//
//  Category.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// TableViewのcellに関連するオブジェクト
class DiaryList: Object {
    @objc dynamic var date = ""
    @objc dynamic var index = ""
    @objc dynamic var day = ""
    @objc dynamic var cellIndicateDate = ""
    @objc dynamic var dayOfWeek = ""
    // 子を指定
    var articles = List<Article>()
    
    convenience init(date: String, index: String, day: String, cellIndicateDate: String, dayOfWeek: String, articles: List<Article>) {
        self.init()
        self.date = date
        self.index = index
        self.day = day
        self.cellIndicateDate = cellIndicateDate
        self.dayOfWeek = dayOfWeek
        self.articles = articles
    }
    
}
