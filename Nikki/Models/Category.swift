//
//  Category.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// ホームで表示するセルデータ
class Category: Object {
    @objc dynamic var index: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var week: String = ""
    @objc dynamic var day: String = ""
    @objc dynamic var time: String = ""
    // 子を指定
    var articles = List<Article>()
    
    convenience init(index: String, date: String, week: String, day: String, time: String, articles: List<Article>) {
        self.init()
        self.index = index
        self.date = date
        self.week = week
        self.day = day
        self.time = time
        self.articles = articles
    }
    // 親を指定
//    var parentSection = LinkingObjects(fromType: Section.self, property: "categorys")
    
}
